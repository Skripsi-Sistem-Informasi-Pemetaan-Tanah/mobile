// // import 'package:dipetakan/features/authentication/models/user_model.dart';
// import 'package:dipetakan/features/authentication/models/user_model_postgres.dart';
// import 'package:dipetakan/features/authentication/screens/signup/account_created.dart';
// // import 'package:dipetakan/features/authentication/screens/signup/email_verification.dart';
// // import 'package:dipetakan/features/navigation/screens/navigation.dart';
// import 'package:dipetakan/util/constants/image_strings.dart';
// import 'package:dipetakan/util/popups/full_screen_loader.dart';
// import 'package:dipetakan/util/popups/loaders.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:dipetakan/util/helpers/network_manager.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class SignupController extends GetxController {
//   static SignupController get instance => Get.find();

//   ///Variables
//   final hidePassword = true.obs;
//   final privacyPolicy = true.obs;
//   final namaLengkap = TextEditingController();
//   final email = TextEditingController();
//   final username = TextEditingController();
//   final password = TextEditingController();
//   final phoneNo = TextEditingController();
//   GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

//   /// SIGNUP
//   void signup() async {
//     try {
//       // Start loading
//       DFullScreenLoader.openLoadingDialog(
//           'We are processing your information', TImages.docerAnimation);

//       // Check Internet Connectivity
//       final isConnected = await NetworkManager.instance.isConnected();
//       if (!isConnected) {
//         // remove loader
//         DFullScreenLoader.stopLoading();
//         return;
//       }

//       // Form validation
//       if (!signupFormKey.currentState!.validate()) {
//         // remove loader
//         DFullScreenLoader.stopLoading();
//         return;
//       }

//       // Privacy policy checks
//       if (!privacyPolicy.value) {
//         DLoaders.warningSnackBar(
//             title: 'Accept Privacy Policy',
//             message:
//                 'In order to create account, you must have to read and accept the Privacy Policy & Terms of Use');
//         return;
//       }

//       // Register user using Node.js backend
//       final response = await http.post(
//         Uri.parse(
//             'http://192.168.1.18:3000/register'), // Change this to your backend URL
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'email': email.text.trim(),
//           'password': password.text.trim(),
//           'fullName': namaLengkap.text.trim(),
//           'username': username.text.trim(),
//           'phoneNo': phoneNo.text.trim(),
//         }),
//       );

//       if (response.statusCode == 201) {
//         // Parse the response body
//         final responseData = json.decode(response.body);

//         // Create new user model
//         // ignore: unused_local_variable
//         final newUser = UserModel(
//           id: responseData['id'],
//           fullName: namaLengkap.text.trim(),
//           username: username.text.trim(),
//           email: email.text.trim(),
//           phoneNo: phoneNo.text.trim(),
//           profilePicture: '',
//         );

//         // Show success message
//         DLoaders.successSnackBar(
//             title: 'Congratulations',
//             message: 'Your account has been created! Verify email to continue');

//         // Move to verify email screen
//         Get.to(() => const AccountCreatedScreen());
//       } else {
//         // Handle error response
//         final responseData = json.decode(response.body);
//         final errorMessage = responseData['error'] ?? 'Registration failed';
//         DLoaders.errorSnackBar(title: 'Oh Snap!', message: errorMessage);
//       }
//     } catch (e) {
//       // Remove loader
//       DFullScreenLoader.stopLoading();

//       // Show some generic error to the user
//       DLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
//     }
//   }

//   void logout() async {
//     try {
//       final response = await http.post(
//         Uri.parse(
//             'http://192.168.1.18:3000/logout'), // Replace with your backend URL
//         // Add any necessary headers or data here
//       );

//       if (response.statusCode == 204) {
//         // Successful logout
//         // Navigate to login screen or perform any other action
//       } else {
//         // Handle error response
//         // print('Logout failed: ${response.statusCode}');
//         DLoaders.errorSnackBar(
//             title: 'Logout Failed', message: '${response.statusCode}');
//       }
//     } catch (e) {
//       // Handle network or other errors
//       // print('Error during logout: $e');
//       DLoaders.errorSnackBar(title: 'Logout Failed', message: '$e');
//     }
//   }
// }
