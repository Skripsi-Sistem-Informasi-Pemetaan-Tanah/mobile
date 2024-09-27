import 'package:dipetakan/features/lahansaya/controllers/lahansaya_controller.dart';
import 'package:dipetakan/features/lahansaya/controllers/petafotopatokan_controller.dart';
import 'package:dipetakan/features/lahansaya/controllers/petavalidasi_controller.dart';
import 'package:dipetakan/features/lahansaya/screens/lahan_saya.dart';
import 'package:dipetakan/features/navigation/controllers/user_controller.dart';
import 'package:dipetakan/features/navigation/screens/bantuan.dart';
import 'package:dipetakan/features/navigation/screens/widgets/shimmer.dart';
import 'package:dipetakan/features/petalahan/controllers/infolahan_controller.dart';
import 'package:dipetakan/features/petalahan/controllers/petalahan_controller.dart';
import 'package:dipetakan/features/petalahan/screens/peta_lahan.dart';
import 'package:dipetakan/features/tambahlahan/screens/tambahlahan.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class MenuScreen extends StatelessWidget {
  MenuScreen({super.key});

  List imgData = [
    "assets/images/map.png",
    "assets/images/location.png",
    "assets/images/field.png",
    "assets/images/question.png"
  ];

  List titles = [
    "Peta Lahan",
    "Plot Lahan",
    "Lahan Saya",
    "Bantuan",
  ];

  List screen = [
    const PetaLahanScreen(),
    const TambahLahan(),
    const LahanSayaScreen(),
    const BantuanScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return OrientationBuilder(
            builder: (context, orientation) {
              int crossAxisCount = orientation == Orientation.portrait ? 2 : 4;
              return SingleChildScrollView(
                child: Container(
                  color: DColors.primary,
                  child: Column(
                    children: [
                      Container(
                        color: DColors.primary,
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 24.0, right: 24.0, bottom: 24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() {
                                if (controller.profileLoading.value) {
                                  return const DShimmerEfffect(
                                      width: 80, height: 15);
                                } else {
                                  return RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Hai, ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                        TextSpan(
                                          text: controller.user.value.fullName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }),
                              const SizedBox(height: DSizes.xs),
                              Text(
                                'Siap untuk memetakan atau melihat peta lahan?',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 25.0,
                            right: 14.0,
                            left: 14.0,
                          ),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              childAspectRatio: 1.1,
                              mainAxisSpacing: 25,
                            ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 4,
                            itemBuilder: ((context, index) {
                              return InkWell(
                                onTap: () {
                                  if (screen[index] ==
                                      const PetaLahanScreen()) {
                                    Get.delete<PetaLahanController>();
                                  }
                                  if (screen[index] ==
                                      const LahanSayaScreen()) {
                                    Get.delete<LahanSayaController>();
                                    Get.delete<PetaValidasiController>();
                                    Get.delete<PetaFotoPatokanController>();
                                    Get.delete<InfoLahanController>();
                                  }
                                  Get.to(screen[index]);
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 0,
                                        blurRadius: 6,
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.asset(imgData[index], width: 60),
                                      Text(titles[index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Items {
  String title;
  String subtitle;
  String event;
  String img;
  Items(
      {required this.title,
      required this.subtitle,
      required this.event,
      required this.img});
}
