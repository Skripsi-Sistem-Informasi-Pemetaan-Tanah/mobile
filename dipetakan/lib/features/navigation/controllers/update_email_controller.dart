import 'package:dipetakan/data/repositories/authentication/authentication_repository.dart';
import 'package:dipetakan/data/repositories/authentication/user_repository.dart';
import 'package:dipetakan/features/authentication/screens/login/login.dart';
import 'package:dipetakan/features/navigation/controllers/user_controller.dart';
// import 'package:dipetakan/features/navigation/controllers/user_controller_postgres.dart';
import 'package:dipetakan/features/navigation/screens/profilesaya/editprofil/email_updated.dart';
import 'package:dipetakan/features/navigation/screens/profilesaya/editprofil/update_email_verification.dart';
// import 'package:dipetakan/features/navigation/screens/profilesaya/profilsaya.dart';
import 'package:dipetakan/util/constants/image_strings.dart';
import 'package:dipetakan/util/exceptions/firebase_auth_exceptions.dart';
import 'package:dipetakan/util/exceptions/firebase_exceptions.dart';
import 'package:dipetakan/util/exceptions/format_exceptions.dart';
import 'package:dipetakan/util/exceptions/platform_exceptions.dart';
import 'package:dipetakan/util/helpers/network_manager.dart';
import 'package:dipetakan/util/popups/full_screen_loader.dart';
import 'package:dipetakan/util/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dipetakan/util/constants/api_constants.dart';
import 'package:http/http.dart' as http;

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

      // Check server and database connection
      final serverurl = Uri.parse('$baseUrl/checkConnectionDatabase');
      final http.Response serverresponse = await http.get(serverurl);

      if (serverresponse.statusCode != 200) {
        DLoaders.errorSnackBar(
          title: 'Oh Snap!',
          message: 'Server or Database is not connected',
        );
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
      Map<String, dynamic> userEmail = {'email': newEmail.text.trim()};
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
      if (currentUser?.email == newEmail.text.trim()) {
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
        await AuthenticationRepository.instance.logout();
        Get.off(() => const LoginScreen());
      } else {
        throw TFirebaseAuthException(e.code).message;
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      if (e.code == 'user-token-expired') {
        await AuthenticationRepository.instance.logout();
        Get.off(() => const LoginScreen());
      } else {
        throw TPlatformException(e.code).message;
      }
    } catch (e) {
      throw 'Something went wrong, try again: $e';
      // DLoaders.errorSnackBar(
      //     title: 'Error', message: 'Something went wrong try again : $e');
    }
    return null;
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
