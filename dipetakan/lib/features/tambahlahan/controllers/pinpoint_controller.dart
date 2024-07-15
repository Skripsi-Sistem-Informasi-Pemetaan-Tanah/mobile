import 'dart:async';
import 'dart:io';
import 'package:dipetakan/data/repositories/tambahlahan/lahan_repository.dart';
import 'package:dipetakan/features/tambahlahan/models/lahan_model.dart';
import 'package:dipetakan/util/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:image_picker/image_picker.dart';
import 'tambahlahan_controller.dart'; // Import TambahLahanController

class PinPointController extends GetxController {
  final Completer<GoogleMapController> mapController = Completer();
  final Location location = Location();
  final lahanRepository = Get.put(LahanRepository());
  var currentLocation = Rxn<LocationData>();
  final RxList<LahanModel> lahanData = RxList([]);
  var markerbitmap = BitmapDescriptor.defaultMarker.obs;
  var loading = false.obs;
  var strLatLong = ''.obs;
  var markers = <Marker>{}.obs;
  var filterTrigger = 0.obs;
  final imagePicker = ImagePicker();

  final TambahLahanController tambahLahanController =
      Get.find(); // Use existing TambahLahanController

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

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

    markers.add(marker);
  }

  Future<void> addPatokan(BuildContext context, LatLng? tappedPosition) async {
    try {
      bool hasLandmarks = await _showLandmarkDialog(context);
      LatLng? position = tappedPosition;
      strLatLong.value = '${position?.latitude}, ${position?.longitude}';

      if (hasLandmarks) {
        final pickedFile =
            await imagePicker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          PatokanModel newPatokan = PatokanModel(
            localPath: pickedFile.path,
            fotoPatokan: '',
            coordinates: strLatLong.value,
          );
          tambahLahanController.patokanList
              .add(newPatokan); // Add to the shared controller list
          addMarker(position!, pickedFile.path);
        }
      } else {
        PatokanModel newPatokan = PatokanModel(
          localPath: '',
          fotoPatokan: '',
          coordinates: strLatLong.value,
        );
        tambahLahanController.patokanList
            .add(newPatokan); // Add to the shared controller list
        addMarker(position!, '');
      }
    } catch (e) {
      loading.value = false;
      Get.snackbar('Oh Snap!', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<bool> _showLandmarkDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Apakah terdapat patokan?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Ya"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Tidak"),
            ),
          ],
        );
      },
    );

    return result ?? false;
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
}
