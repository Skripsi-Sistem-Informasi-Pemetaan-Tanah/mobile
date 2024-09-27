import 'dart:convert';

import 'package:dipetakan/data/repositories/authentication/authentication_repository.dart';
import 'package:dipetakan/data/repositories/authentication/user_repository.dart';
import 'package:dipetakan/features/navigation/controllers/user_controller.dart';
import 'package:dipetakan/features/navigation/screens/profilesaya/profilsaya.dart';
import 'package:dipetakan/util/constants/image_strings.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:dipetakan/util/helpers/network_manager.dart';
import 'package:dipetakan/util/popups/full_screen_loader.dart';
import 'package:dipetakan/util/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dipetakan/util/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class UpdateNameController extends GetxController {
  static UpdateNameController get instance => Get.find();

  final fullName = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateUserFullnameFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializeNames();
    super.onInit();
  }

  Future<void> initializeNames() async {
    fullName.text = userController.user.value.fullName;
  }

  Future<void> updateUserFullname() async {
    try {
      //Start loading
      DFullScreenLoader.openLoadingDialog(
          'We are updating your information', TImages.docerAnimation);

      //Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        //remove loader
        DFullScreenLoader.stopLoading();
        return;
      }

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
      if (!updateUserFullnameFormKey.currentState!.validate()) {
        //remove loader
        DFullScreenLoader.stopLoading();
        return;
      }

      ///Update user's fullname in the Firebase Firestore
      Map<String, dynamic> name = {'nama_lengkap': fullName.text.trim()};
      await userRepository.updateSingleField(name);

      userController.user.value.fullName = fullName.text.trim();

      var url = Uri.parse('$baseUrl/saveUser');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': AuthenticationRepository.instance.authUser?.uid,
          'nama_lengkap': fullName.text.trim(),
        }),
      );

      if (response.statusCode != 200) {
        DLoaders.errorSnackBar(title: 'Oh Tidak!', message: 'Gagal Menyimpan');
        DFullScreenLoader.stopLoading();
        return;
      }

      //remove loader
      DFullScreenLoader.stopLoading();

      //Show success message
      DLoaders.successSnackBar(
          title: DTexts.selamat, message: DTexts.dataDiubah);

      //Move to verify email screen
      Get.off(() => const ProfilSayaScreen());
    } catch (e) {
      DFullScreenLoader.stopLoading();
      DLoaders.errorSnackBar(title: 'Oh Tidak!', message: e.toString());
    }
  }
}
