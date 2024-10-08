import 'package:dipetakan/data/repositories/authentication/authentication_repository.dart';
import 'package:dipetakan/features/navigation/controllers/user_controller.dart';
import 'package:dipetakan/features/navigation/screens/profilesaya/profilsaya.dart';
import 'package:dipetakan/features/navigation/screens/profilesaya/widgets/circular_image.dart';
import 'package:dipetakan/features/navigation/screens/tentang_aplikasi.dart';
import 'package:dipetakan/features/navigation/screens/ubahpassword.dart';
import 'package:dipetakan/features/navigation/screens/widgets/shimmer.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/image_strings.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AkunSaya extends StatelessWidget {
  const AkunSaya({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          return SingleChildScrollView(
            child: Container(
              color: DColors.primary,
              child: Column(
                children: [
                  Container(
                    color: DColors.primary,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 24.0, right: 24.0, bottom: 24.0),
                      child: Row(
                        children: [
                          Obx(() {
                            final networkImage =
                                controller.user.value.profilePicture;
                            final image = networkImage.isNotEmpty
                                ? networkImage
                                : TImages.user;
                            return controller.imageUploading.value
                                ? const DShimmerEfffect(width: 80, height: 80)
                                : DCircularImages(
                                    image: image,
                                    width: 80,
                                    height: 80,
                                    isNetworkImage: networkImage.isNotEmpty);
                          }),
                          const SizedBox(width: DSizes.md),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.user.value.fullName,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: DSizes.xs),
                              Text(
                                controller.user.value.email,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            //Profil Saya
                            ListTile(
                                leading: const Icon(Iconsax.user),
                                title: Text(DTexts.profile,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ProfilSayaScreen()),
                                  );
                                },
                                trailing: const Icon(Iconsax.arrow_right_3)),
                            const Divider(),
                            //Ubah Password
                            ListTile(
                                leading: const Icon(Iconsax.lock),
                                title: Text(DTexts.ubahPassword,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const UbahPassword()),
                                  );
                                },
                                trailing: const Icon(Iconsax.arrow_right_3)),
                            const Divider(),
                            //Bantuan
                            ListTile(
                                leading: const Icon(Iconsax.message_question),
                                title: Text('Tentang Aplikasi',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TentangAplikasiScreen()),
                                  );
                                },
                                trailing: const Icon(Iconsax.arrow_right_3)),
                            const Divider(),
                            const SizedBox(height: DSizes.spaceBtwSections),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () => AuthenticationRepository
                                        .instance
                                        .logout(),
                                    child: const Text(DTexts.signOut)),
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          );
        });
      }),
    );
  }
}
