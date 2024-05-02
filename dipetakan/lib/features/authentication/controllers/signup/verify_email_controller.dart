import 'dart:async';

import 'package:dipetakan/data/repositories/authentication/authentication_repository.dart';
// import 'package:dipetakan/features/authentication/screens/login/login.dart';
import 'package:dipetakan/features/authentication/screens/signup/account_created.dart';
import 'package:dipetakan/util/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  sendEmailVerification() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      DLoaders.successSnackBar(
          title: 'Email Sent',
          message: 'Please check your email and verify your email');
    } catch (e) {
      DLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  setTimerForAutoRedirect() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Get.off(() => const AccountCreatedScreen());
      }
      // else {
      //   print("No user currently signed in");
      //   Get.off(() => const LoginScreen());
      // }
    });
  }

  checkEmailVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(() => const AccountCreatedScreen());
    }
  }
}
