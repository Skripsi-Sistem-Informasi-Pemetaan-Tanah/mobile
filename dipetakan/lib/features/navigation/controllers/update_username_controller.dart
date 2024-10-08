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

class UpdateUsernameController extends GetxController {
  static UpdateUsernameController get instance => Get.find();

  final username = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateUsernameFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializeNames();
    super.onInit();
  }

  Future<void> initializeNames() async {
    username.text = userController.user.value.username;
  }

  Future<void> updateUsername() async {
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
      if (!updateUsernameFormKey.currentState!.validate()) {
        //remove loader
        DFullScreenLoader.stopLoading();
        return;
      }

      ///Update user's username in the Firebase Firestore
      Map<String, dynamic> userName = {'username': username.text.trim()};
      await userRepository.updateSingleField(userName);

      userController.user.value.username = username.text.trim();

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
