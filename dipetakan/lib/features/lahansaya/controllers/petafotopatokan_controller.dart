import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dipetakan/data/repositories/tambahlahan/lahan_repository.dart';
import 'package:dipetakan/features/navigation/screens/navigation.dart';
import 'package:dipetakan/features/tambahlahan/models/lahan_model.dart';
import 'package:dipetakan/util/constants/api_constants.dart';
import 'package:dipetakan/util/constants/image_strings.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:dipetakan/util/helpers/network_manager.dart';
import 'package:dipetakan/util/popups/full_screen_loader.dart';
import 'package:dipetakan/util/popups/loaders.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class PetaFotoPatokanController extends GetxController {
  final Completer<GoogleMapController> mapController = Completer();
  final Location location = Location();
  final lahanRepository = Get.put(LahanRepository());
  var currentLocation = Rxn<LocationData>();
  var initialPosition = Rx<LatLng?>(null);
  final RxList<String> selectedJenisLahan = RxList([]);
  final RxList<int> selectedStatusValidasi = RxList([]);
  final RxList<LahanModel> lahanData = RxList([]);
  var markerbitmap = BitmapDescriptor.defaultMarker.obs;
  var patokanList = <PatokanModel>[].obs;
  var loading = false.obs;
  var strLatLong = ''.obs;
  var markers = <Marker>{}.obs;
  var filterTrigger = 0.obs;
  final imagePicker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    fetchDataFromPostgresql();
  }

  Future<void> fetchDataFromPostgresql() async {
    try {
      final serverurl = Uri.parse('$baseUrl/checkConnectionDatabase');
      final http.Response serverresponse = await http.get(serverurl);

      if (serverresponse.statusCode != 200) {
        DLoaders.errorSnackBar(
          title: 'Oh Tidak!',
          message: 'Server or Database is not connected',
        );
        return;
      }

      var url = Uri.parse('$baseUrl/getAllLahan');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('data') &&
            responseData['data'].containsKey('lahan')) {
          List<dynamic> lahanData = responseData['data']['lahan'];

          List<LahanModel> parsedLahanData =
              lahanData.map((lahan) => LahanModel.fromJson(lahan)).toList();

          this.lahanData.assignAll(parsedLahanData);
        } else {
          DLoaders.errorSnackBar(
            title: 'Gagal',
            message: 'Gagal mendapatkan data',
          );
        }
      }
    } catch (error) {
      DLoaders.errorSnackBar(
        title: 'Error fetching PostgreSQL data',
        message: error.toString(),
      );
    }
  }

  void getCurrentLocation() async {
    try {
      final LocationData locationData = await location.getLocation();
      currentLocation.value = locationData;
    } catch (error) {
      DLoaders.errorSnackBar(
          title: 'Error getting location', message: error.toString());
    }
  }

  void setFilters(List<String> jenisLahan, List<int> statusValidasi) {
    selectedJenisLahan.value = jenisLahan;
    selectedStatusValidasi.value = statusValidasi;
    filterTrigger.value++;
    lahanData.refresh();
  }

  Set<Polygon> buildPolygons({required String mapId}) {
    Set<Polygon> polygons = {};

    for (var lahan in lahanData) {
      if (lahan.id != mapId) {
        continue;
      }
      // Check if verifikasi list is not empty
      if (lahan.verifikasi.isNotEmpty) {
        // Sort the verifikasi list by verifiedAt in descending order
        lahan.verifikasi.sort((a, b) => b.verifiedAt.compareTo(a.verifiedAt));

        // Get the newest statusverifikasi
        int newestStatusVerifikasi = lahan.verifikasi.first.statusverifikasi;

        if (selectedJenisLahan.isNotEmpty &&
            !selectedJenisLahan.contains(lahan.jenisLahan)) {
          continue;
        }

        if (selectedStatusValidasi.isNotEmpty) {
          if (lahan.verifikasi.isEmpty) continue;
          lahan.verifikasi.sort((a, b) => b.verifiedAt.compareTo(a.verifiedAt));
          int newestStatusVerifikasi = lahan.verifikasi.first.statusverifikasi;
          if (!selectedStatusValidasi.contains(newestStatusVerifikasi)) {
            continue;
          }
        }

        List<LatLng> polygonPoints = [];

        for (var patokan in lahan.patokan) {
          var coordinates = patokan.coordinates
              .split(',')
              .map((coord) => double.parse(coord.trim()))
              .toList();
          LatLng point = LatLng(coordinates[0], coordinates[1]);
          polygonPoints.add(point);
        }

        Color fillColor;
        Color strokeColor;

        switch (newestStatusVerifikasi) {
          case 0:
            fillColor = Colors.red.withOpacity(0.2);
            strokeColor = Colors.red;
            break;
          case 1:
            fillColor = Colors.yellow.withOpacity(0.2);
            strokeColor = Colors.yellow;
            break;
          case 2:
            fillColor = Colors.green.withOpacity(0.2);
            strokeColor = Colors.green;
            break;
          case 3:
            fillColor = Colors.red.withOpacity(0.2);
            strokeColor = Colors.red;
            break;
          default:
            fillColor = Colors.grey.withOpacity(0.2);
            strokeColor = Colors.grey;
        }

        polygons.add(Polygon(
          polygonId: PolygonId(lahan.id),
          points: polygonPoints,
          strokeColor: strokeColor,
          strokeWidth: 2,
          fillColor: fillColor,
          consumeTapEvents: true,
        ));

        addMarkersForPolygon(lahan, polygonPoints);

        _setMapFitToPolygon(polygonPoints);
      }
    }

    return polygons;
  }

  Set<Marker> buildMarkers({required String mapId}) {
    Set<Marker> markers = {};

    // Iterate through lahanData
    for (var lahan in lahanData) {
      if (lahan.id != mapId) {
        // Skip lahan that does not match the mapId
        continue;
      }
      // Check if verifikasi list is not empty
      if (lahan.verifikasi.isNotEmpty) {
        for (var patokan in lahan.patokan) {
          var coordinates = patokan.coordinates
              .split(',')
              .map((coord) => double.parse(coord.trim()))
              .toList();
          LatLng point = LatLng(coordinates[0], coordinates[1]);
          BitmapDescriptor markerIcon;
          if (patokan.coordComment == 'foto patokan perlu direvisi') {
            // Red marker if coordComment is not null
            markerIcon =
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
          } else {
            // Green marker if coordComment is null
            markerIcon = BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen);
          }
          markers.add(
            Marker(
              markerId: MarkerId('${point.latitude},${point.longitude}'),
              position: point,
              icon: markerIcon,
              infoWindow: InfoWindow(
                title: patokan.coordComment.isEmpty == false
                    ? patokan.coordComment
                    : "Tidak Ada Komentar",
                snippet: 'Coordinate: ${point.latitude}, ${point.longitude}',
                onTap: () => _onMarkerTapped(patokan),
              ),
            ),
          );
        }
      }
    }

    return markers;
  }

  void _onMarkerTapped(PatokanModel patokan) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(patokan.coordComment.isNotEmpty
            ? patokan.coordComment
            : "Tidak Ada Komentar"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            patokan.fotoPatokan.isNotEmpty
                ? Image.network(patokan.fotoPatokan)
                : const Text('No Image'),
            const SizedBox(height: DSizes.spaceBtwItems),
            Text('Coordinates: ${patokan.coordinates}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child:
                const Text(DTexts.close, style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _setMapFitToPolygon(List<LatLng> polygonPoints) {
    if (polygonPoints.isEmpty) return;

    double minLat = polygonPoints.first.latitude;
    double minLong = polygonPoints.first.longitude;
    double maxLat = polygonPoints.first.latitude;
    double maxLong = polygonPoints.first.longitude;

    for (var point in polygonPoints) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLong) minLong = point.longitude;
      if (point.longitude > maxLong) maxLong = point.longitude;
    }

    // ignore: unused_local_variable
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLong),
      northeast: LatLng(maxLat, maxLong),
    );

    double paddingFactor = 0.2;

    LatLngBounds paddedBounds = LatLngBounds(
      southwest: LatLng(
        minLat - (maxLat - minLat) * paddingFactor,
        minLong - (maxLong - minLong) * paddingFactor,
      ),
      northeast: LatLng(
        maxLat + (maxLat - minLat) * paddingFactor,
        maxLong + (maxLong - minLong) * paddingFactor,
      ),
    );

    mapController.future.then((controller) {
      controller.moveCamera(CameraUpdate.newLatLngBounds(paddedBounds, 20));
    });
  }

  void addMarkersForPolygon(LahanModel lahan, List<LatLng> polygonPoints) {
    for (var point in polygonPoints) {
      markers.add(
        Marker(
          markerId: MarkerId('${point.latitude},${point.longitude}'),
          position: point,
          icon: markerbitmap.value,
          infoWindow: InfoWindow(
            title: lahan.namaLahan,
            snippet: 'Coordinate: ${point.latitude}, ${point.longitude}',
          ),
        ),
      );
    }
    update();
  }

  // Function to update only the Foto Patokan
  void updateFotoPatokan(LahanModel existingLahan) async {
    try {
      //Start loading
      DFullScreenLoader.openLoadingDialog(
          DTexts.sedangProses, TImages.docerAnimation);

      //Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        //remove loader
        DFullScreenLoader.stopLoading();
        return;
      }

      // Check server and database connection
      final serverurl = Uri.parse('$baseUrl/checkConnectionDatabase');
      final http.Response serverresponse = await http.get(serverurl);

      if (serverresponse.statusCode != 200) {
        DLoaders.errorSnackBar(
          title: 'Oh Tidak!',
          message: 'Server or Database is not connected',
        );
        DFullScreenLoader.stopLoading();
        return;
      }

      // Upload images and update patokan list
      await uploadPatokanImages();

      // Send updated patokan to Node.js server to update PostgreSQL
      var url = Uri.parse('$baseUrl/updateFotoPatokan');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'map_id': existingLahan.id,
          'koordinat': patokanList.map((patokan) => patokan.toJson()).toList(),
        }),
      );

      if (response.statusCode != 200) {
        DLoaders.errorSnackBar(
            title: 'Oh Tidak!',
            message: '${response.statusCode} + ${response.body}');
        DFullScreenLoader.stopLoading();
        return;
      }

      // Show success message
      DLoaders.successSnackBar(
        title: 'Berhasil',
        message: 'Foto patokan berhasil diubah',
      );

      // Clear patokan list
      patokanList.clear();

      Get.offAll(() => const NavigationMenu());
    } catch (e) {
      DFullScreenLoader.stopLoading();
      DLoaders.errorSnackBar(title: 'Oh Tidak!', message: e.toString());
    }
  }

  Future<void> uploadPatokanImages() async {
    for (int i = 0; i < patokanList.length; i++) {
      final patokan = patokanList[i];
      if (patokan.localPath.isNotEmpty) {
        try {
          // Read the image file
          File imageFile = File(patokan.localPath);

          // Compress the image
          final lahanId = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
          Directory tempDir = await getTemporaryDirectory();
          String tempPath = '${tempDir.path}/new_$lahanId-$i.jpg';
          XFile? compressedImageFile = await compressImage(imageFile, tempPath);

          if (compressedImageFile != null) {
            // Upload the compressed image
            final imageUrl = await lahanRepository.uploadImage(
                'Lahan/Patokan/', compressedImageFile);

            // Find the corresponding patokan based on coordinates
            var updatedPatokanList = patokanList.map((p) {
              if (p.coordinates == patokan.coordinates) {
                return PatokanModel(
                  localPath: patokan.localPath,
                  fotoPatokan: imageUrl,
                  coordinates: patokan.coordinates,
                  coordComment: '',
                  coordCommentUser: 'foto telah diperbarui',
                  coordVerif: patokan.coordVerif,
                  coordStatus: patokan.coordStatus,
                  coordPercent: patokan.coordPercent,
                );
              }
              return p;
            }).toList();

            // Update patokanList with the new list
            patokanList.assignAll(updatedPatokanList);
            patokanList.refresh();

            // Delete the temporary file
            File(compressedImageFile.path).deleteSync();
          } else {
            throw Exception("Image compression failed");
          }
        } catch (e) {
          DLoaders.errorSnackBar(
              title: 'Oh Tidak!', message: 'Failed to upload image: $e');
        }
      }
    }
  }

  Future<void> replaceFotoPatokan(
      BuildContext context, String coordinate) async {
    try {
      loading.value = true;
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.camera);
      loading.value = false;

      if (pickedFile != null) {
        // Create a new list with updated patokan
        List<PatokanModel> updatedPatokanList = patokanList.map((patokan) {
          if (patokan.coordinates == coordinate) {
            return PatokanModel(
              coordinates: patokan.coordinates,
              fotoPatokan: patokan.fotoPatokan,
              coordComment: patokan.coordComment,
              coordCommentUser: patokan.coordCommentUser,
              coordVerif: patokan.coordVerif,
              coordStatus: patokan.coordStatus,
              coordPercent: patokan.coordPercent,
              localPath: pickedFile.path,
            );
          }
          return patokan;
        }).toList();

        // Update patokanList with the new list
        patokanList.assignAll(updatedPatokanList);
        patokanList.refresh();

        if (kDebugMode) {
          print(patokanList);
        }
      }
    } catch (e) {
      loading.value = false;
      DLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  Future<XFile?> compressImage(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 85,
    );
    return result != null ? XFile(result.path) : null;
  }
}
