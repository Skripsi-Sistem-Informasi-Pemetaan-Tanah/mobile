import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dipetakan/data/repositories/authentication/authentication_repository.dart';
import 'package:dipetakan/features/tambahlahan/models/lahan_model.dart';
import 'package:dipetakan/util/exceptions/firebase_exceptions.dart';
import 'package:dipetakan/util/exceptions/format_exceptions.dart';
import 'package:dipetakan/util/exceptions/platform_exceptions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class LahanRepository extends GetxController {
  static LahanRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save Lahan record to Firestore
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
    } catch (e) {
      throw 'Failed to save lahan record: $e';
    }
  }

  // Fetch Lahan details based on user ID and lahan name
  Future<LahanModel?> fetchLahanDetails(String id) async {
    try {
      final userId = AuthenticationRepository.instance.authUser?.uid;
      if (userId != null) {
        final documentSnapshot = await _db
            .collection("Users")
            .doc(userId)
            .collection("Lahan")
            .doc(id)
            .get();
        if (documentSnapshot.exists) {
          return LahanModel.fromSnapshot(documentSnapshot);
        }
      }
      return null;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to fetch lahan details: $e';
    }
  }

  // Fetch all Lahan details based on user ID
  Future<List<LahanModel>> fetchAllLahan() async {
    try {
      final userId = AuthenticationRepository.instance.authUser?.uid;
      if (userId != null) {
        final querySnapshot =
            await _db.collection("Users").doc(userId).collection("Lahan").get();

        return querySnapshot.docs
            .map((doc) => LahanModel.fromSnapshot(doc))
            .toList();
      } else {
        throw 'User not authenticated';
      }
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
