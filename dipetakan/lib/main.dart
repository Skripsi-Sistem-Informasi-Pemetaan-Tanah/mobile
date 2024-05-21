import 'package:dipetakan/app.dart';
import 'package:dipetakan/data/repositories/authentication/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';
import 'package:geolocator/geolocator.dart';

Future<void> main() async {
  // Todo: Add Widgets Binding
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  // Todo: Init Local Storage
  await GetStorage.init();
  // Todo: Awoit Native Splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Todo: Initialize Firebase & Authentication Repository
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((FirebaseApp value) => Get.put(AuthenticationRepository()));

  await _getGeoLocationPosition();

  runApp(const App());
}

Future<Position> _getGeoLocationPosition() async {
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
    return Future.error('Location permission denied forever, we cannot access');
  }

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}
