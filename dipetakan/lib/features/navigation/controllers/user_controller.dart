import 'package:dipetakan/data/repositories/authentication/authentication_repository.dart';
import 'package:dipetakan/data/repositories/authentication/user_repository.dart';
import 'package:dipetakan/features/authentication/models/user_model.dart';
import 'package:dipetakan/features/authentication/screens/login/login.dart';
import 'package:dipetakan/features/navigation/screens/profilesaya/reauthenticated_user_screen.dart';
import 'package:dipetakan/util/constants/image_strings.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/helpers/network_manager.dart';
import 'package:dipetakan/util/popups/full_screen_loader.dart';
import 'package:dipetakan/util/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final hidePassword = false.obs;
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
  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(DSizes.md),
      title: 'Delete Account',
      middleText:
          "Are you sure you want to delete your account permanently? This action is not reversible and all of your data will be removed permanently",
      confirm: ElevatedButton(
        onPressed: () async => deleteUserAccount(),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            side: const BorderSide(color: Colors.red)),
        child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: DSizes.lg),
            child: Text('Delete')),
      ),
      cancel: OutlinedButton(
          onPressed: () => Navigator.of(Get.overlayContext!).pop(),
          child: const Text('Cancel')),
    );
  }

  void deleteUserAccount() async {
    DFullScreenLoader.openLoadingDialog('Processing', TImages.docerAnimation);

    final auth = AuthenticationRepository.instance;
    final provider = auth.authUser!.providerData.map((e) => e.providerId).first;
    if (provider.isNotEmpty) {
      DFullScreenLoader.stopLoading();
      Get.to(() => const ReAuthUserScreen());
    }
  }

  Future<void> reAuthenticatedEmailAndPassword() async {
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

      //Form validation
      if (!reAuthFormKey.currentState!.validate()) {
        DFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.reAuthenticatedEmailandPassword(
          verifyEmail.text.trim(), verifyPassword.text.trim());

      await AuthenticationRepository.instance.deleteAccount();

      //Remove loader
      DFullScreenLoader.stopLoading();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      //remove loader
      DFullScreenLoader.stopLoading();

      //Show some generic error to the user
      DLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
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
            title: 'Congratulations',
            message: 'Your Profile Image has been updated');
      }
    } catch (e) {
      DLoaders.errorSnackBar(
          title: 'OhSnap', message: 'Something went wrong: $e');
    } finally {
      imageUploading.value = false;
    }
  }
}
