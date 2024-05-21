import 'dart:async';
import 'package:dipetakan/data/repositories/tambahlahan/lahan_repository.dart';
import 'package:dipetakan/features/petalahan/screens/widgets/infolahan_bottomsheet.dart';
import 'package:dipetakan/util/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class PetaLahanController extends GetxController {
  final Completer<GoogleMapController> mapController = Completer();
  final Location location = Location();
  // final LahanRepository lahanRepository;
  final lahanRepository = Get.put(LahanRepository());

  // PetaLahanController({required this.lahanRepository});

  var currentLocation = Rxn<LocationData>();
  var lahanData = <dynamic>[].obs;
  var markerbitmap = BitmapDescriptor.defaultMarker.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    fetchData();
    addCustomMarker();
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

  void fetchData() async {
    try {
      var data = await lahanRepository.fetchAllLahan();
      lahanData.value = data;
    } catch (e) {
      DLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      // print("Failed to fetch data: $e");
    }
  }

  void addCustomMarker() async {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), 'assets/images/location_icon.png')
        .then((markerIcon) {
      markerbitmap.value = markerIcon;
    });
  }

  Set<Polygon> buildPolygons() {
    Set<Polygon> polygons = {};

    for (var lahan in lahanData) {
      List<LatLng> polygonPoints = [];

      for (var patokan in lahan.patokan) {
        var coordinates = patokan.coordinates
            .split(',')
            .map((coord) => double.parse(coord.trim()))
            .toList();
        polygonPoints.add(LatLng(coordinates[0], coordinates[1]));
      }

      polygons.add(Polygon(
        polygonId: PolygonId(lahan.namaLahan),
        points: polygonPoints,
        strokeColor: Colors.yellow,
        strokeWidth: 2,
        fillColor: Colors.yellow.withOpacity(0.2),
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

    return polygons;
  }
}
