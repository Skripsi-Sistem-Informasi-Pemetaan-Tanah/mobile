import 'package:dipetakan/data/repositories/authentication/user_repository.dart';
import 'package:dipetakan/data/repositories/tambahlahan/lahan_repository.dart';
import 'package:dipetakan/features/authentication/models/user_model.dart';
import 'package:dipetakan/features/tambahlahan/models/lahan_model.dart';
import 'package:get/get.dart';

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
    fetchAllUserRecords();
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
        Get.snackbar('Error', 'Failed to fetch lahan records: $error');
        profileLoading.value = false;
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch lahan records: $e');
      profileLoading.value = false;
    }
  }

  // Function to fetch all user records
  Future<void> fetchAllUserRecords() async {
    try {
      profileLoading.value = true;
      final userIds = await userRepository.fetchAllUserIds();

      // Fetch user details for each user ID
      for (var userId in userIds) {
        final userSnapshot = await userRepository.fetchUserById(userId);
        final user = UserModel.fromSnapshot(userSnapshot);
        userList.add(user);
      }

      profileLoading.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user records: $e');
      profileLoading.value = false;
    }
  }
}
