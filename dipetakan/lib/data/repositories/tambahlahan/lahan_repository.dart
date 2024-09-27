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
        throw 'User tidak terauntetikasi';
      }
    } catch (e) {
      throw 'Gagal mendapatkan data: $e';
    }
  }

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
      throw 'Gagal mendapatkan data: $e';
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
      throw 'Ada sebuah kesalahan, harap coba lagi!';
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
      throw 'Ada sebuah kesalahan, harap coba lagi!';
    }
  }
}
