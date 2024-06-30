import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dipetakan/data/repositories/authentication/authentication_repository.dart';
import 'package:dipetakan/features/tambahlahan/models/lahan_model.dart';
// import 'package:dipetakan/util/constants/api_constants.dart';
import 'package:dipetakan/util/exceptions/firebase_exceptions.dart';
import 'package:dipetakan/util/exceptions/format_exceptions.dart';
import 'package:dipetakan/util/exceptions/platform_exceptions.dart';
// import 'package:dipetakan/util/popups/loaders.dart';
// import 'package:dipetakan/util/popups/loaders.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class LahanRepository extends GetxController {
  static LahanRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  // ignore: unnecessary_overrides
  void onInit() {
    super.onInit();
    // _fetchDataFromPostgresql();
  }

  // Future<void> _fetchDataFromPostgresql() async {
  //   var url = Uri.parse('$baseUrl/getAllLahan');
  //   var response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> responseData = json.decode(response.body);

  //     final FirebaseFirestore db = FirebaseFirestore.instance;

  //     // Using a batch write to Firestore for efficiency
  //     WriteBatch batch = db.batch();

  //     // Update data in Firestore
  //     if (responseData.containsKey('lahan')) {
  //       List<dynamic> lahanData = responseData['lahan'];
  //       for (var lahan in lahanData) {
  //         String userId = lahan['user_id'];
  //         String mapId = lahan['map_id'];
  //         DocumentReference lahanRef = db.collection('Lahan').doc(mapId);

  //         // Convert updated_at in lahan to Firestore Timestamp
  //         if (lahan.containsKey('updated_at')) {
  //           String updatedAtString = lahan['updated_at'];
  //           DateTime updatedAt = DateTime.parse(updatedAtString);
  //           Timestamp updatedAtTimestamp = Timestamp.fromDate(updatedAt);
  //           lahan['updated_at'] = updatedAtTimestamp;
  //         }

  //         Map<String, dynamic> lahanDataToUpdate = {
  //           'koordinat': lahan.containsKey('koordinat')
  //               ? List<Map<String, dynamic>>.from(lahan['koordinat'])
  //               : [],
  //           'verifikasi': lahan.containsKey('verifikasi')
  //               ? List<Map<String, dynamic>>.from(lahan['verifikasi'])
  //               : [],
  //           'updated_at': lahan['updated_at']
  //         };

  //         // Convert updated_at in verifikasi to Firestore Timestamp
  //         if (lahan.containsKey('verifikasi')) {
  //           List<Map<String, dynamic>> verifikasiList =
  //               List<Map<String, dynamic>>.from(lahan['verifikasi']);
  //           for (var verifikasi in verifikasiList) {
  //             if (verifikasi.containsKey('updated_at')) {
  //               String verifikasiUpdatedAtString = verifikasi['updated_at'];
  //               DateTime verifikasiUpdatedAt =
  //                   DateTime.parse(verifikasiUpdatedAtString);
  //               Timestamp verifikasiUpdatedAtTimestamp =
  //                   Timestamp.fromDate(verifikasiUpdatedAt);
  //               verifikasi['updated_at'] = verifikasiUpdatedAtTimestamp;
  //             }
  //           }
  //           lahanDataToUpdate['verifikasi'] = verifikasiList;
  //         }

  //         batch.set(lahanRef, lahanDataToUpdate, SetOptions(merge: true));

  //         // Also update in the user-specific collection
  //         DocumentReference userLahanRef =
  //             db.collection('Users').doc(userId).collection('Lahan').doc(mapId);
  //         batch.set(userLahanRef, lahanDataToUpdate, SetOptions(merge: true));
  //       }
  //     }

  //     // Commit the batch write
  //     await batch.commit();
  //     // DLoaders.successSnackBar(
  //     //     title: 'Success', message: 'Data updated successfully in Firestore');
  //   } else {
  //     DLoaders.errorSnackBar(title: 'Fail', message: 'Failed to fetch data');
  //   }
  // }

  // final String baseUrl = 'http://192.168.1.18:3000';

  Future<void> saveLahanRecord(LahanModel lahan) async {
    try {
      final userId = AuthenticationRepository.instance.authUser?.uid;
      if (userId != null) {
        await _db
            .collection("Users")
            .doc(userId)
            .collection("Lahan")
            .doc(lahan.id)
            .set(lahan.toJson());
      } else {
        throw 'User not authenticated';
      }

      // // Prepare the data to be sent to the server
      // Map<String, dynamic> dataToSend = {
      //   'user_id': userId,
      //   ...lahan
      //       .toJsonPostgres(), // Use the toJsonPostgres method to format the data
      // };

      // // Send data to Node.js server to save to PostgreSQL
      // var url = Uri.parse('$baseUrl/saveLahan');
      // var response = await http.post(
      //   url,
      //   headers: {
      //     'Content-Type': 'application/json',
      //   },
      //   body: jsonEncode(dataToSend),
      // );

      // if (response.statusCode != 200) {
      //   print('Failed to save lahan details: ${response.body}');
      //   DLoaders.errorSnackBar(
      //       title: 'Oh Snap!',
      //       message: '${response.statusCode} + ${response.body}');
      //   // throw Exception('Failed to fetch user details');
      //   // throw 'Failed to save lahan record to PostgreSQL';
      // }
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to fetch save lahan record: $e';
    }
  }

  // // Fetch Lahan details based on user ID and lahan name
  // Future<LahanModel?> fetchLahanDetails(String id) async {
  //   try {
  //     final userId = AuthenticationRepository.instance.authUser?.uid;
  //     if (userId != null) {
  //       final documentSnapshot = await _db
  //           .collection("Users")
  //           .doc(userId)
  //           .collection("Lahan")
  //           .doc(id)
  //           .get();
  //       if (documentSnapshot.exists) {
  //         return LahanModel.fromSnapshot(documentSnapshot);
  //       }
  //     }
  //     return null;
  //   } on FirebaseException catch (e) {
  //     throw TFirebaseException(e.code).message;
  //   } on FormatException catch (_) {
  //     throw const TFormatException();
  //   } on PlatformException catch (e) {
  //     throw TPlatformException(e.code).message;
  //   } catch (e) {
  //     throw 'Failed to fetch lahan details: $e';
  //   }
  // }

  // // Fetch all Lahan details based on user ID
  // Future<List<LahanModel>> fetchAllLahanByUserId() async {
  //   try {
  //     final userId = AuthenticationRepository.instance.authUser?.uid;
  //     if (userId != null) {
  //       final querySnapshot =
  //           await _db.collection("Users").doc(userId).collection("Lahan").get();

  //       return querySnapshot.docs
  //           .map((doc) => LahanModel.fromSnapshot(doc))
  //           .toList();
  //     } else {
  //       throw 'User not authenticated';
  //     }
  //   } catch (e) {
  //     throw 'Failed to fetch lahan records: $e';
  //   }
  // }

  // Listen for changes to Lahan records by user ID
  Stream<List<LahanModel>> fetchAllLahanByUserId() {
    try {
      final userId = AuthenticationRepository.instance.authUser?.uid;
      if (userId != null) {
        return _db
            .collection("Users")
            .doc(userId)
            .collection("Lahan")
            .snapshots()
            .map((querySnapshot) {
          return querySnapshot.docs
              .map((doc) => LahanModel.fromSnapshot(doc))
              .toList();
        });
      } else {
        throw 'User not authenticated';
      }
    } catch (e) {
      throw 'Failed to fetch lahan records: $e';
    }
  }

  // Future<List<LahanModel>> fetchAllLahan() async {
  //   try {
  //     final querySnapshot = await _db.collection("Lahan").get();
  //     return querySnapshot.docs
  //         .map((doc) => LahanModel.fromSnapshot(doc))
  //         .toList();
  //   } on FirebaseException catch (e) {
  //     throw TFirebaseException(e.code).message;
  //   } on PlatformException catch (e) {
  //     throw TPlatformException(e.code).message;
  //   } catch (e) {
  //     throw 'Failed to fetch lahan records: $e';
  //   }
  // }

// Listen for changes to all Lahan records
  Stream<List<LahanModel>> fetchAllLahan() {
    try {
      return _db.collection("Lahan").snapshots().map((querySnapshot) {
        return querySnapshot.docs
            .map((doc) => LahanModel.fromSnapshot(doc))
            .toList();
      });
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to fetch lahan records: $e';
    }
  }

  // Update Lahan data in Firestore
  Future<void> updateLahanDetails(LahanModel updatedLahan) async {
    try {
      final userId = AuthenticationRepository.instance.authUser?.uid;
      if (userId != null) {
        await _db
            .collection("Users")
            .doc(userId)
            .collection("Lahan")
            .doc(updatedLahan.id)
            .set(updatedLahan.toJson());
      } else {
        throw 'User not authenticated';
      }
    } catch (e) {
      throw 'Failed to update lahan details: $e';
    }
  }

  // Remove Lahan record from Firestore
  Future<void> removeLahanRecord(String id) async {
    try {
      final userId = AuthenticationRepository.instance.authUser?.uid;
      if (userId != null) {
        await _db
            .collection("Users")
            .doc(userId)
            .collection("Lahan")
            .doc(id)
            .delete();
      } else {
        throw 'User not authenticated';
      }
    } catch (e) {
      throw 'Failed to remove lahan record: $e';
    }
  }

  // Upload image to Firebase Storage
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

  // Delete image from Firebase Storage
  Future<void> deleteImage(String url) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
      await ref.delete();
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
