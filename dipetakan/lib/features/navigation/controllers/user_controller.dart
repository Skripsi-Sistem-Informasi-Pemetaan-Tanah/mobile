import 'package:dipetakan/data/repositories/authentication/authentication_repository.dart';
import 'package:dipetakan/data/repositories/authentication/user_repository.dart';
import 'package:dipetakan/features/authentication/models/user_model.dart';
import 'package:dipetakan/features/authentication/screens/login/login.dart';
import 'package:dipetakan/features/navigation/screens/profilesaya/reauthenticated_user_screen.dart';
import 'package:dipetakan/util/constants/image_strings.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:dipetakan/util/helpers/network_manager.dart';
import 'package:dipetakan/util/popups/full_screen_loader.dart';
import 'package:dipetakan/util/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dipetakan/util/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final hidePassword = true.obs;
  final imageUploading = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
      profileLoading.value = false;
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  Future<void> saveUserRecord(UserCredential? userCredential) async {
    try {
      await fetchUserRecord();
      if (user.value.id.isEmpty) {
        if (userCredential != null) {
          final user = UserModel(
              id: userCredential.user!.uid,
              fullName: userCredential.user!.displayName ?? '',
              username: userCredential.user!.displayName ?? '',
              email: userCredential.user!.email ?? '',
              phoneNo: userCredential.user!.phoneNumber ?? '',
              profilePicture: userCredential.user!.photoURL ?? '');

          //Save user data
          await userRepository.saveUserRecord(user);
        }
      }
    } catch (e) {
      DLoaders.warningSnackBar(
          title: 'Data tidak tersimpan',
          message:
              'Ada kesalahan saat menyimpan informasi Anda. Anda dapat menyimpan ulang kembali profil Anda');
    }
  }

  /// Delete Account Worning
  void deleteAccountWarningPopup(UserModel user) {
    Get.defaultDialog(
      backgroundColor: Colors.white,
      title: 'Hapus Akun',
      middleText:
          "Apakah Anda yakin ingin menghapus akun Anda secara permanen? Tindakan ini tidak dapat dibatalkan dan semua data Anda akan dihapus secara permanen.",
      confirm: ElevatedButton(
        onPressed: () async => deleteUserAccount(user),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            side: const BorderSide(color: Colors.red)),
        child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: DSizes.lg),
            child: Text('Hapus')),
      ),
      cancel: OutlinedButton(
          onPressed: () => Navigator.of(Get.overlayContext!).pop(),
          child: const Text('Batal')),
    );
  }

  void deleteUserAccount(UserModel user) async {
    try {
      // Start loading
      DFullScreenLoader.openLoadingDialog(
          'Sedang memproses', TImages.docerAnimation);

      final auth = AuthenticationRepository.instance;
      final provider =
          auth.authUser?.providerData.map((e) => e.providerId).first ?? '';
      final userId = user.id;
      var url = Uri.parse('$baseUrl/deleteUser/$userId');
      var response = await http.delete(url);

      if (provider.isNotEmpty) {
        // If provider data exists, re-authenticate
        DFullScreenLoader.stopLoading();
        Get.to(() => const ReAuthUserScreen());
      } else {
        if (response.statusCode != 200) {
          DLoaders.errorSnackBar(
              title: 'Oh Tidak!', message: 'Gagal Menghapus');
          DFullScreenLoader.stopLoading();
          return;
        }
        // Directly delete the account if no provider data
        await AuthenticationRepository.instance.deleteAccount(user);
        await AuthenticationRepository.instance.logout();
        DFullScreenLoader.stopLoading();
        Get.offAll(() => const LoginScreen());
      }
    } catch (e) {
      // Remove loader
      DFullScreenLoader.stopLoading();
      // Show some generic error to the user
      DLoaders.errorSnackBar(
          title: 'Oh Tidak!', message: 'Gagal Menghapus : $e');
    }
  }

  Future<void> reAuthenticatedEmailAndPassword(UserModel user) async {
    try {
      //Start loading
      DFullScreenLoader.openLoadingDialog(
          'Processing....', TImages.docerAnimation);

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
      if (!reAuthFormKey.currentState!.validate()) {
        DFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.reAuthenticatedEmailandPassword(
          verifyEmail.text.trim(), verifyPassword.text.trim());

      await AuthenticationRepository.instance.deleteAccount(user);

      //Remove loader
      DFullScreenLoader.stopLoading();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      //remove loader
      DFullScreenLoader.stopLoading();

      //Show some generic error to the user
      DLoaders.errorSnackBar(title: 'Oh Tidak!', message: e.toString());
    }
  }

  uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 70,
          maxHeight: 512,
          maxWidth: 512);
      if (image != null) {
        imageUploading.value = true;
        final imageUrl =
            await userRepository.uploadImage('Users/Images/Profile/', image);

        Map<String, dynamic> json = {'FotoProfil': imageUrl};
        await userRepository.updateSingleField(json);

        user.value.profilePicture = imageUrl;
        user.refresh();

        DLoaders.successSnackBar(
            title: DTexts.selamat, message: DTexts.dataDiubah);
      }
    } catch (e) {
      DLoaders.errorSnackBar(title: DTexts.error, message: DTexts.adaSalah);
    } finally {
      imageUploading.value = false;
    }
  }
}
