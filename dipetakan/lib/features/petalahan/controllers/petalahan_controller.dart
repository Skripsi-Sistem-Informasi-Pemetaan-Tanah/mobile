import 'dart:async';
import 'dart:convert';
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

class PetaLahanController extends GetxController {
  final Completer<GoogleMapController> mapController = Completer();
  final Location location = Location();
  final lahanRepository = Get.put(LahanRepository());
  var currentLocation = Rxn<LocationData>();
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

  void setFilters(List<String> jenisLahan, List<int> statusValidasi) {
    selectedJenisLahan.value = jenisLahan;
    selectedStatusValidasi.value = statusValidasi;
    filterTrigger.value++;
    lahanData.refresh();
  }

  Set<Polygon> buildPolygons() {
    Set<Polygon> polygons = {};

    for (var lahan in lahanData) {
      if (lahan.verifikasi.isNotEmpty) {
        lahan.verifikasi.sort((a, b) => b.verifiedAt.compareTo(a.verifiedAt));

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

        if (newestStatusVerifikasi == 1 || newestStatusVerifikasi == 2) {
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
    markers.clear();

    for (var patokan in lahan.patokan) {
      var coordinates = patokan.coordinates
          .split(',')
          .map((coord) => double.parse(coord.trim()))
          .toList();
      LatLng point = LatLng(coordinates[0], coordinates[1]);

      BitmapDescriptor markerColor = patokan.coordPercent == 100
          ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
          : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);

      markers.add(
        Marker(
          markerId: MarkerId('${point.latitude},${point.longitude}'),
          position: point,
          icon: markerColor,
          infoWindow: InfoWindow(
            title: lahan.namaLahan,
            snippet: 'Koordinat: ${point.latitude}, ${point.longitude}',
          ),
        ),
      );
    }
  }
}
