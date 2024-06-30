import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dipetakan/data/repositories/authentication/authentication_repository.dart';
import 'package:dipetakan/data/repositories/authentication/user_repository.dart';
import 'package:dipetakan/data/repositories/tambahlahan/lahan_repository.dart';
import 'package:dipetakan/features/authentication/models/user_model.dart';
import 'package:dipetakan/features/tambahlahan/models/lahan_model.dart';
import 'package:dipetakan/util/constants/api_constants.dart';
import 'package:dipetakan/util/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LahanSayaController extends GetxController {
  static LahanSayaController get instance => Get.find();

  final lahanRepository = Get.put(LahanRepository());
  final userRepository = Get.put(UserRepository());

  Rx<UserModel> user = UserModel.empty().obs;
  final profileLoading = false.obs;

  // Stream<List<LahanModel>> get lahanStream =>
  //     lahanRepository.fetchAllLahanByUserId();

  @override
  void onInit() {
    super.onInit();
    // _fetchDataFromPostgresql();
    fetchUserRecord();
  }

  Future<void> _fetchDataFromPostgresql() async {
    // Check server and database connection
    final serverurl = Uri.parse('$baseUrl/checkConnectionDatabase');
    final http.Response serverresponse = await http.get(serverurl);

    if (serverresponse.statusCode != 200) {
      DLoaders.errorSnackBar(
        title: 'Oh Snap!',
        message: 'Server or Database is not connected',
      );
      return;
    }

    final userId = AuthenticationRepository.instance.authUser?.uid;

    var url = Uri.parse('$baseUrl/getAllLahanbyUserId/$userId');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);

      final FirebaseFirestore db = FirebaseFirestore.instance;
      WriteBatch batch = db.batch();

      if (responseData.containsKey('data') &&
          responseData['data'].containsKey('lahan')) {
        List<dynamic> lahanData = responseData['data']['lahan'];

        for (var lahan in lahanData) {
          String userId = lahan['user_id'];
          String mapId = lahan['map_id'];
          DocumentReference lahanRef = db.collection('Lahan').doc(mapId);
          DocumentReference userLahanRef =
              db.collection('Users').doc(userId).collection('Lahan').doc(mapId);

          // Convert updated_at to Firestore Timestamp
          if (lahan.containsKey('updated_at')) {
            String updatedAtString = lahan['updated_at'];
            Timestamp updatedAt = Timestamp.fromMillisecondsSinceEpoch(
                DateTime.parse(updatedAtString).millisecondsSinceEpoch);
            lahan['updated_at'] = updatedAt;
          }

          Map<String, dynamic> lahanDataToUpdate = {
            'koordinat':
                lahan.containsKey('koordinat') ? lahan['koordinat'] : [],
            'verifikasi':
                lahan.containsKey('verifikasi') ? lahan['verifikasi'] : [],
            'updated_at': lahan['updated_at'],
          };

          // Update verifikasi 'updated_at' to Firestore Timestamp
          if (lahan.containsKey('verifikasi')) {
            List<dynamic> verifikasiList = lahan['verifikasi'];
            for (var verifikasi in verifikasiList) {
              if (verifikasi.containsKey('updated_at')) {
                String verifikasiUpdatedAtString = verifikasi['updated_at'];
                Timestamp verifikasiUpdatedAt =
                    Timestamp.fromMillisecondsSinceEpoch(
                        DateTime.parse(verifikasiUpdatedAtString)
                            .millisecondsSinceEpoch);
                verifikasi['updated_at'] = verifikasiUpdatedAt;
              }
            }
            lahanDataToUpdate['verifikasi'] = verifikasiList;
          }

          batch.set(lahanRef, lahanDataToUpdate, SetOptions(merge: true));
          batch.set(userLahanRef, lahanDataToUpdate, SetOptions(merge: true));
        }
      }

      await batch.commit();
      // DLoaders.successSnackBar(
      //   title: 'Success',
      //   message: 'Data updated successfully in Firestore',
      // );
    } else {
      DLoaders.errorSnackBar(
        title: 'Fail',
        message: 'Failed to fetch data',
      );
    }
  }

  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
      profileLoading.value = false;
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  Future<Stream<List<LahanModel>>> getLahanStream() async {
    await _fetchDataFromPostgresql();
    return lahanRepository.fetchAllLahanByUserId();
  }
}
