// import 'dart:convert';
// import 'package:dipetakan/data/repositories/authentication/user_repository.dart';
// import 'package:dipetakan/features/authentication/models/user_model.dart';
// import 'package:dipetakan/features/tambahlahan/models/lahan_model.dart';
// import 'package:dipetakan/util/constants/api_constants.dart';
// import 'package:dipetakan/util/popups/loaders.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;

// class InfoLahanController extends GetxController {
//   static InfoLahanController get instance => Get.find();

//   final userRepository = Get.put(UserRepository());

//   var lahanList = <LahanModel>[].obs;
//   var userList = <UserModel>[].obs; // To store all user details
//   final profileLoading = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     // fetchDataFromPostgresql();
//     fetchAllLahan();
//     fetchAllUserRecords();
//   }

//   // Function to fetch all lahan records from PostgreSQL
//   Future<void> fetchAllLahan() async {
//     try {
//       profileLoading.value = true;
//       final lahanList = await fetchDataFromPostgresql();
//       this.lahanList.assignAll(lahanList);
//       profileLoading.value = false;
//       print(lahanList);
//       DLoaders.successSnackBar(title: 'Error', message: '$lahanList');
//     } catch (e) {
//       DLoaders.errorSnackBar(
//           title: 'Error', message: 'Failed to fetch lahan records: $e');
//       profileLoading.value = false;
//     }
//   }

//   // Function to fetch all user records
//   Future<void> fetchAllUserRecords() async {
//     try {
//       profileLoading.value = true;
//       final userIds = await userRepository.fetchAllUserIds();

//       // Fetch user details for each user ID
//       for (var userId in userIds) {
//         final userSnapshot = await userRepository.fetchUserById(userId);
//         final user = UserModel.fromSnapshot(userSnapshot);
//         userList.add(user);
//       }

//       profileLoading.value = false;
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to fetch user records: $e');
//       profileLoading.value = false;
//     }
//   }

//   Future<List<LahanModel>> fetchDataFromPostgresql() async {
//     var url = Uri.parse('$baseUrl/getAllLahan');
//     var response = await http.get(url);

//     if (response.statusCode == 200) {
//       Map<String, dynamic> responseData = json.decode(response.body);
//       List<LahanModel> lahanList = [];

//       if (responseData.containsKey('data') &&
//           responseData['data'].containsKey('lahan')) {
//         List<dynamic> lahanData = responseData['data']['lahan'];

//         for (var lahan in lahanData) {
//           // Convert the JSON data to LahanModel
//           lahanList.add(LahanModel.fromJson(lahan));
//         }
//       }

//       return lahanList;
//     } else {
//       throw Exception('Failed to fetch data from PostgreSQL');
//     }
//   }
// }

import 'dart:convert';

import 'package:dipetakan/data/repositories/authentication/user_repository.dart';
import 'package:dipetakan/data/repositories/tambahlahan/lahan_repository.dart';
import 'package:dipetakan/features/authentication/models/user_model.dart';
import 'package:dipetakan/features/tambahlahan/models/lahan_model.dart';
import 'package:dipetakan/util/constants/api_constants.dart';
import 'package:dipetakan/util/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InfoLahanController extends GetxController {
  static InfoLahanController get instance => Get.find();

  final lahanRepository = Get.put(LahanRepository());
  final userRepository = Get.put(UserRepository());

  var lahanList = <LahanModel>[].obs;
  var userList = <UserModel>[].obs; // To store all user details
  final profileLoading = false.obs;

  Stream<List<LahanModel>> get lahanStream =>
      lahanRepository.fetchAllLahanByUserId();

  @override
  void onInit() {
    super.onInit();
    // fetchAllLahan();
    listenForLahanChanges();
    // fetchAllUserRecords();
  }

  // Function to fetch all lahan records
  // Future<void> fetchAllLahan() async {
  //   try {
  //     profileLoading.value = true;
  //     final lahanList = await lahanRepository.fetchAllLahan();
  //     this.lahanList.assignAll(lahanList);
  //     profileLoading.value = false;
  //   } catch (e) {
  //     Get.snackbar('Error', 'Failed to fetch lahan records: $e');
  //     profileLoading.value = false;
  //   }
  // }

  void listenForLahanChanges() {
    try {
      profileLoading.value = true;
      lahanRepository.fetchAllLahan().listen((data) {
        lahanList.assignAll(data);
        profileLoading.value = false;
      }, onError: (error) {
        DLoaders.errorSnackBar(
            title: 'Error', message: 'Gagal mendapatkan data: $error');
        profileLoading.value = false;
      });
    } catch (e) {
      DLoaders.errorSnackBar(
          title: 'Error', message: 'Gagal mendapatkan data: $e');
      profileLoading.value = false;
    }
  }

  // Function to fetch all user records
  // Future<void> fetchAllUserRecords() async {
  //   try {
  //     profileLoading.value = true;
  //     final userIds = await userRepository.fetchAllUserIds();

  //     // Fetch user details for each user ID
  //     for (var userId in userIds) {
  //       final userSnapshot = await userRepository.fetchUserById(userId);
  //       final user = UserModel.fromSnapshot(userSnapshot);
  //       userList.add(user);
  //     }

  //     profileLoading.value = false;
  //   } catch (e) {
  //     DLoaders.errorSnackBar(
  //         title: 'Error', message: 'Failed to fetch user records: $e');
  //     profileLoading.value = false;
  //   }
  // }

  Future<List<LahanModel>> fetchDataFromPostgresql() async {
    var url = Uri.parse('$baseUrl/getAllLahan');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      List<LahanModel> lahanList = [];

      if (responseData.containsKey('data') &&
          responseData['data'].containsKey('lahan')) {
        List<dynamic> lahanData = responseData['data']['lahan'];

        for (var lahan in lahanData) {
          // Convert the JSON data to LahanModel
          lahanList.add(LahanModel.fromJson(lahan));
        }
      }

      return lahanList;
    } else {
      throw Exception('Gagal mendapatkan data');
    }
  }
}
