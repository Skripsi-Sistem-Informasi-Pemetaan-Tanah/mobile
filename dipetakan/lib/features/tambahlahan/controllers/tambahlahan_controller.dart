import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dipetakan/data/repositories/tambahlahan/lahan_repository.dart';
import 'package:dipetakan/features/navigation/screens/navigation.dart';
import 'package:dipetakan/features/tambahlahan/models/jenislahanmodel.dart';
import 'package:dipetakan/features/tambahlahan/models/lahan_model.dart';
import 'package:dipetakan/util/constants/image_strings.dart';
import 'package:dipetakan/util/helpers/network_manager.dart';
import 'package:dipetakan/util/popups/full_screen_loader.dart';
import 'package:dipetakan/util/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class TambahLahanController extends GetxController {
  static TambahLahanController get instance => Get.find();

  final namaLahanController = TextEditingController();
  final deskripsiLahanController = TextEditingController();
  final ValueNotifier<JenisLahanDataModel?> jenisLahanNotifier =
      ValueNotifier<JenisLahanDataModel?>(null);
  final imagePicker = ImagePicker();
  final profileLoading = false.obs;
  final lahanRepository = Get.put(LahanRepository());
  Rx<LahanModel> lahan = LahanModel.empty().obs;

  var patokanList = <PatokanModel>[].obs;
  var strLatLong = 'Belum mendapatkan Lat dan Long'.obs;
  var loading = false.obs;

  final GlobalKey<FormState> tambahLahanFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    getGeoLocationPosition();
  }

  Future<Position> getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location service Not Enabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permission denied forever, we cannot access');
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> addPatokan(BuildContext context) async {
    try {
      bool hasLandmarks = await _showLandmarkDialog(context);
      loading.value = true;
      Position position = await getGeoLocationPosition();
      loading.value = false;
      strLatLong.value = '${position.latitude}, ${position.longitude}';

      if (hasLandmarks) {
        final pickedFile =
            await imagePicker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          // Upload the image to Firebase Storage and get the URL
          // final imageUrl =
          //     await lahanRepository.uploadImage('Patokan/Images/', pickedFile);
          patokanList.add(
            PatokanModel(
                localPath: pickedFile.path,
                fotoPatokan: '',
                coordinates: strLatLong.value),
          );
        }
      } else {
        patokanList.add(
          PatokanModel(
              localPath: '', fotoPatokan: '', coordinates: strLatLong.value),
        );
      }
    } catch (e) {
      loading.value = false;
      Get.snackbar('Oh Snap!', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> replacePatokan(BuildContext context, int index) async {
    try {
      bool hasLandmarks = await _showLandmarkDialog(context);
      loading.value = true;
      Position position = await getGeoLocationPosition();
      loading.value = false;
      strLatLong.value = '${position.latitude}, ${position.longitude}';

      if (hasLandmarks) {
        final pickedFile =
            await imagePicker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          // Upload the image to Firebase Storage and get the URL
          // final imageUrl =
          //     await lahanRepository.uploadImage('Patokan/Images/', pickedFile);
          patokanList[index] = PatokanModel(
              localPath: pickedFile.path,
              fotoPatokan: '',
              coordinates: strLatLong.value);
        }
      } else {
        patokanList[index] = PatokanModel(
            localPath: '', fotoPatokan: '', coordinates: strLatLong.value);
      }
    } catch (e) {
      loading.value = false;
      Get.snackbar('Oh Snap!', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<bool> _showLandmarkDialog(BuildContext context) async {
    return await showDialog(
      context: context,
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
  }

  Future<void> deletePatokan(int index) async {
    try {
      final patokan = patokanList[index];
      if (patokan.fotoPatokan.isNotEmpty) {
        await lahanRepository.deleteImage(patokan.fotoPatokan);
      }
      patokanList.removeAt(index);
    } catch (e) {
      Get.snackbar('Oh Snap!', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> uploadPatokanImages() async {
    for (int i = 0; i < patokanList.length; i++) {
      final patokan = patokanList[i];
      if (patokan.localPath.isNotEmpty) {
        try {
          final imageUrl = await lahanRepository.uploadImage(
              'Lahan/Patokan/', XFile(patokan.localPath));
          patokanList[i] = PatokanModel(
            localPath: patokan.localPath,
            fotoPatokan: imageUrl,
            coordinates: patokan.coordinates,
          );
        } catch (e) {
          Get.snackbar('Oh Snap!', 'Failed to upload image: $e',
              snackPosition: SnackPosition.BOTTOM);
        }
      }
    }
  }

  // Function to validate and save tambah lahan form
  void saveTambahLahanForm() async {
    try {
      //Start loading
      DFullScreenLoader.openLoadingDialog(
          'We are processing your information', TImages.docerAnimation);

      //Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        //remove loader
        DFullScreenLoader.stopLoading();
        return;
      }
      //Form validation
      if (!tambahLahanFormKey.currentState!.validate()) {
        //remove loader
        DFullScreenLoader.stopLoading();
        return;
      }

      final namaLahan = namaLahanController.text.trim();
      final jenisLahan = jenisLahanNotifier.value?.jenisLahan ?? '';
      final deskripsiLahan = deskripsiLahanController.text.trim();

      if (patokanList.isEmpty) {
        DLoaders.warningSnackBar(
          title: 'Add Patokan',
          message: 'Please add at least one patokan for the lahan.',
        );
        return;
      }

      // Generate a unique ID for the new document
      final newDocRef = FirebaseFirestore.instance.collection('Lahan').doc();
      final lahanId = newDocRef.id;

      // // Update patokanList with URLs
      // for (int i = 0; i < patokanList.length; i++) {
      //   if (patokanList[i].fotoPatokan.isNotEmpty) {
      //     final imageUrl = await lahanRepository.uploadImage(
      //         'Patokan/Images/', XFile(patokanList[i].fotoPatokan));
      //     patokanList[i] = PatokanModel(
      //         fotoPatokan: imageUrl, coordinates: patokanList[i].coordinates);
      //   }
      // }

      // Upload images and update patokan list
      await uploadPatokanImages();

      final lahan = LahanModel(
        id: lahanId,
        namaLahan: namaLahan,
        jenisLahan: jenisLahan,
        deskripsiLahan: deskripsiLahan,
        patokan: patokanList,
        statusverifikasi: 'Pending',
        progress: 0,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );

      // Save the document using the generated ID
      await newDocRef.set(lahan.toJson());

      lahanRepository.saveLahanRecord(lahan);

      // Show success message
      DLoaders.successSnackBar(
        title: 'Success',
        message: 'Lahan has been added successfully.',
      );

      // Clear form fields and patokan list
      namaLahanController.clear();
      jenisLahanNotifier.value = null; // Reset the dropdown
      deskripsiLahanController.clear();
      patokanList.clear();

      //Move to
      Get.to(() => const NavigationMenu());
    } catch (e) {
      //remove loader
      DFullScreenLoader.stopLoading();

      //Show some generic error to the user
      DLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  // Function to fetch lahan details
  Future<void> fetchLahanRecord(String id) async {
    try {
      profileLoading.value = true;
      final lahan = await lahanRepository.fetchLahanDetails(id);
      this.lahan(lahan);
      profileLoading.value = false;
    } catch (e) {
      lahan(LahanModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }
}
