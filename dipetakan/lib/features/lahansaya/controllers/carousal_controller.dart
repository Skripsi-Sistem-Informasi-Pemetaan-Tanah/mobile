import 'package:get/get.dart';

class CarousalController extends GetxController {
  static CarousalController get instance => Get.find();

  final carousalCurrentIndex = 0.obs;

  void updatePageIndicator(index) {
    carousalCurrentIndex.value = index;
  }
}
