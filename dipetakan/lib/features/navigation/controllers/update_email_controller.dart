import 'package:dipetakan/data/repositories/authentication/authentication_repository.dart';
import 'package:dipetakan/data/repositories/authentication/user_repository.dart';
import 'package:dipetakan/features/authentication/screens/login/login.dart';
import 'package:dipetakan/features/navigation/controllers/user_controller.dart';
import 'package:dipetakan/features/navigation/screens/profilesaya/editprofil/email_updated.dart';
import 'package:dipetakan/features/navigation/screens/profilesaya/editprofil/update_email_verification.dart';
// import 'package:dipetakan/features/navigation/screens/profilesaya/profilsaya.dart';
import 'package:dipetakan/util/constants/image_strings.dart';
import 'package:dipetakan/util/helpers/network_manager.dart';
import 'package:dipetakan/util/popups/full_screen_loader.dart';
import 'package:dipetakan/util/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateEmailController extends GetxController {
  static UpdateEmailController get instance => Get.find();

  final newEmail = TextEditingController();
  final oldEmail = TextEditingController();
  final hidePassword = true.obs;
  final oldPassword = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateEmailFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializeEmail();
    super.onInit();
  }

  Future<void> initializeEmail() async {
    oldEmail.text = userController.user.value.email;
  }

  Future<void> updateEmail() async {
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
      if (!updateEmailFormKey.currentState!.validate()) {
        //remove loader
        DFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.reAuthenticatedEmailandPassword(
          oldEmail.text.trim(), oldPassword.text.trim());

      await AuthenticationRepository.instance
          .verifyBeforeUpdateEmail(newEmail.text.trim());

      // /Update user's email in the Firebase Firestore
      Map<String, dynamic> userEmail = {'Email': newEmail.text.trim()};
      await userRepository.updateSingleField(userEmail);

      userController.user.value.email = newEmail.text.trim();

      // await AuthenticationRepository.instance.userUpdated();

      //remove loader
      DFullScreenLoader.stopLoading();

      //Show success message
      DLoaders.successSnackBar(
          title: 'Congratulations',
          message: 'Your email has been updated! Verify email to continue');

      //Move to verify email screen
      Get.to(() => VerifyUpdateEmailScreen(email: newEmail.text.trim()));
    } catch (e) {
      DFullScreenLoader.stopLoading();
      DLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  checkEmailVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    try {
      await currentUser?.reload(); // Refresh the user data
      // ignore: unrelated_type_equality_checks
      if (currentUser?.email == newEmail) {
        // Check if the email has been changed to newEmail
        if (currentUser!.emailVerified) {
          Get.off(() => const EmailUpdatedScreen());
        } else {
          DLoaders.warningSnackBar(
            title: 'Email not updated',
            message:
                'Your email has already been verified but not updated to the new email address.',
          );
        }
      } else {
        DLoaders.warningSnackBar(
          title: 'Email not verified',
          message: 'Please verify your email first',
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-token-expired') {
        Get.off(() => const EmailUpdatedScreen());
      } else {
        DLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      }
    } catch (e) {
      DLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  sendEmailVerification() async {
    try {
      await AuthenticationRepository.instance
          .verifyBeforeUpdateEmail(newEmail.text.trim());
      DLoaders.successSnackBar(
          title: 'Email Sent',
          message: 'Please check your email and verify your email');
    } catch (e) {
      DLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  Future<void> updateEmailFirestore() async {
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
      if (!updateEmailFormKey.currentState!.validate()) {
        //remove loader
        DFullScreenLoader.stopLoading();
        return;
      }

      ///Update user's email in the Firebase Firestore
      Map<String, dynamic> userEmail = {'Email': newEmail.text.trim()};
      await userRepository.updateSingleField(userEmail);

      userController.user.value.email = newEmail.text.trim();

      await AuthenticationRepository.instance.userUpdated();

      //remove loader
      DFullScreenLoader.stopLoading();

      //Show success message
      DLoaders.successSnackBar(
          title: 'Congratulations', message: 'Your name has been updated');

      //Move to verify email screen
      Get.off(() => const LoginScreen());
    } catch (e) {
      DFullScreenLoader.stopLoading();
      DLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
