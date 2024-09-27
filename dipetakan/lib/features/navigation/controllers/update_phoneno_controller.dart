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

class UpdatePhoneNoController extends GetxController {
  static UpdatePhoneNoController get instance => Get.find();

  final phoneNo = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updatephoneNoFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializeNames();
    super.onInit();
  }

  Future<void> initializeNames() async {
    phoneNo.text = userController.user.value.phoneNo;
  }

  Future<void> updatephoneNo() async {
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

      //Form validation
      if (!updatephoneNoFormKey.currentState!.validate()) {
        //remove loader
        DFullScreenLoader.stopLoading();
        return;
      }

      ///Update user's phoneNo in the Firebase Firestore
      Map<String, dynamic> phoneNumber = {'NoTelepon': phoneNo.text.trim()};
      await userRepository.updateSingleField(phoneNumber);

      userController.user.value.phoneNo = phoneNo.text.trim();

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
