import 'package:dipetakan/features/navigation/screens/akunsaya.dart';
import 'package:dipetakan/features/navigation/screens/menu.dart';
import 'package:dipetakan/features/navigation/screens/notification.dart';
// import 'package:dipetakan/features/navigation/screens/sidebar.dart';
// import 'package:dipetakan/features/lahansaya/screens/lahan_saya.dart';
// import 'package:dipetakan/features/petalahan/screens/peta_lahan.dart';
// import 'package:dipetakan/features/tambahlahan/screens/tambahlahan.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = DHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: DColors.primary,
        // centerTitle: true,
        leading: null,
        automaticallyImplyLeading: false,
        title: const Text(
          'DIPETAKAN',
          // textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontStyle: FontStyle.normal),
        ),
        // actions: <Widget>[
        //   Stack(
        //     children: <Widget>[
        //       Align(
        //         child: IconButton(
        //           icon: const Icon(Icons.notifications, color: Colors.white),
        //           onPressed: () {
        //             setState(() {
        //               counter = 0;
        //             });
        //             Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                   builder: (context) => const NotificationScreen()),
        //             );
        //           },
        //         ),
        //       ),
        //       counter != 0
        //           ? Positioned(
        //               right: 11,
        //               top: 11,
        //               child: Container(
        //                 padding: const EdgeInsets.all(2),
        //                 decoration: BoxDecoration(
        //                   color: const Color.fromARGB(255, 94, 90, 89),
        //                   borderRadius: BorderRadius.circular(6),
        //                 ),
        //                 constraints: const BoxConstraints(
        //                   minWidth: 14,
        //                   minHeight: 14,
        //                 ),
        //                 child: Text(
        //                   '$counter',
        //                   style: const TextStyle(
        //                     color: Colors.white,
        //                     fontSize: 8,
        //                   ),
        //                   textAlign: TextAlign.center,
        //                 ),
        //               ),
        //             )
        //           : Container()
        //     ],
        //   )
        // ],
      ),
      // drawer: const SideBar(),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Visibility(
      //   visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
      //   child: FloatingActionButton(
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => const TambahLahan()),
      //       );
      //     },
      //     backgroundColor: DColors.primary,
      //     foregroundColor: Colors.white,
      //     shape: const CircleBorder(),
      //     child: const Icon(Iconsax.add),
      //   ),
      // ),
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
              NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
              NavigationDestination(
                  icon: Icon(Iconsax.user), label: 'Akun Saya'),
            ]),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [MenuScreen(), const AkunSaya()];
}
