import 'package:dipetakan/data/repositories/authentication/user_repository.dart';
import 'package:dipetakan/features/navigation/controllers/user_controller.dart';
// import 'package:dipetakan/features/navigation/controllers/user_controller_postgres.dart';
import 'package:dipetakan/features/navigation/screens/profilesaya/profilsaya.dart';
import 'package:dipetakan/util/constants/image_strings.dart';
import 'package:dipetakan/util/helpers/network_manager.dart';
import 'package:dipetakan/util/popups/full_screen_loader.dart';
import 'package:dipetakan/util/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

      //remove loader
      DFullScreenLoader.stopLoading();

      //Show success message
      DLoaders.successSnackBar(
          title: 'Congratulations', message: 'Your name has been updated');

      //Move to verify email screen
      Get.off(() => const ProfilSayaScreen());
    } catch (e) {
      DFullScreenLoader.stopLoading();
      DLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
