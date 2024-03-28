import 'package:dipetakan/features/navigation/screens/sidebar.dart';
import 'package:dipetakan/features/lahansaya/screens/lahan_saya.dart';
import 'package:dipetakan/features/petalahan/screens/peta_lahan.dart';
import 'package:dipetakan/features/tambahlahan/screens/tambahlahan.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = DHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: DColors.primary,
        centerTitle: true,
        title: const Text(
          'DIPETAKAN',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontStyle: FontStyle.normal),
        ),
      ),
      drawer: const SideBar(),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TambahLahan()),
            );
          },
          backgroundColor: DColors.primary,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          child: const Icon(Iconsax.add),
        ),
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) =>
                controller.selectedIndex.value = index,
            backgroundColor: darkMode ? DColors.black : Colors.white,
            surfaceTintColor: darkMode ? DColors.black : Colors.white,
            indicatorColor: darkMode
                ? DColors.white.withOpacity(0.1)
                : DColors.black.withOpacity(0.1),
            destinations: const [
              NavigationDestination(
                  icon: Icon(Iconsax.map), label: 'Peta Lahan'),
              NavigationDestination(
                  icon: Icon(Iconsax.layer), label: 'Lahan Saya'),
            ]),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [const PetaLahanScreen(), const LahanSayaScreen()];
}
