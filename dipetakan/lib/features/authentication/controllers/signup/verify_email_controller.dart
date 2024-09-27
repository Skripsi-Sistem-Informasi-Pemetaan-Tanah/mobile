import 'dart:async';
import 'package:dipetakan/data/repositories/authentication/authentication_repository.dart';
import 'package:dipetakan/features/authentication/screens/login/login.dart';
import 'package:dipetakan/features/authentication/screens/signup/account_created.dart';
import 'package:dipetakan/util/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();
  Timer? _timer;

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
          title: 'Email Terkirim',
          message: 'Harap periksa dan verifikasi email Anda');
    } catch (e) {
      DLoaders.errorSnackBar(title: 'Oh Tidak!', message: e.toString());
    }
  }

  checkEmailVerificationStatus() async {
    bool isVerified = await _checkEmailVerifiedWithRetries();
    if (isVerified) {
      Get.off(() => const AccountCreatedScreen());
    } else {
      DLoaders.warningSnackBar(
          title: 'Email not verified',
          message: 'Please verify your email first');
    }
  }

  Future<bool> _checkEmailVerifiedWithRetries(
      {int retries = 3, int delaySeconds = 2}) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    for (int i = 0; i < retries; i++) {
      await currentUser?.reload();
      if (currentUser != null && currentUser.emailVerified) {
        return true;
      }
      await Future.delayed(Duration(seconds: delaySeconds));
    }
    return false;
  }

  setTimerForAutoRedirect({int timeoutSeconds = 120}) {
    int elapsedSeconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Get.off(() => const AccountCreatedScreen());
      } else {
        elapsedSeconds++;
        if (elapsedSeconds >= timeoutSeconds) {
          timer.cancel();
          Get.offAll(() => const LoginScreen());
        }
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
