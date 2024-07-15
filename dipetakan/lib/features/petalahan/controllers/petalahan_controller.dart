import 'dart:async';
import 'dart:convert';
import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dipetakan/data/repositories/tambahlahan/lahan_repository.dart';
import 'package:dipetakan/features/petalahan/screens/widgets/infolahan_bottomsheet.dart';
import 'package:dipetakan/features/tambahlahan/models/lahan_model.dart';
import 'package:dipetakan/util/constants/api_constants.dart';
import 'package:dipetakan/util/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
// import 'package:geolocator/geolocator.dart';

class PetaLahanController extends GetxController {
  final Completer<GoogleMapController> mapController = Completer();
  final Location location = Location();
  // final LahanRepository lahanRepository;
  final lahanRepository = Get.put(LahanRepository());
  var currentLocation = Rxn<LocationData>();
  final RxList<String> selectedJenisLahan = RxList([]);
  // final RxList<int> selectedStatusValidasi = RxList([]);
  final RxList<LahanModel> lahanData = RxList([]);
  var markerbitmap = BitmapDescriptor.defaultMarker.obs;
  var patokanList = <PatokanModel>[].obs;
  var loading = false.obs;
  var strLatLong = ''.obs;
  var markers = <Marker>{}.obs; // Manage markers as a se
  // PetaLahanController({required this.lahanRepository});

  // var selectedJenisLahan = <String>[].obs;
  // var selectedStatusValidasi = <String>[].obs;
  var filterTrigger = 0.obs;
  final imagePicker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    fetchDataFromPostgresql();
    // listenForLahanChanges();
    addCustomMarker();
  }

  // Future<void> _fetchDataFromPostgresql() async {
  //   try {
  //     // Check server and database connection
  //     final serverurl = Uri.parse('$baseUrl/checkConnectionDatabase');
  //     final http.Response serverresponse = await http.get(serverurl);

  //     if (serverresponse.statusCode != 200) {
  //       DLoaders.errorSnackBar(
  //         title: 'Oh Snap!',
  //         message: 'Server or Database is not connected',
  //       );
  //       return;
  //     }

  //     var url = Uri.parse('$baseUrl/getAllLahan');
  //     var response = await http.get(url);

  //     if (response.statusCode == 200) {
  //       Map<String, dynamic> responseData = json.decode(response.body);

  //       final FirebaseFirestore db = FirebaseFirestore.instance;
  //       WriteBatch batch = db.batch();

  //       if (responseData.containsKey('data') &&
  //           responseData['data'].containsKey('lahan')) {
  //         List<dynamic> lahanData = responseData['data']['lahan'];

  //         for (var lahan in lahanData) {
  //           String userId = lahan['user_id'];
  //           String mapId = lahan['map_id'];
  //           DocumentReference lahanRef = db.collection('Lahan').doc(mapId);
  //           DocumentReference userLahanRef = db
  //               .collection('Users')
  //               .doc(userId)
  //               .collection('Lahan')
  //               .doc(mapId);

  //           // Convert updated_at to Firestore Timestamp
  //           if (lahan.containsKey('updated_at')) {
  //             String updatedAtString = lahan['updated_at'];
  //             Timestamp updatedAt = Timestamp.fromMillisecondsSinceEpoch(
  //                 DateTime.parse(updatedAtString).millisecondsSinceEpoch);
  //             lahan['updated_at'] = updatedAt;
  //           }

  //           Map<String, dynamic> lahanDataToUpdate = {
  //             'koordinat':
  //                 lahan.containsKey('koordinat') ? lahan['koordinat'] : [],
  //             'verifikasi':
  //                 lahan.containsKey('verifikasi') ? lahan['verifikasi'] : [],
  //             'updated_at': lahan['updated_at'],
  //           };

  //           // Update verifikasi 'updated_at' to Firestore Timestamp
  //           if (lahan.containsKey('verifikasi')) {
  //             List<dynamic> verifikasiList = lahan['verifikasi'];
  //             for (var verifikasi in verifikasiList) {
  //               if (verifikasi.containsKey('updated_at')) {
  //                 String verifikasiUpdatedAtString = verifikasi['updated_at'];
  //                 Timestamp verifikasiUpdatedAt =
  //                     Timestamp.fromMillisecondsSinceEpoch(
  //                         DateTime.parse(verifikasiUpdatedAtString)
  //                             .millisecondsSinceEpoch);
  //                 verifikasi['updated_at'] = verifikasiUpdatedAt;
  //               }
  //             }
  //             lahanDataToUpdate['verifikasi'] = verifikasiList;
  //           }

  //           batch.set(lahanRef, lahanDataToUpdate, SetOptions(merge: true));
  //           batch.set(userLahanRef, lahanDataToUpdate, SetOptions(merge: true));
  //         }
  //       }

  //       await batch.commit();
  //       // DLoaders.successSnackBar(
  //       //   title: 'Success',
  //       //   message: 'Data updated successfully in Firestore',
  //       // );
  //       listenForLahanChanges();
  //     } else {
  //       DLoaders.errorSnackBar(
  //         title: 'Fail',
  //         message: 'Failed to fetch data',
  //       );
  //     }
  //   } catch (error) {
  //     DLoaders.errorSnackBar(
  //       title: 'Error fetching PostgreSQL data',
  //       message: error.toString(),
  //     );
  //   }
  // }

  void addMarker(LatLng position, String imagePath) {
    Marker marker = Marker(
      markerId: MarkerId(position.toString()),
      position: position,
      icon: markerbitmap.value,
      onTap: () {
        showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (imagePath.isNotEmpty) Image.file(File(imagePath)),
                  Text(
                      'Coordinates: ${position.latitude}, ${position.longitude}')
                ],
              ),
            );
          },
        );
      },
    );

    markers.add(marker); // Add the marker to the set
  }

  Future<void> addPatokan(BuildContext context, LatLng? tappedPosition) async {
    try {
      bool hasLandmarks = await _showLandmarkDialog(context);
      LatLng? position;
      position = tappedPosition;
      strLatLong.value = '${position?.latitude}, ${position?.longitude}';

      if (hasLandmarks) {
        final pickedFile =
            await imagePicker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          patokanList.add(
            PatokanModel(
                localPath: pickedFile.path,
                fotoPatokan: '',
                coordinates: strLatLong.value),
          );
          addMarker(position!, pickedFile.path);
        }
      } else {
        patokanList.add(
          PatokanModel(
              localPath: '', fotoPatokan: '', coordinates: strLatLong.value),
        );
        addMarker(position!, '');
      }
    } catch (e) {
      loading.value = false;
      Get.snackbar('Oh Snap!', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // void addMarker(LatLng position, String imagePath) {
  //   Marker marker = Marker(
  //     markerId: MarkerId(position.toString()),
  //     position: position,
  //     icon: markerbitmap.value,
  //     onTap: () {
  //       showDialog(
  //         context: Get.context!,
  //         builder: (context) {
  //           return AlertDialog(
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 if (imagePath.isNotEmpty) Image.file(File(imagePath)),
  //                 Text(
  //                     'Coordinates: ${position.latitude}, ${position.longitude}')
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );

  //   markers.add(marker); // Add the marker to the set
  // }

  // Future<void> addPatokan(BuildContext context) async {
  //   try {
  //     bool hasLandmarks = await _showLandmarkDialog(context);
  //     // loading.value = true;
  //     // Position position = await getGeoLocationPosition();
  //     // loading.value = false;
  //     strLatLong.value = '${position.latitude}, ${position.longitude}';

  //     if (hasLandmarks) {
  //       final pickedFile =
  //           await imagePicker.pickImage(source: ImageSource.camera);
  //       if (pickedFile != null) {
  //         patokanList.add(
  //           PatokanModel(
  //               localPath: pickedFile.path,
  //               fotoPatokan: '',
  //               coordinates: strLatLong.value),
  //         );
  //         LatLng latLng = LatLng(position.latitude, position.longitude);
  //         addMarker(latLng, pickedFile.path);
  //       }
  //     } else {
  //       patokanList.add(
  //         PatokanModel(
  //             localPath: '', fotoPatokan: '', coordinates: strLatLong.value),
  //       );
  //       LatLng latLng = LatLng(position.latitude, position.longitude);
  //       addMarker(latLng, '');
  //     }
  //   } catch (e) {
  //     loading.value = false;
  //     Get.snackbar('Oh Snap!', e.toString(),
  //         snackPosition: SnackPosition.BOTTOM);
  //   }
  // }

  Future<bool> _showLandmarkDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true, // Allow dismissing when touching outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Apakah terdapat patokan?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Yes, there are landmarks
              },
              child: const Text("Ya"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No, there are no landmarks
              },
              child: const Text("Tidak"),
            ),
          ],
        );
      },
    );

    return result ?? false; // Default to false if result is null
  }

  Future<void> fetchDataFromPostgresql() async {
    try {
      final serverurl = Uri.parse('$baseUrl/checkConnectionDatabase');
      final http.Response serverresponse = await http.get(serverurl);

      if (serverresponse.statusCode != 200) {
        DLoaders.errorSnackBar(
          title: 'Oh Snap!',
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
            title: 'Fail',
            message: 'Failed to fetch data',
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
      // print("Error getting location: $error");
    }
  }

  // void fetchData() async {
  //   try {
  //     var data = await lahanRepository.fetchAllLahan();
  //     lahanData.value = data;
  //   } catch (e) {
  //     DLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
  //     // print("Failed to fetch data: $e");
  //   }
  // }

  // void listenForLahanChanges() async {
  //   try {
  //     await _fetchDataFromPostgresql();
  //     lahanRepository.fetchAllLahan().listen((data) {
  //       lahanData.value = data;
  //       // DLoaders.successSnackBar(
  //       //     title: 'Success', message: 'lahanData: $lahanData');
  //       // print('lahanData: $lahanData'); // Print lahanData here
  //     }, onError: (error) {
  //       DLoaders.errorSnackBar(title: 'Oh Snap!', message: error.toString());
  //     });
  //   } catch (e) {
  //     DLoaders.errorSnackBar(title: 'Error', message: e.toString());
  //   }
  // }

  // void listenForLahanChanges() {
  //   try {
  //     lahanRepository.fetchAllLahan().listen((data) {
  //       lahanData.value = data;
  //     }, onError: (error) {
  //       DLoaders.errorSnackBar(
  //         title: 'Error listening to changes',
  //         message: error.toString(),
  //       );
  //     });
  //   } catch (e) {
  //     DLoaders.errorSnackBar(
  //       title: 'Error listening to changes',
  //       message: e.toString(),
  //     );
  //   }
  // }

  void addCustomMarker() async {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), 'assets/images/location_icon.png')
        .then((markerIcon) {
      markerbitmap.value = markerIcon;
    });
  }

  void setFilters(List<String> jenisLahan, List<int> statusValidasi) {
    selectedJenisLahan.value = jenisLahan;
    // selectedStatusValidasi.value = statusValidasi;
    filterTrigger.value++;
    lahanData.refresh();
    // lahanData.update((val) => val); // Trigger rebuild
  }

  Set<Polygon> buildPolygons() {
    Set<Polygon> polygons = {};

    // Iterate through lahanData
    for (var lahan in lahanData) {
      // Check if verifikasi list is not empty
      if (lahan.verifikasi.isNotEmpty) {
        // Sort the verifikasi list by verifiedAt in descending order
        lahan.verifikasi.sort((a, b) => b.verifiedAt.compareTo(a.verifiedAt));

        // // Get the newest statusverifikasi
        // String newestStatusVerifikasi =
        //     lahan.verifikasi.first.statusverifikasi.trim(); // Trim whitespace

        // Get the newest statusverifikasi
        int newestStatusVerifikasi = lahan.verifikasi.first.statusverifikasi;

        if (selectedJenisLahan.isNotEmpty &&
            !selectedJenisLahan.contains(lahan.jenisLahan)) {
          continue;
        }

        // if (selectedStatusValidasi.isNotEmpty) {
        //   if (lahan.verifikasi.isEmpty) continue;
        //   lahan.verifikasi.sort((a, b) => b.verifiedAt.compareTo(a.verifiedAt));
        //   int newestStatusVerifikasi = lahan.verifikasi.first.statusverifikasi;
        //   if (!selectedStatusValidasi.contains(newestStatusVerifikasi)) {
        //     continue;
        //   }
        // }

        List<LatLng> polygonPoints = [];

        for (var patokan in lahan.patokan) {
          var coordinates = patokan.coordinates
              .split(',')
              .map((coord) => double.parse(coord.trim()))
              .toList();
          polygonPoints.add(LatLng(coordinates[0], coordinates[1]));
        }

        Color fillColor = Colors.red; // Default color for "belum tervalidasi"
        if (newestStatusVerifikasi == 0 & 1) {
          fillColor = Colors.yellow; // Change color for "sudah tervalidasi"
        }

        Color strokeColor = Colors.red; // Default color for "belum tervalidasi"
        if (newestStatusVerifikasi == 2) {
          strokeColor = Colors.yellow; // Change color for "sudah tervalidasi"
        }

        polygons.add(Polygon(
          polygonId: PolygonId(lahan.namaLahan),
          points: polygonPoints,
          strokeColor: strokeColor,
          strokeWidth: 2,
          fillColor: fillColor.withOpacity(0.2),
          consumeTapEvents: true,
          onTap: () async {
            await showModalBottomSheet<dynamic>(
                backgroundColor: Colors.white,
                context: Get.context!,
                builder: (context) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.28,
                    child: InfoLahanBottomSheet(lahan: lahan)));
          },
        ));
      }
    }

    return polygons;
  }

  // Set<Polygon> buildPolygons() {
  //   Set<Polygon> polygons = {};

  //   for (var lahan in lahanData) {
  //     List<LatLng> polygonPoints = [];

  //     for (var patokan in lahan.patokan) {
  //       var coordinates = patokan.coordinates
  //           .split(',')
  //           .map((coord) => double.parse(coord.trim()))
  //           .toList();
  //       polygonPoints.add(LatLng(coordinates[0], coordinates[1]));
  //     }

  //     polygons.add(Polygon(
  //       polygonId: PolygonId(lahan.namaLahan),
  //       points: polygonPoints,
  //       strokeColor: Colors.yellow,
  //       strokeWidth: 2,
  //       fillColor: Colors.yellow.withOpacity(0.2),
  //       consumeTapEvents: true,
  //       onTap: () async {
  //         await showModalBottomSheet<dynamic>(
  //             backgroundColor: Colors.white,
  //             context: Get.context!,
  //             builder: (context) => SizedBox(
  //                 height: MediaQuery.of(context).size.height * 0.28,
  //                 child: InfoLahanBottomSheet(lahan: lahan)));
  //       },
  //     ));
  //   }

  //   return polygons;
  // }
}
