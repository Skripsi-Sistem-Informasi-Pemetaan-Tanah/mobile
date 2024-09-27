import 'dart:async';
import 'dart:convert';
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
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class PetaValidasiController extends GetxController {
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
  bool isAgreed = false;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    fetchDataFromPostgresql();
    addCustomMarker();
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
        title: 'Error',
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

  void addCustomMarker() async {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), 'assets/images/location_icon.png')
        .then((markerIcon) {
      markerbitmap.value = markerIcon;
    });
  }

  void setFilters(List<String> jenisLahan, List<int> statusValidasi) {
    selectedJenisLahan.value = jenisLahan;
    selectedStatusValidasi.value = statusValidasi;
    filterTrigger.value++;
    lahanData.refresh();
    // lahanData.update((val) => val); // Trigger rebuild
  }

  Set<Polygon> buildPolygons({required String mapId}) {
    Set<Polygon> polygons = {};

    // Iterate through lahanData
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

        Color fillColor = Colors.red;
        if (newestStatusVerifikasi == 0 & 1) {
          fillColor = Colors.yellow;
        }

        Color strokeColor = Colors.red;
        if (newestStatusVerifikasi == 2) {
          strokeColor = Colors.green;
        }

        polygons.add(Polygon(
          polygonId: PolygonId(lahan.id),
          points: polygonPoints,
          strokeColor: strokeColor,
          strokeWidth: 2,
          fillColor: fillColor.withOpacity(0.2),
          consumeTapEvents: true,
        ));
        _setMapFitToPolygon(polygonPoints);
      }
    }

    return polygons;
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

    // Define the padding factor
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

  Set<Marker> buildMarkers({required String mapId}) {
    // Set<Marker> markers = {};

    // Iterate through lahanData
    for (var lahan in lahanData) {
      if (lahan.id != mapId) {
        // Skip lahan that does not match the mapId
        continue;
      }
      // Check if verifikasi list is not empty
      if (lahan.verifikasi.isNotEmpty) {
        for (var patokan in lahan.patokan) {
          var coordinates = patokan.coordVerif
              .split(',')
              .map((coord) => double.parse(coord.trim()))
              .toList();
          LatLng point = LatLng(coordinates[0], coordinates[1]);
          BitmapDescriptor markerIcon;

          if (patokan.coordStatus == 1) {
            markerIcon = BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen);
          } else if (patokan.coordStatus == 0 && patokan.isAgreed == false) {
            markerIcon =
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
          } else {
            markerIcon =
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
          }

          markers.add(
            Marker(
              markerId: MarkerId('${point.latitude},${point.longitude}'),
              position: point,
              icon: markerIcon,
              infoWindow: InfoWindow(
                title: "Tap untuk validasi",
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
    TextEditingController commentController = TextEditingController();

    Get.dialog(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: const Text("Validasi Titik Koordinat"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                    "Apakah anda menyetujui titik koordinat yang diberikan validator?"),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        fillColor: WidgetStateProperty.all(Colors.green),
                        title: const Text('Setuju'),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        value: true,
                        groupValue: patokan.isAgreed,
                        onChanged: (bool? value) {
                          setState(() {
                            patokan.isAgreed = value ?? true;
                            // patokan.coordStatus = 1;
                            // patokan.coordStatus = patokan.isAgreed ? 1 : 0;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        fillColor: WidgetStateProperty.all(Colors.green),
                        title: const Text('Tidak Setuju'),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        value: false,
                        groupValue: patokan.isAgreed,
                        onChanged: (bool? value) {
                          setState(() {
                            patokan.isAgreed = value ?? false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                if (!patokan.isAgreed)
                  TextFormField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      labelText: 'Komentar',
                      // hintText: 'Masukkan komentar Anda',
                    ),
                  ),
              ],
            ),
            actions: [
              SizedBox(
                width: DSizes.buttonWidth,
                child: ElevatedButton(
                  onPressed: () {
                    if (patokan.isAgreed == true) {
                      patokan.coordStatus = 1;
                      patokan.coordCommentUser = 'koordinat sudah disetujui';
                    } else if (patokan.isAgreed == false) {
                      patokan.coordStatus = 0;
                      patokan.coordCommentUser = commentController.text;
                    }

                    // Find and update the patokan in patokanList
                    final index = patokanList.indexWhere(
                        (element) => element.coordVerif == patokan.coordVerif);
                    if (index != -1) {
                      patokanList[index] = patokan;
                    }

                    markers.refresh();

                    update();
                    Get.back();
                  },
                  child: const Text(DTexts.save),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text(DTexts.close,
                    style: TextStyle(color: Colors.black)),
              ),
            ],
          );
        },
      ),
    );
  }

  // Function to update only the Foto Patokan
  void verifikasiKoordinat(LahanModel existingLahan) async {
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

      // Prepare the data to be submitted
      final updatedLahan = {
        'map_id': existingLahan.id,
        'koordinat': existingLahan.patokan.map((patokan) {
          return {
            'status': patokan.coordStatus,
            'komentar': patokan.coordComment,
            'komentar_mobile': patokan.coordCommentUser,
            'koordinat': patokan.coordVerif,
            'koordinat_verif': patokan.coordVerif,
          };
        }).toList(),
      };

      // Send updated patokan to Node.js server to update PostgreSQL
      var url = Uri.parse('$baseUrl/verifikasiKoordinat');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(updatedLahan),
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
        title: 'Berhasil!',
        message: 'Titik koordinat berhasil divalidasi oleh Anda',
      );

      // Clear patokan list
      patokanList.clear();

      Get.offAll(() => const NavigationMenu());
    } catch (e) {
      DFullScreenLoader.stopLoading();
      DLoaders.errorSnackBar(title: 'Oh Tidak!', message: e.toString());
    }
  }

  LatLng? getInitialCameraPosition(String mapId) {
    for (var lahan in lahanData) {
      if (kDebugMode) {
        print('Checking lahan with id: ${lahan.id}');
      }
      if (lahan.id == mapId) {
        if (kDebugMode) {
          print('Found matching lahan');
        }
        if (lahan.patokan.isNotEmpty) {
          var firstPatokan = lahan.patokan.first;
          var coordinates = firstPatokan.coordinates
              .split(',')
              .map((coord) => double.parse(coord.trim()))
              .toList();
          if (coordinates.length >= 2) {
            return LatLng(coordinates[0], coordinates[1]);
          }
        }
        return null;
      }
    }
    return null;
  }

  void setInitialCameraPosition(String mapId) {
    try {
      LatLng? position = getInitialCameraPosition(mapId);
      initialPosition.value = position;
    } catch (error) {
      DLoaders.errorSnackBar(
          title: 'Error getting location', message: error.toString());
    }
  }
}
