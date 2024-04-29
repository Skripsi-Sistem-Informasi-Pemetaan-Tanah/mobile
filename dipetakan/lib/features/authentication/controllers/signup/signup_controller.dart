import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  ///Variables
  final namaLengkap = TextEditingController();
  final email = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final phoneNo = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  /// SIGNUP
  Future<void> signup() async {
    try {
      //Start loading

      //Check Internet Connectivity

      //Form validation

      //Privacy policy checks

      //Register user in Firebase Auth & save user

      //Save authenticated user data in firestore

      //Show success message

      //Move to verify email screen
    } catch (e) {
      //Show some generic error to the user
    } finally {
      //remove loader
    }
  }
}
