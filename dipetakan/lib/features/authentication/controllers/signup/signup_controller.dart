// import 'dart:convert';

import 'package:dipetakan/data/repositories/authentication/authentication_repository.dart';
import 'package:dipetakan/data/repositories/authentication/user_repository.dart';
import 'package:dipetakan/features/authentication/models/user_model.dart';
import 'package:dipetakan/features/authentication/screens/signup/email_verification.dart';
// import 'package:dipetakan/util/constants/api_constants.dart';
import 'package:dipetakan/util/constants/image_strings.dart';
import 'package:dipetakan/util/popups/full_screen_loader.dart';
import 'package:dipetakan/util/popups/loaders.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dipetakan/util/helpers/network_manager.dart';
// import 'package:http/http.dart' as http;

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  ///Variables
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final namaLengkap = TextEditingController();
  final email = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final phoneNo = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  Rx<UserModel> user = UserModel.empty().obs;

  /// SIGNUP
  void signup() async {
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
      // final serverurl = Uri.parse('$baseUrl/checkConnectionDatabase');
      // final http.Response serverresponse = await http.get(serverurl);

      // if (serverresponse.statusCode != 200) {
      //   DLoaders.errorSnackBar(
      //     title: 'Oh Snap!',
      //     message: 'Server or Database is not connected',
      //   );
      //   DFullScreenLoader.stopLoading();
      //   return;
      // }

      //Form validation
      if (!signupFormKey.currentState!.validate()) {
        //remove loader
        DFullScreenLoader.stopLoading();
        return;
      }
      //Privacy policy checks
      if (!privacyPolicy.value) {
        DLoaders.warningSnackBar(
            title: 'Accept Privacy Policy',
            message:
                'In order to create account, you must have to read and accept the Privacy Policy & Terms of Use');
        return;
      }

      //Register user in Firebase Auth & save user
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());

      //Save authenticated user data in firestore
      final newUser = UserModel(
          id: userCredential.user!.uid,
          fullName: namaLengkap.text.trim(),
          username: username.text.trim(),
          email: email.text.trim(),
          phoneNo: phoneNo.text.trim(),
          profilePicture: '');

      // var url = Uri.parse('$baseUrl/saveUser');
      // var response = await http.post(
      //   url,
      //   headers: {
      //     'Content-Type': 'application/json',
      //   },
      //   body: jsonEncode(newUser.toJson()),
      // );

      // if (response.statusCode != 200) {
      //   DLoaders.errorSnackBar(title: 'Oh Snap!', message: 'Gagal Menyimpan');
      //   DFullScreenLoader.stopLoading();
      //   return;
      // }

      final userRepository = Get.put(UserRepository());
      userRepository.saveUserRecord(newUser);

      //Show success message
      DLoaders.successSnackBar(
          title: 'Congratulations',
          message: 'Your account has been created! Verify email to continue');

      //Move to verify email screen
      Get.to(() => VerifyEmailScreen(email: email.text.trim()));
    } catch (e) {
      //remove loader
      DFullScreenLoader.stopLoading();

      //Show some generic error to the user
      DLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
