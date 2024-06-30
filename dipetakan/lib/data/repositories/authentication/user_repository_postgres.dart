// // import 'package:dipetakan/features/authentication/models/user_model.dart';
// import 'dart:io';

// import 'package:dipetakan/features/authentication/models/user_model_postgres.dart';
// import 'package:dipetakan/util/exceptions/firebase_exceptions.dart';
// import 'package:dipetakan/util/exceptions/format_exceptions.dart';
// import 'package:dipetakan/util/exceptions/platform_exceptions.dart';
// import 'package:dipetakan/util/popups/loaders.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:image_picker/image_picker.dart';

// class UserRepository extends GetxController {
//   static UserRepository get instance => Get.find();
//   final String baseUrl = 'http://192.168.1.18:3000';

//   final storage = const FlutterSecureStorage();

//   // Future<void> saveUserRecord(UserModel user, String token) async {
//   //   final response = await http.post(
//   //     Uri.parse('$baseUrl/register'),
//   //     headers: {
//   //       'Content-Type': 'application/json',
//   //       'Authorization': 'Bearer $token',
//   //     },
//   //     body: jsonEncode(user.toJson()),
//   //   );
//   //   if (response.statusCode != 201) {
//   //     throw Exception('Failed to save user record');
//   //   }
//   // }

//   Future<String?> getToken() async {
//     return await storage.read(key: 'auth_token');
//   }

//   Future<void> deleteToken() async {
//     await storage.delete(key: 'auth_token');
//   }

//   Future<UserModel> fetchUserDetails(String token) async {
//     final token = await getToken(); // Retrieve the token from secure storage
//     if (token == null) throw Exception('Token not found');

//     final response = await http.get(
//       Uri.parse('$baseUrl/user'),
//       headers: {
//         'Authorization': 'Bearer $token',
//       },
//     );

//     if (response.statusCode == 200) {
//       return UserModel.fromJson(jsonDecode(response.body));
//     } else {
//       // print('Failed to fetch user details: ${response.body}');
//       DLoaders.errorSnackBar(
//           title: 'Logout Failed',
//           message: '${response.statusCode} + ${response.body}');
//       throw Exception('Failed to fetch user details');
//     }
//   }

//   Future<void> updateUserDetails(UserModel updatedUser, String token) async {
//     final response = await http.put(
//       Uri.parse('$baseUrl/user'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//       body: jsonEncode(updatedUser.toJson()),
//     );

//     if (response.statusCode != 200) {
//       throw Exception('Failed to update user details');
//     }
//   }

//   Future<void> removeUserRecord(String token) async {
//     final response = await http.delete(
//       Uri.parse('$baseUrl/user'),
//       headers: {
//         'Authorization': 'Bearer $token',
//       },
//     );

//     if (response.statusCode != 204) {
//       throw Exception('Failed to delete user record');
//     }
//   }

//   Future<void> uploadProfilePicture(String token, String imageUrl) async {
//     // Update the user's profile picture in the database
//     final response = await http.put(
//       Uri.parse('$baseUrl/user/profile-picture'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//       body: jsonEncode({'profilePicture': imageUrl}),
//     );

//     if (response.statusCode != 200) {
//       throw Exception('Failed to upload profile picture');
//     }
//   }

//   //Upload any images
//   Future<String> uploadImage(String path, XFile image) async {
//     try {
//       final ref = FirebaseStorage.instance.ref(path).child(image.name);
//       await ref.putFile(File(image.path));
//       final url = await ref.getDownloadURL();
//       return url;
//     } on FirebaseException catch (e) {
//       throw TFirebaseException(e.code).message;
//     } on FormatException catch (_) {
//       throw const TFormatException();
//     } on PlatformException catch (e) {
//       throw TPlatformException(e.code).message;
//     } catch (e) {
//       throw 'Something went wrong. Please try again';
//     }
//   }
// }
