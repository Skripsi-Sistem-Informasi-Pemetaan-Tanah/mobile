import 'package:dipetakan/data/repositories/authentication/authentication_repository.dart';
import 'package:dipetakan/features/authentication/screens/forgetpassword/email_sent.dart';
import 'package:dipetakan/util/constants/image_strings.dart';
import 'package:dipetakan/util/helpers/network_manager.dart';
import 'package:dipetakan/util/popups/full_screen_loader.dart';
import 'package:dipetakan/util/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  ///Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  //Send Reset Password Email
  sendPasswordResetEmail() async {
    try {
      //Start Loading
      DFullScreenLoader.openLoadingDialog(
          'Processing your request', TImages.docerAnimation);

      //Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        //remove loader
        DFullScreenLoader.stopLoading();
        return;
      }

      //Form validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        DFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance
          .sendPasswordResetEmail(email.text.trim());

      //Remove loader
      DFullScreenLoader.stopLoading();

      //Show success message
      DLoaders.successSnackBar(
          title: 'Email Sent',
          message: 'Email link sent to Reset your Password');

      //Redirect
      Get.to(() => EmailSentScreen(email: email.text.trim()));
    } catch (e) {
      //remove loader
      DFullScreenLoader.stopLoading();

      //Show some generic error to the user
      DLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      //Start Loading
      DFullScreenLoader.openLoadingDialog(
          'Processing your request', TImages.docerAnimation);

      //Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        //remove loader
        DFullScreenLoader.stopLoading();
        return;
      }

      //Form validation
      if (!forgetPasswordFormKey.currentState!.validate()) {
        DFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      //Remove loader
      DFullScreenLoader.stopLoading();

      //Show success message
      DLoaders.successSnackBar(
          title: 'Email Sent',
          message: 'Email link sent to Reset your Password');
    } catch (e) {
      //remove loader
      DFullScreenLoader.stopLoading();

      //Show some generic error to the user
      DLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
