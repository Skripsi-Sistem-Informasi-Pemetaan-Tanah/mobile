import 'dart:async';
import 'dart:convert';
// import 'dart:io';
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
  final RxList<int> selectedStatusValidasi = RxList([]);
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
    // addCustomMarker();
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
      // print("Error getting location: $error");
    }
  }

  // void fetchData() async {
  //   try {
  //     var data = await lahanRepository.fetchAllLahan();
  //     lahanData.value = data;
  //   } catch (e) {
  //     DLoaders.errorSnackBar(title: 'Oh Tidak!', message: e.toString());
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
  //       DLoaders.errorSnackBar(title: 'Oh Tidak!', message: error.toString());
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

  // void addCustomMarker() async {
  //   BitmapDescriptor.fromAssetImage(
  //           const ImageConfiguration(), 'assets/images/location_icon.png')
  //       .then((markerIcon) {
  //     markerbitmap.value = markerIcon;
  //   });
  // }

  void setFilters(List<String> jenisLahan, List<int> statusValidasi) {
    selectedJenisLahan.value = jenisLahan;
    selectedStatusValidasi.value = statusValidasi;
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

        if (selectedStatusValidasi.isNotEmpty) {
          if (lahan.verifikasi.isEmpty) continue;
          lahan.verifikasi.sort((a, b) => b.verifiedAt.compareTo(a.verifiedAt));
          int newestStatusVerifikasi = lahan.verifikasi.first.statusverifikasi;
          if (!selectedStatusValidasi.contains(newestStatusVerifikasi)) {
            continue;
          }
        }

        if (newestStatusVerifikasi == 1 || newestStatusVerifikasi == 2
            //  || newestStatusVerifikasi == 0
            ) {
          List<LatLng> polygonPoints = [];

          for (var patokan in lahan.patokan) {
            var coordinates = patokan.coordinates
                .split(',')
                .map((coord) => double.parse(coord.trim()))
                .toList();
            LatLng point = LatLng(coordinates[0], coordinates[1]);
            polygonPoints.add(point);

            // Add marker for each coordinate
            // markers.add(
            //   Marker(
            //     markerId: MarkerId('${point.latitude},${point.longitude}'),
            //     position: point,
            //     icon: markerbitmap.value,
            //     infoWindow: InfoWindow(
            //       title: lahan.namaLahan,
            //       snippet: 'Coordinate: ${point.latitude}, ${point.longitude}',
            //     ),
            //   ),
            // );
          }

          // Determine fill and stroke color based on the newestStatusVerifikasi
          Color fillColor;
          Color strokeColor;

          switch (newestStatusVerifikasi) {
            case 0:
              fillColor =
                  Colors.red.withOpacity(0.2); // Red with some transparency
              strokeColor = Colors.red; // Solid red
              break;
            case 1:
              fillColor = Colors.yellow
                  .withOpacity(0.2); // Yellow with some transparency
              strokeColor = Colors.yellow; // Solid yellow
              break;
            case 2:
              fillColor =
                  Colors.green.withOpacity(0.2); // Green with some transparency
              strokeColor = Colors.green; // Solid green
              break;
            case 3:
              fillColor =
                  Colors.red.withOpacity(0.2); // Red with some transparency
              strokeColor = Colors.red; // Solid red
              break;
            default:
              fillColor = Colors.grey
                  .withOpacity(0.2); // Default grey for unknown status
              strokeColor = Colors.grey; // Default grey for unknown status
          }

          polygons.add(Polygon(
            polygonId: PolygonId(lahan.namaLahan),
            points: polygonPoints,
            strokeColor: strokeColor,
            strokeWidth: 2,
            fillColor: fillColor,
            consumeTapEvents: true,
            onTap: () async {
              addMarkersForPolygon(lahan, polygonPoints);
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
    }

    return polygons;
  }

  void addMarkersForPolygon(LahanModel lahan, List<LatLng> polygonPoints) {
    markers.clear(); // Clear existing markers

    for (var patokan in lahan.patokan) {
      var coordinates = patokan.coordinates
          .split(',')
          .map((coord) => double.parse(coord.trim()))
          .toList();
      LatLng point = LatLng(coordinates[0], coordinates[1]);

      // Check the coordPercent and set the marker color
      BitmapDescriptor markerColor = patokan.coordPercent == 100
          ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
          : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);

      markers.add(
        Marker(
          markerId: MarkerId('${point.latitude},${point.longitude}'),
          position: point,
          icon: markerColor,
          infoWindow: InfoWindow(
            title: 'Status Koordinat : ${patokan.coordPercent}%',
            snippet: 'Koordinat: ${point.latitude}, ${point.longitude}',
          ),
        ),
      );
    }
  }

  // void addMarkersForPolygon(LahanModel lahan, List<LatLng> polygonPoints) {
  //   markers.clear(); // Clear existing markers

  //   for (var point in polygonPoints) {
  //     markers.add(
  //       Marker(
  //         markerId: MarkerId('${point.latitude},${point.longitude}'),
  //         position: point,
  //         icon: markerbitmap.value,
  //         infoWindow: InfoWindow(
  //           title: lahan.namaLahan,
  //           snippet: 'Coordinate: ${point.latitude}, ${point.longitude}',
  //         ),
  //       ),
  //     );
  //   }
  // }

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
