// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dipetakan/data/repositories/authentication/authentication_repository.dart';
import 'package:dipetakan/features/authentication/models/user_model.dart';
import 'package:dipetakan/util/constants/api_constants.dart';
import 'package:dipetakan/util/exceptions/firebase_exceptions.dart';
import 'package:dipetakan/util/exceptions/format_exceptions.dart';
import 'package:dipetakan/util/exceptions/platform_exceptions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //Save user data to firestore
  Future<void> saveUserRecord(UserModel user) async {
    try {
      // Send data to Node.js server to save to PostgreSQL
      // var url = Uri.parse('$baseUrl/saveUser');
      // var response = await http.post(
      //   url,
      //   headers: {
      //     'Content-Type': 'application/json',
      //   },
      //   body: jsonEncode(user.toJson()),
      // );

      // if (response.statusCode != 200) {
      //   DLoaders.errorSnackBar(title: 'Oh Snap!', message: 'Gagal Menyimpan');
      //   DFullScreenLoader.stopLoading();
      // }

      await _db.collection("Users").doc(user.id).set(user.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //Fetch user details based on user ID
  Future<UserModel> fetchUserDetails() async {
    try {
      final documentSnapshot = await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Future<List<String>> fetchAllUserIds() async {
  //   try {
  //     final querySnapshot = await _db.collection("Users").get();
  //     return querySnapshot.docs.map((doc) => doc.id).toList();
  //   } on FirebaseException catch (e) {
  //     throw TFirebaseException(e.code).message;
  //   } on PlatformException catch (e) {
  //     throw TPlatformException(e.code).message;
  //   } catch (e) {
  //     throw 'Something went wrong. Please try again';
  //   }
  // }

  Future<List<String>> fetchAllUserIds() async {
    try {
      final querySnapshot = await _db.collection("Users").get();
      return querySnapshot.docs.map((doc) => doc.id).toList();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchUserById(
      String userId) async {
    try {
      return await _db.collection("Users").doc(userId).get();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to fetch user details: $e';
    }
  }

  // ignore: unused_element
  // Future<void> _fetchDataFromPostgresql() async {
  //   // Fetch data from Node.js server
  //   final userId = AuthenticationRepository.instance.authUser?.uid;

  //   if (userId == null) {
  //     print('User ID is null');
  //     return;
  //   }

  //   var url = Uri.parse('$baseUrl/getLahanbyUserId?user_id=$userId');
  //   var response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> responseData = json.decode(response.body);

  //     final FirebaseFirestore db = FirebaseFirestore.instance;

  //     // Using a batch write to Firestore for efficiency
  //     WriteBatch batch = db.batch();

  //     // Update data in Firestore
  //     if (responseData.containsKey('koordinat')) {
  //       List<dynamic> koordinatData = responseData['koordinat'];
  //       for (var koordinatList in koordinatData) {
  //         for (var koordinat in koordinatList) {
  //           String mapId = koordinat['map_id'];
  //           DocumentReference koordinatRef = db
  //               .collection('Users')
  //               .doc(userId)
  //               .collection('Lahan')
  //               .doc(mapId);
  //           // Update the existing document
  //           batch.update(koordinatRef, koordinat);
  //         }
  //       }
  //     }

  //     if (responseData.containsKey('verifikasi')) {
  //       List<dynamic> verifikasiData = responseData['verifikasi'];
  //       for (var verifikasi in verifikasiData) {
  //         // Assuming 'id' is the unique identifier for documents in Firestore
  //         String lahanId = verifikasi['map_id'];
  //         DocumentReference lahanRef = db
  //             .collection('Users')
  //             .doc(userId)
  //             .collection('Lahan')
  //             .doc(lahanId);
  //         // Update the existing document
  //         batch.update(lahanRef, verifikasi);
  //       }
  //     }

  //     // Commit the batch write
  //     await batch.commit();
  //     print('Data updated successfully in Firestore');
  //   } else {
  //     print('Failed to fetch data');
  //   }
  // }

  //Update user data in firestore
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      await _db
          .collection("Users")
          .doc(updatedUser.id)
          .set(updatedUser.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //Remove any field in spesifics user collection
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .update(json);

      // Send update to Node.js server
      // var url = Uri.parse('$baseUrl/updateField');
      // var response = await http.put(
      //   url,
      //   headers: {
      //     'Content-Type': 'application/json',
      //   },
      //   body: jsonEncode({
      //     'id': AuthenticationRepository.instance.authUser?.uid,
      //     ...json,
      //   }),
      // );

      // if (response.statusCode != 200) {
      //   throw 'Failed to update user in PostgreSQL';
      // }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //Remove user data in firestore
  Future<void> removeUserRecord(UserModel user, String userId) async {
    try {
      // Send data to Node.js server to save to PostgreSQL
      // var url = Uri.parse('$baseUrl/deleteUser/$userId');
      // var response = await http.post(
      //   url,
      //   headers: {
      //     'Content-Type': 'application/json',
      //   },
      //   body: jsonEncode(user.toJson()),
      // );

      // if (response.statusCode != 200) {
      //   DLoaders.errorSnackBar(title: 'Oh Snap!', message: 'Gagal Menghapus');
      //   return;
      //   // DFullScreenLoader.stopLoading();
      // }

      await _db.collection("Users").doc(userId).delete();

      // // Send delete request to Node.js server
      // var url = Uri.parse('$baseUrl/deleteUser/$userId');
      // var response = await http.delete(url);

      // if (response.statusCode != 200) {
      //   throw 'Failed to delete user from PostgreSQL';
      // }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //Upload any images
  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
