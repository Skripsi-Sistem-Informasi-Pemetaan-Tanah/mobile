import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dipetakan/data/repositories/authentication/authentication_repository.dart';
import 'package:dipetakan/data/repositories/tambahlahan/lahan_repository.dart';
import 'package:dipetakan/features/authentication/models/user_model.dart';
import 'package:dipetakan/features/navigation/screens/navigation.dart';
// import 'package:dipetakan/features/tambahlahan/controllers/pinpoint_controller.dart';
import 'package:dipetakan/features/tambahlahan/models/jenislahanmodel.dart';
import 'package:dipetakan/features/tambahlahan/models/lahan_model.dart';
import 'package:dipetakan/util/constants/api_constants.dart';
import 'package:dipetakan/util/constants/image_strings.dart';
import 'package:dipetakan/util/helpers/network_manager.dart';
import 'package:dipetakan/util/popups/full_screen_loader.dart';
import 'package:dipetakan/util/popups/loaders.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
// import 'package:geolocator/geolocator.dart' as geolocator;
// import 'package:location/location.dart' as location;

class TambahLahanControllerOld extends GetxController {
  static TambahLahanControllerOld get instance => Get.find();

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
  // final Rx<Position?> currentLocation = Rx<Position?>(null);
  var currentLocation = Rxn<LocationData>();
  // var currentLocation = Rxn<Position>();
  final Location location = Location();
  final Completer<GoogleMapController> mapController = Completer();
  final GlobalKey<FormState> tambahLahanFormKey = GlobalKey<FormState>();
  // Add a reference to the PinPointController
  // final PinPointController pinPointController = Get.put(PinPointController());

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    // getGeoLocationPosition();
  }

  // void getCurrentLocation() async {
  //   try {
  //     final LocationData locationData = await location.getLocation();
  //     currentLocation.value = locationData;
  //   } catch (error) {
  //     DLoaders.errorSnackBar(
  //         title: 'Error getting location', message: error.toString());
  //   }
  // }

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

  // Future<Position> getGeoLocationPosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     await Geolocator.openLocationSettings();
  //     return Future.error('Location service Not Enabled');
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permission denied');
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permission denied forever, we cannot access');
  //   }
  //   return await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );
  // }
  LatLng locationDataToLatLng(LocationData locationData) {
    return LatLng(locationData.latitude!, locationData.longitude!);
  }

  // Future<void> addPatokan(BuildContext context) async {
  //   try {
  //     bool hasLandmarks = await _showLandmarkDialog(context);
  //     loading.value = true;
  //     LocationData? locationData = currentLocation.value;
  //     LatLng position = locationDataToLatLng(locationData!);
  //     location.changeSettings(
  //       accuracy: LocationAccuracy.high,
  //       interval: 1000,
  //     );
  //     loading.value = false;
  //     strLatLong.value = '${position.latitude}, ${position.longitude}';

  //     // if (hasLandmarks) {
  //     //   final pickedFile =
  //     //       await imagePicker.pickImage(source: ImageSource.camera);
  //     //   if (pickedFile != null) {
  //     //     // Upload the image to Firebase Storage and get the URL
  //     //     // final imageUrl =
  //     //     //     await lahanRepository.uploadImage('Patokan/Images/', pickedFile);
  //     //     patokanList.add(
  //     //       PatokanModel(
  //     //           localPath: pickedFile.path,
  //     //           fotoPatokan: '',
  //     //           coordinates: strLatLong.value),
  //     //     );
  //     //   }
  //     // } else {
  //     //   patokanList.add(
  //     //     PatokanModel(
  //     //         localPath: '', fotoPatokan: '', coordinates: strLatLong.value),
  //     //   );
  //     // }

  //     if (hasLandmarks) {
  //       final pickedFile =
  //           await imagePicker.pickImage(source: ImageSource.camera);
  //       if (pickedFile != null) {
  //         PatokanModel newPatokan = PatokanModel(
  //           localPath: pickedFile.path,
  //           fotoPatokan: '',
  //           coordinates: strLatLong.value,
  //         );
  //         patokanList.add(newPatokan);
  //         addMarker(position, pickedFile.path);
  //         shouldReloadMap.value = true;
  //         //   final markerLatLng = addMarker(LatLng(position!.latitude, position!.longitude), pickedFile.path);
  //         // return markerLatLng;
  //       }
  //     } else {
  //       PatokanModel newPatokan = PatokanModel(
  //         localPath: '',
  //         fotoPatokan: '',
  //         coordinates: strLatLong.value,
  //       );
  //       patokanList.add(newPatokan);
  //       addMarker(position, '');
  //       shouldReloadMap.value = true;
  //       // final markerLatLng = addMarker(LatLng(position!.latitude, position!.longitude), '');
  //       // return markerLatLng;
  //     }

  //     // pinPointController.addMarker(
  //     //   latitude: position.latitude,
  //     //   longitude: position.longitude,
  //     // )
  //   } catch (e) {
  //     loading.value = false;
  //     Get.snackbar('Oh Snap!', e.toString(),
  //         snackPosition: SnackPosition.BOTTOM);
  //   }
  // }

  Future<void> addPatokan(BuildContext context) async {
    List<LatLng> locations = [];
    StreamSubscription<LocationData>? locationSubscription;
    Timer? timer;

    try {
      bool hasLandmarks = await _showLandmarkDialog(context);
      loading.value = true;

      // Show loading dialog with real-time coordinates list
      Get.dialog(
        Obx(() => AlertDialog(
              title: const Text('Collecting Coordinates...'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: coordinatesList.length,
                  itemBuilder: (context, index) {
                    LatLng coordinate = coordinatesList[index];
                    return ListTile(
                      title: Text(
                          '${coordinate.latitude}, ${coordinate.longitude}'),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    locationSubscription?.cancel();
                    loading.value = false;
                    Get.back();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            )),
        barrierDismissible: false,
      );

      Location location = Location();

      // bool serviceEnabled = await location.serviceEnabled();
      // if (!serviceEnabled) {
      //   serviceEnabled = await location.requestService();
      //   if (!serviceEnabled) {
      //     loading.value = false;
      //     Get.snackbar('Error', 'Location services are disabled.',
      //         snackPosition: SnackPosition.BOTTOM);
      //     return;
      //   }
      // }

      // PermissionStatus permissionGranted = await location.hasPermission();
      // if (permissionGranted == PermissionStatus.denied) {
      //   permissionGranted = await location.requestPermission();
      //   if (permissionGranted != PermissionStatus.granted) {
      //     loading.value = false;
      //     Get.snackbar('Error', 'Location permissions are denied.',
      //         snackPosition: SnackPosition.BOTTOM);
      //     return;
      //   }
      // }

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
          // locations.sort((a, b) => a.latitude.compareTo(b.latitude));
          // double medianLat = locations[locations.length ~/ 2].latitude;

          // locations.sort((a, b) => a.longitude.compareTo(b.longitude));
          // double medianLong = locations[locations.length ~/ 2].longitude;

          // strLatLong.value = '$medianLat, $medianLong';
          double sumLat =
              locations.fold(0, (double sum, loc) => sum + loc.latitude);
          double sumLong =
              locations.fold(0, (double sum, loc) => sum + loc.longitude);

          double meanLat = sumLat / locations.length;
          double meanLong = sumLong / locations.length;

          strLatLong.value = '$meanLat, $meanLong';

          // _addPatokanLogic(
          //     context, hasLandmarks, LatLng(medianLat, medianLong));

          _addPatokanLogic(context, hasLandmarks, LatLng(meanLat, meanLong));
        } else {
          DLoaders.errorSnackBar(
              title: 'Error', message: 'No location data available.');
        }
      });
    } catch (e) {
      loading.value = false;
      Get.back();
      DLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      locationSubscription?.cancel();
      timer?.cancel();
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
      final markerId = MarkerId(patokan.coordinates); // Capture the marker ID

      if (patokan.fotoPatokan.isNotEmpty) {
        await lahanRepository.deleteImage(patokan.fotoPatokan);
      }

      patokanList.removeAt(index);
      removeMarker(markerId); // Pass the marker ID to removeMarker
    } catch (e) {
      DLoaders.errorSnackBar(title: 'Error', message: '$e');
    }
  }

  void removeMarker(MarkerId markerId) {
    try {
      markers.removeWhere((marker) => marker.markerId == markerId);
    } catch (e) {
      // Handle potential errors during marker removal, e.g., logging or displaying an error message
      DLoaders.errorSnackBar(
          title: 'Error', message: 'Error removing marker: $e');
    }
  }

  Future<void> replacePatokan(BuildContext context, int index) async {
    try {
      bool hasLandmarks = await _showLandmarkDialog(context);
      loading.value = true;
      // Position position = await getGeoLocationPosition();
      LocationData? position = currentLocation.value;
      loading.value = false;
      strLatLong.value = '${position?.latitude}, ${position?.longitude}';

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
      DLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
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
            coordinates: patokanList[index].coordinates);
      }
    } catch (e) {
      loading.value = false;
      DLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

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

  // Future<void> deletePatokan(int index) async {
  //   try {
  //     final patokan = patokanList[index];
  //     if (patokan.fotoPatokan.isNotEmpty) {
  //       await lahanRepository.deleteImage(patokan.fotoPatokan);
  //     }
  //     patokanList.removeAt(index);
  //   } catch (e) {
  //     Get.snackbar('Oh Snap!', e.toString(),
  //         snackPosition: SnackPosition.BOTTOM);
  //   }
  // }

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
          DLoaders.errorSnackBar(
              title: 'Oh Snap!', message: 'Failed to upload image: $e');
        }
      }
    }
  }

  void removeMarkerFromPinPoint(int index) async {}

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

      // Check server and database connection
      final serverurl = Uri.parse('$baseUrl/checkConnectionDatabase');
      final http.Response serverresponse = await http.get(serverurl);

      if (serverresponse.statusCode != 200) {
        DLoaders.errorSnackBar(
          title: 'Oh Snap!',
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

//minimal 3
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

      // Generate a unique ID for the new document
      // final newDocRef = FirebaseFirestore.instance.collection('Lahan').doc();
      // final lahanId = newDocRef.id;

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

      // Save the document using the generated ID
      // await newDocRef.set(lahan.toJson());

      // Prepare the data to be sent to the server
      // Map<String, dynamic> dataToSend = {
      //   'user_id': userId,
      //   ...lahan
      //       .toJsonPostgres(), // Use the toJsonPostgres method to format the data
      // };

      // Send data to Node.js server to save to PostgreSQL
      // const String baseUrl = 'http://192.168.1.18:3000';
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
            title: 'Oh Snap!',
            message: '${response.statusCode} + ${response.body}');
        // throw Exception('Failed to fetch user details');
        // throw 'Failed to save lahan record to PostgreSQL';
        DFullScreenLoader.stopLoading();
        return;
      }

      // lahanRepository.saveLahanRecord(lahan);

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
      Get.offAll(() => const NavigationMenu());
    } catch (e) {
      //remove loader
      DFullScreenLoader.stopLoading();

      //Show some generic error to the user
      DLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  // Function to update only the Foto Patokan
  void updateFotoPatokan(LahanModel existingLahan) async {
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

      // Check server and database connection
      final serverurl = Uri.parse('$baseUrl/checkConnectionDatabase');
      final http.Response serverresponse = await http.get(serverurl);

      if (serverresponse.statusCode != 200) {
        DLoaders.errorSnackBar(
          title: 'Oh Snap!',
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
            title: 'Oh Snap!',
            message: '${response.statusCode} + ${response.body}');
        DFullScreenLoader.stopLoading();
        return;
      }

      // Update the patokan in Firestore
      await FirebaseFirestore.instance
          .collection('Lahan')
          .doc(existingLahan.id)
          .update({
        'koordinat': patokanList.map((patokan) => patokan.toJson()).toList(),
        'updated_at': Timestamp.now(),
      });

      // Show success message
      DLoaders.successSnackBar(
        title: 'Success',
        message: 'Foto patokan has been updated successfully.',
      );

      // Clear patokan list
      patokanList.clear();

      // Navigate back
      Get.offAll(() => const NavigationMenu());
    } catch (e) {
      DFullScreenLoader.stopLoading();
      DLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  // // Function to fetch lahan details
  // Future<void> fetchLahanRecord(String id) async {
  //   try {
  //     profileLoading.value = true;
  //     final lahan = await lahanRepository.fetchLahanDetails(id);
  //     this.lahan(lahan);
  //     profileLoading.value = false;
  //   } catch (e) {
  //     lahan(LahanModel.empty());
  //   } finally {
  //     profileLoading.value = false;
  //   }
  // }
}
