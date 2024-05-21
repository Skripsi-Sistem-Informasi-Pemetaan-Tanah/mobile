import 'package:dipetakan/data/repositories/authentication/user_repository.dart';
import 'package:dipetakan/data/repositories/tambahlahan/lahan_repository.dart';
import 'package:dipetakan/features/authentication/models/user_model.dart';
import 'package:dipetakan/features/tambahlahan/models/lahan_model.dart';
import 'package:get/get.dart';

class LahanSayaController extends GetxController {
  static LahanSayaController get instance => Get.find();

  final lahanRepository = Get.put(LahanRepository());
  var lahanList = <LahanModel>[].obs;
  Rx<UserModel> user = UserModel.empty().obs;
  final profileLoading = false.obs;
  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    super.onInit();
    fetchAllLahan();
    fetchUserRecord();
  }

  // Function to fetch all lahan records
  Future<void> fetchAllLahan() async {
    try {
      profileLoading.value = true;
      final lahanList = await lahanRepository.fetchAllLahan();
      this.lahanList.assignAll(lahanList);
      profileLoading.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch lahan records: $e');
      profileLoading.value = false;
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
}
