import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dipetakan/data/repositories/authentication/authentication_repository.dart';
import 'package:dipetakan/data/repositories/tambahlahan/lahan_repository.dart';
import 'package:dipetakan/features/authentication/models/user_model.dart';
import 'package:dipetakan/features/navigation/screens/navigation.dart';
import 'package:dipetakan/features/tambahlahan/models/jenislahanmodel.dart';
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
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

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
  var verifikasiList = <VerifikasiModel>[].obs;
  var strLatLong = 'Belum mendapatkan Lat dan Long'.obs;
  var loading = false.obs;
  var markerbitmap = BitmapDescriptor.defaultMarker.obs;
  var markers = <Marker>{}.obs;
  final shouldReloadMap = false.obs;
  final coordinatesList = <LatLng>[].obs;
  var currentLocation = Rxn<LocationData>();
  final Location location = Location();
  final Completer<GoogleMapController> mapController = Completer();
  final GlobalKey<FormState> tambahLahanFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    try {
      loading.value = true;
      final LocationData locationData = await location.getLocation();
      currentLocation.value = locationData;
      loading.value = false;
    } catch (error) {
      loading.value = false;
      DLoaders.errorSnackBar(
          title: 'Error getting location', message: error.toString());
    }
  }

  LatLng locationDataToLatLng(LocationData locationData) {
    return LatLng(locationData.latitude!, locationData.longitude!);
  }

  Future<void> addPatokan(BuildContext context) async {
    List<LatLng> locations = [];
    StreamSubscription<LocationData>? locationSubscription;
    Timer? timer;

    try {
      bool hasLandmarks = await _showLandmarkDialog(context);
      loading.value = true;
      Get.dialog(
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              title: Text('Mendapatkan Koordinat',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 14,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    locationSubscription?.cancel();
                    loading.value = false;
                    coordinatesList.clear();
                    Get.back();
                  },
                  child: Text(DTexts.cancel,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.red)),
                ),
              ],
            );
          },
        ),
      );

      Location location = Location();

      location.changeSettings(
        accuracy: LocationAccuracy.high,
        interval: 1000,
      );

      locationSubscription = location.onLocationChanged.listen((locationData) {
        LatLng position = locationDataToLatLng(locationData);
        locations.add(position);
        coordinatesList.add(position);
      });

      timer = Timer(const Duration(minutes: 1), () {
        locationSubscription?.cancel();
        loading.value = false;
        Get.back();

        if (locations.isNotEmpty) {
          for (LatLng location in locations) {
            if (kDebugMode) {
              print(
                  'Latitude: ${location.latitude}, Longitude: ${location.longitude}');
            }
          }
          double sumLat =
              locations.fold(0, (double sum, loc) => sum + loc.latitude);
          double sumLong =
              locations.fold(0, (double sum, loc) => sum + loc.longitude);

          double meanLat = sumLat / locations.length;
          double meanLong = sumLong / locations.length;

          strLatLong.value = '$meanLat, $meanLong';

          _addPatokanLogic(context, hasLandmarks, LatLng(meanLat, meanLong));
          coordinatesList.clear();
        } else {
          DLoaders.errorSnackBar(
              title: 'Error', message: 'No location data available.');
        }
      });
    } catch (e) {
      loading.value = false;
      Get.back();
      DLoaders.errorSnackBar(title: 'Oh Tidak!', message: e.toString());
      locationSubscription?.cancel();
      timer?.cancel();
      coordinatesList.clear();
    }
  }

  void _addPatokanLogic(
      BuildContext context, bool hasLandmarks, LatLng position) async {
    if (hasLandmarks) {
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        PatokanModel newPatokan = PatokanModel(
          localPath: pickedFile.path,
          fotoPatokan: '',
          coordinates: strLatLong.value,
          coordVerif: '',
          coordStatus: 0,
          coordPercent: 0,
          coordComment: '',
          coordCommentUser: '',
        );
        patokanList.add(newPatokan);
        addMarker(position, pickedFile.path);
        shouldReloadMap.value = true;
      }
    } else {
      PatokanModel newPatokan = PatokanModel(
        localPath: '',
        fotoPatokan: '',
        coordinates: strLatLong.value,
        coordVerif: '',
        coordStatus: 0,
        coordPercent: 0,
        coordComment: '',
        coordCommentUser: '',
      );
      patokanList.add(newPatokan);
      addMarker(position, '');
      shouldReloadMap.value = true;
    }
  }

  void addMarker(LatLng position, String imagePath) {
    Marker marker = Marker(
      markerId: MarkerId('${position.latitude}, ${position.longitude}'),
      position: position,
      icon: markerbitmap.value,
      onTap: () {
        showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (imagePath.isNotEmpty) Image.file(File(imagePath)),
                  Text('${position.latitude}, ${position.longitude}')
                ],
              ),
            );
          },
        );
      },
    );

    markers.add(marker);
    // return position;
  }

  Future<void> deletePatokan(int index) async {
    try {
      final patokan = patokanList[index];
      final markerId = MarkerId(patokan.coordinates);

      if (patokan.fotoPatokan.isNotEmpty) {
        await lahanRepository.deleteImage(patokan.fotoPatokan);
      }

      patokanList.removeAt(index);
      removeMarker(markerId);
    } catch (e) {
      DLoaders.errorSnackBar(title: 'Error', message: '$e');
    }
  }

  void removeMarker(MarkerId markerId) {
    try {
      markers.removeWhere((marker) => marker.markerId == markerId);
    } catch (e) {
      DLoaders.errorSnackBar(
          title: 'Error', message: 'Error removing marker: $e');
    }
  }

  Future<void> editPatokan(BuildContext context, int index) async {
    try {
      loading.value = true;
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.camera);
      loading.value = false;

      if (pickedFile != null) {
        patokanList[index] = PatokanModel(
          localPath: pickedFile.path,
          fotoPatokan: '',
          coordinates: patokanList[index].coordinates,
          coordVerif: '',
          coordStatus: 0,
          coordPercent: 0,
          coordComment: '',
          coordCommentUser: '',
        );
      }
    } catch (e) {
      loading.value = false;
      DLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  Future<void> replaceFotoPatokan(BuildContext context, int index) async {
    try {
      loading.value = true;
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.camera);
      loading.value = false;

      if (pickedFile != null) {
        var updatedPatokan = PatokanModel(
          coordinates: patokanList[index].coordinates,
          fotoPatokan: patokanList[index].fotoPatokan,
          coordComment: patokanList[index].coordComment,
          coordCommentUser: patokanList[index].coordCommentUser,
          coordVerif: patokanList[index].coordVerif,
          coordStatus: patokanList[index].coordStatus,
          coordPercent: patokanList[index].coordPercent,
          localPath: pickedFile.path,
        );

        patokanList[index] = updatedPatokan;
        patokanList.refresh();
      }
      if (kDebugMode) {
        print(patokanList);
      }
    } catch (e) {
      loading.value = false;
      DLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  Future<bool> _showLandmarkDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text("Apakah terdapat patokan?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Ya",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.green)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Tidak",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.black)),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<XFile?> compressImage(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 85,
    );
    return result != null ? XFile(result.path) : null;
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
          String tempPath = '${tempDir.path}/$lahanId-$i.jpg';
          XFile? compressedImageFile = await compressImage(imageFile, tempPath);

          if (compressedImageFile != null) {
            // Upload the compressed image
            final imageUrl = await lahanRepository.uploadImage(
                'Lahan/Patokan/', compressedImageFile);

            // Update the patokanList with the new image URL
            patokanList[i] = PatokanModel(
              localPath: patokan.localPath,
              fotoPatokan: imageUrl,
              coordinates: patokan.coordinates,
              coordVerif: '',
              coordStatus: 0,
              coordPercent: 0,
              coordComment: '',
              coordCommentUser: '',
            );

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

  void removeMarkerFromPinPoint(int index) async {}

  void saveTambahLahanForm() async {
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

      //Form validation
      if (!tambahLahanFormKey.currentState!.validate()) {
        //remove loader
        DFullScreenLoader.stopLoading();
        return;
      }

      final namaLahan = namaLahanController.text.trim();
      final jenisLahan = jenisLahanNotifier.value?.jenisLahan ?? '';
      final deskripsiLahan = deskripsiLahanController.text.trim();

      //Patokan minimal 3
      if (patokanList.isEmpty || patokanList.length < 3) {
        DLoaders.warningSnackBar(
          title: 'Gagal Menyimpan',
          message: 'Tambahkan minimal 3 patokan',
        );
        DFullScreenLoader.stopLoading();
        return;
      }

      final userId = AuthenticationRepository.instance.authUser?.uid;
      if (userId == null) {
        DLoaders.errorSnackBar(
          title: 'Oh Tidak!',
          message: 'Gagal menyimpan lahan, coba lagi',
        );
        DFullScreenLoader.stopLoading();
        return;
      }

      // Fetch the current user's fullname
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();
      final user = UserModel.fromSnapshot(userDoc);
      final namaPemilik = user.fullName;

      // Generate lahanId using current datetime in YYYYMMDDHHMMSS format
      final lahanId = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
      if (lahanId.isEmpty) {
        DLoaders.errorSnackBar(
          title: 'Oh Tidak!',
          message: 'Gagal menyimpan lahan, coba lagi',
        );
        DFullScreenLoader.stopLoading();
        return;
      }

      // Upload images and update patokan list
      await uploadPatokanImages();

      // Initialize verifikasiList with default values
      verifikasiList.add(
        VerifikasiModel(
          comentar: '',
          statusverifikasi: 0,
          progress: 0,
          verifiedAt: Timestamp.now(),
        ),
      );

      final lahan = LahanModel(
        id: lahanId,
        userId: userId,
        namaPemilik: namaPemilik,
        namaLahan: namaLahan,
        jenisLahan: jenisLahan,
        deskripsiLahan: deskripsiLahan,
        patokan: patokanList,
        verifikasi: verifikasiList,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );

      var url = Uri.parse('$baseUrl/saveLahan');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(lahan.toJsonPostgres()),
      );

      if (response.statusCode != 200) {
        // ignore: avoid_print
        print('Failed to save lahan details: ${response.body}');
        DLoaders.errorSnackBar(
            title: 'Oh Tidak!',
            message: '${response.statusCode} + ${response.body}');
        DFullScreenLoader.stopLoading();
        return;
      }

      // Show success message
      DLoaders.successSnackBar(
        title: 'Berhasil!',
        message: 'Lahan berhasil ditambah.',
      );

      // Clear form fields and patokan list
      namaLahanController.clear();
      jenisLahanNotifier.value = null;
      deskripsiLahanController.clear();
      patokanList.clear();

      //Move to
      Get.offAll(() => const NavigationMenu());
    } catch (e) {
      //remove loader
      DFullScreenLoader.stopLoading();

      //Show some generic error to the user
      DLoaders.errorSnackBar(title: 'Oh Tidak!', message: e.toString());
    }
  }

  void confirmAndSaveTambahLahanForm() {
    Get.defaultDialog(
      title: "Konfirmasi",
      backgroundColor: Colors.white,
      middleText:
          "Apakah Anda yakin ingin menyimpan data lahan ini? Pastikan data lahan yang Anda masukkan benar!",
      textCancel: "Batal",
      textConfirm: "Ya",
      cancel: OutlinedButton(
          onPressed: () => Navigator.of(Get.overlayContext!).pop(),
          child: const Text('Batal')),
      confirm: ElevatedButton(
        onPressed: () {
          Navigator.of(Get.overlayContext!).pop();
          saveTambahLahanForm();
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            side: const BorderSide(color: Colors.green)),
        child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: DSizes.lg),
            child: Text('Benar')),
      ),
    );
  }
}
