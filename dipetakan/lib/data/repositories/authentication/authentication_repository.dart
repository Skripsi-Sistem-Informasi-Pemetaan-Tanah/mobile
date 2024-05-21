import 'package:dipetakan/data/repositories/authentication/user_repository.dart';
// import 'package:dipetakan/features/authentication/models/user_model.dart';
import 'package:dipetakan/features/authentication/screens/login/login.dart';
import 'package:dipetakan/features/authentication/screens/signup/email_verification.dart';
// import 'package:dipetakan/features/authentication/screens/signup/signup.dart';
import 'package:dipetakan/features/navigation/screens/navigation.dart';
import 'package:dipetakan/util/exceptions/firebase_auth_exceptions.dart';
import 'package:dipetakan/util/exceptions/firebase_exceptions.dart';
import 'package:dipetakan/util/exceptions/format_exceptions.dart';
import 'package:dipetakan/util/exceptions/platform_exceptions.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //Variables
  final deviceStorage = GetStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Get authenticated user data
  User? get authUser => _auth.currentUser;

  //Called from main.dart on app launch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    // screenRedirect();
  }

  //Function to show relevant screen
  screenRedirect() async {
    final user = _auth.currentUser;
    if (user != null) {
      if (user.emailVerified) {
        Get.offAll(() => const NavigationMenu());
      } else {
        Get.offAll(() => VerifyEmailScreen(email: _auth.currentUser?.email));
      }
    } else {
      // Local Storage
      if (kDebugMode) {
        print('================== GET STORAGE ===============');
        print(deviceStorage.read('IsFirstTime'));
      }
      deviceStorage.writeIfNull('IsFirstTime', true);
      deviceStorage.read('IsFirstTime') != true
          ? Get.offAll(() => const LoginScreen())
          : Get.offAll(() => const LoginScreen());
    }
  }

  /*------------------------Email & Password Sign-in -------------------------*/
  // Future loginWithEmailAndPassword(String email, String password) async {
  //   try {
  //     User? user = (await FirebaseAuth.instance
  //             .signInWithEmailAndPassword(email: email, password: password))
  //         .user;
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       print('No user found for that email.');
  //     } else if (e.code == 'wrong-password') {
  //       print('Wrong password provided for that user.');
  //     }
  //   }
  // }

  // Future<User?> loginWithEmailAndPassword(String email, String password) async {
  //   try {
  //     User? user = (await _auth.signInWithEmailAndPassword(
  //             email: email, password: password))
  //         .user;
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found' || e.code == 'wrong-password') {
  //       DLoaders.errorSnackBar(
  //           title: 'Invalid email or password',
  //           message: 'Please check your information');
  //     } else {
  //       DLoaders.errorSnackBar(
  //           title: 'Error', message: 'An error occurred: ${e.code}');
  //     }
  //   }
  //   return null;
  // }

  ///Email Auth Login
  Future<UserCredential?> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      // ignore: unused_local_variable
      User? user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
    } on FirebaseAuthException catch (e) {
      // if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      //   DLoaders.errorSnackBar(
      //       title: 'Invalid email or password',
      //       message: 'Please check your information');
      // } else {
      //   DLoaders.errorSnackBar(
      //       title: 'Error', message: 'An error occurred: ${e.code}');
      // }
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code);
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      // DLoaders.errorSnackBar(
      //     title: 'Error', message: 'Something went wrong try again');
      throw 'Something went wrong, try again!';
    }
    return null;
  }

  /// Email auth - Register
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, try again!';
    }
  }

  //Email verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, try again!';
    }
  }

  //Forget Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, try again!';
    }
  }

  //Re-Authenticated Email
  Future<void> reAuthenticatedEmailandPassword(
      String email, String password) async {
    try {
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, try again!';
    }
  }

  //Re-Authenticated Email
  Future<void> verifyBeforeUpdateEmail(String newEmail) async {
    try {
      await _auth.currentUser!.verifyBeforeUpdateEmail(newEmail);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, try again!';
    }
  }

  Future<void> userUpdated() async {
    try {
      FirebaseAuth.instance.userChanges().listen((User? user) {
        if (user != null && user.emailVerified) {
          FirebaseFirestore.instance
              .collection('Users')
              .doc(user.uid)
              .update({'Email': user.email}).then((_) {
            // ignore: avoid_print
            print('Firestore email updated.');
          }).catchError((e) {
            // ignore: avoid_print
            print('Error updating Firestore: $e');
          });
        }
      });
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, try again!';
    }
  }

  //Logout
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, try again!';
    }
  }

  //Delete account
  Future<void> deleteAccount() async {
    try {
      await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, try again!';
    }
  }
}
