import 'dart:convert';
import 'package:dipetakan/data/repositories/authentication/authentication_repository.dart';
import 'package:dipetakan/data/repositories/authentication/user_repository.dart';
import 'package:dipetakan/features/authentication/models/user_model.dart';
import 'package:dipetakan/features/tambahlahan/models/lahan_model.dart';
import 'package:dipetakan/util/constants/api_constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LahanSayaController extends GetxController {
  static LahanSayaController get instance => Get.find();

  final userRepository = Get.put(UserRepository());

  Rx<UserModel> user = UserModel.empty().obs;
  final profileLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
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

  Future<List<LahanModel>> fetchDataFromPostgresql() async {
    final userId = AuthenticationRepository.instance.authUser?.uid;
    var url = Uri.parse('$baseUrl/getAllLahanbyUserId/$userId');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      List<LahanModel> lahanList = [];

      if (responseData.containsKey('data') &&
          responseData['data'].containsKey('lahan')) {
        List<dynamic> lahanData = responseData['data']['lahan'];

        for (var lahan in lahanData) {
          lahanList.add(LahanModel.fromJson(lahan));
        }
      }

      return lahanList;
    } else {
      throw Exception('Gagal mendapatkan data');
    }
  }
}
