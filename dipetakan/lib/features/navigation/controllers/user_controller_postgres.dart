// // import 'package:dipetakan/features/authentication/models/user_model.dart';
// import 'package:dipetakan/data/repositories/authentication/user_repository_postgres.dart';
// import 'package:dipetakan/features/authentication/models/user_model_postgres.dart';
// import 'package:dipetakan/util/constants/sizes.dart';
// // import 'package:dipetakan/util/popups/full_screen_loader.dart';
// import 'package:dipetakan/util/popups/loaders.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class UserController extends GetxController {
//   static UserController get instance => Get.find();

//   // final userRepository = UserRepository.instance;
//   final userRepository = Get.put(UserRepository());
//   final profileLoading = false.obs;
//   Rx<UserModel> user = UserModel.empty().obs;
//   final imageUploading = false.obs;
//   final storage = const FlutterSecureStorage();

//   @override
//   void onInit() {
//     super.onInit();
//     fetchUserRecord();
//   }

//   Future<void> storeToken(String token) async {
//     await storage.write(key: 'auth_token', value: token);
//   }

//   Future<String?> getToken() async {
//     return await storage.read(key: 'auth_token');
//   }

//   Future<void> deleteToken() async {
//     await storage.delete(key: 'auth_token');
//   }

//   Future<void> fetchUserRecord() async {
//     try {
//       profileLoading.value = true;
//       final token = await userRepository
//           .getToken(); // Retrieve the token from secure storage
//       if (token != null) {
//         final fetchedUser = await userRepository.fetchUserDetails(token);
//         user.value = fetchedUser;
//       } else {
//         throw Exception('Token not found');
//       }
//     } catch (e) {
//       user(UserModel.empty());
//     } finally {
//       profileLoading.value = false;
//     }
//   }

//   // Future<void> fetchUserRecord(String token) async {
//   //   try {
//   //     profileLoading.value = true;
//   //     final fetchedUser = await userRepository.fetchUserDetails(token);
//   //     user.value = fetchedUser;
//   //   } catch (e) {
//   //     user(UserModel.empty());
//   //   } finally {
//   //     profileLoading.value = false;
//   //   }
//   // }

//   Future<void> updateUserDetails(UserModel updatedUser) async {
//     try {
//       final token = await userRepository
//           .getToken(); // Retrieve the token from secure storage
//       if (token != null) {
//         await userRepository.updateUserDetails(updatedUser, token);
//         user.value = updatedUser;
//         DLoaders.successSnackBar(
//           title: 'Success',
//           message: 'User details updated successfully',
//         );
//       } else {
//         throw Exception('Token not found');
//       }
//     } catch (e) {
//       DLoaders.errorSnackBar(title: 'Error', message: e.toString());
//     }
//   }

//   /// Delete Account Worning
//   void deleteAccountWarningPopup() {
//     Get.defaultDialog(
//       contentPadding: const EdgeInsets.all(DSizes.md),
//       title: 'Delete Account',
//       middleText:
//           "Are you sure you want to delete your account permanently? This action is not reversible and all of your data will be removed permanently",
//       confirm: ElevatedButton(
//         onPressed: () async => removeUserRecord,
//         style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.red,
//             side: const BorderSide(color: Colors.red)),
//         child: const Padding(
//             padding: EdgeInsets.symmetric(horizontal: DSizes.lg),
//             child: Text('Delete')),
//       ),
//       cancel: OutlinedButton(
//           onPressed: () => Navigator.of(Get.overlayContext!).pop(),
//           child: const Text('Cancel')),
//     );
//   }

//   void removeUserRecord() async {
//     try {
//       final token = await userRepository
//           .getToken(); // Retrieve the token from secure storage
//       if (token != null) {
//         await userRepository.removeUserRecord(token);
//         user(UserModel.empty());
//         DLoaders.successSnackBar(title: 'Success', message: 'User removed');
//       } else {
//         throw Exception('Token not found');
//       }
//     } catch (e) {
//       DLoaders.errorSnackBar(title: 'Error', message: e.toString());
//     }
//   }

//   Future<void> uploadUserProfilePicture() async {
//     try {
//       final image = await ImagePicker().pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 70,
//         maxHeight: 512,
//         maxWidth: 512,
//       );
//       if (image != null) {
//         imageUploading.value = true;

//         final token = await userRepository
//             .getToken(); // Retrieve the token from secure storage
//         if (token != null) {
//           final imageUrl =
//               await userRepository.uploadImage('Users/Images/Profile/', image);

//           await userRepository.uploadProfilePicture(token, imageUrl);

//           user.update((val) {
//             val!.profilePicture = imageUrl;
//           });

//           DLoaders.successSnackBar(
//             title: 'Success',
//             message: 'Profile picture uploaded',
//           );
//         } else {
//           throw Exception('Token not found');
//         }
//       }
//     } catch (e) {
//       DLoaders.errorSnackBar(
//         title: 'Error',
//         message: e.toString(),
//       );
//     } finally {
//       imageUploading.value = false;
//     }
//   }
// }
