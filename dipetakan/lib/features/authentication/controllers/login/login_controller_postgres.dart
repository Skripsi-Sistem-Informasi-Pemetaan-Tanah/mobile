// // import 'package:dipetakan/data/repositories/authentication/authentication_repository.dart';
// // import 'package:dipetakan/features/navigation/screens/navigation.dart';
// import 'package:dipetakan/features/navigation/screens/profilesaya/profilsaya.dart';
// import 'package:dipetakan/util/constants/image_strings.dart';
// import 'package:dipetakan/util/helpers/network_manager.dart';
// import 'package:dipetakan/util/popups/full_screen_loader.dart';
// import 'package:dipetakan/util/popups/loaders.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class LoginController extends GetxController {
//   static LoginController get instance => Get.find();

//   ///variables
//   final rememberMe = false.obs;
//   final hidePassword = true.obs;
//   final localStorage = GetStorage();
//   final email = TextEditingController();
//   final password = TextEditingController();
//   final storage = const FlutterSecureStorage();
//   GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

//   @override
//   void onInit() {
//     String? rememberedEmail = localStorage.read('REMEMBER_ME_EMAIL');
//     String? rememberedPassword = localStorage.read('REMEMBER_ME_PASSWORD');

//     if (rememberedEmail != null) {
//       email.text = rememberedEmail;
//     }

//     if (rememberedPassword != null) {
//       password.text = rememberedPassword;
//     }

//     super.onInit();
//   }

//   Future<void> emailAndPasswordSignIn() async {
//     try {
//       // Start loading
//       DFullScreenLoader.openLoadingDialog(
//           'Logging you in....', TImages.docerAnimation);

//       // Check Internet Connectivity
//       final isConnected = await NetworkManager.instance.isConnected();
//       if (!isConnected) {
//         // Remove loader
//         DFullScreenLoader.stopLoading();
//         return;
//       }

//       // Form validation
//       if (!loginFormKey.currentState!.validate()) {
//         DFullScreenLoader.stopLoading();
//         return;
//       }

//       // Save email and password if rememberMe is checked
//       if (rememberMe.value) {
//         localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
//         localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
//       }

//       // Send login request to Node.js backend
//       final response = await http.post(
//         Uri.parse(
//             'http://192.168.1.18:3000/login'), // Change this to your backend URL
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'email': email.text.trim(),
//           'password': password.text.trim(),
//         }),
//       );

//       // Handle response
//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         final token = responseData['token'];
//         await storage.write(key: 'auth_token', value: token);
//         // Save the token in local storage (or handle it as needed)
//         // localStorage.write('token', token);

//         // Remove loader
//         DFullScreenLoader.stopLoading();

//         // Redirect to the appropriate screen
//         // Assuming you have a method to handle screen redirection
//         // AuthenticationRepository.instance.screenRedirect();
//         // Get.to(() => const NavigationMenu());
//         Get.to(() => const ProfilSayaScreen());
//       } else {
//         final responseData = json.decode(response.body);
//         // throw Exception(responseData['error'] ?? 'Login failed');
//         final errorMessage = responseData['error'] ?? 'Login failed';
//         DLoaders.errorSnackBar(title: 'Oh Snap!', message: errorMessage);
//       }
//     } catch (e) {
//       // Remove loader
//       DFullScreenLoader.stopLoading();

//       // Show some generic error to the user
//       DLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
//     }
//   }
// }
