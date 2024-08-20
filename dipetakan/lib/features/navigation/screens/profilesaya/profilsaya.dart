// import 'package:dipetakan/features/navigation/screens/profilesaya/edit_profil.dart';
import 'package:dipetakan/features/navigation/controllers/user_controller.dart';
// import 'package:dipetakan/features/navigation/controllers/user_controller_postgres.dart';
import 'package:dipetakan/features/navigation/screens/navigation.dart';
import 'package:dipetakan/features/navigation/screens/profilesaya/editprofil/edit_email.dart';
import 'package:dipetakan/features/navigation/screens/profilesaya/editprofil/edit_nama.dart';
import 'package:dipetakan/features/navigation/screens/profilesaya/editprofil/edit_notelp.dart';
import 'package:dipetakan/features/navigation/screens/profilesaya/editprofil/edit_username.dart';
import 'package:dipetakan/features/navigation/screens/profilesaya/widgets/circular_image.dart';
import 'package:dipetakan/features/navigation/screens/widgets/shimmer.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/image_strings.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilSayaScreen extends StatefulWidget {
  const ProfilSayaScreen({super.key});

  @override
  State<ProfilSayaScreen> createState() => _ProfilSayaScreenState();
}

class _ProfilSayaScreenState extends State<ProfilSayaScreen> {
  @override
  Widget build(BuildContext context) {
    // final controller = UserController.instance;
    final controller = Get.put(UserController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: DColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.to(() => const NavigationMenu()),
        ),
        title: const Text(
          'Profil Saya',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontStyle: FontStyle.normal),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(DSizes.defaultSpace),
          child: Column(children: <Widget>[
            //Foto Profile
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Obx(() {
                    final networkImage = controller.user.value.profilePicture;
                    final image =
                        networkImage.isNotEmpty ? networkImage : TImages.user;
                    return controller.imageUploading.value
                        ? const DShimmerEfffect(width: 100, height: 100)
                        : DCircularImages(
                            image: image,
                            width: 100,
                            height: 100,
                            isNetworkImage: networkImage.isNotEmpty);
                  }),
                  TextButton(
                      onPressed: () => controller.uploadUserProfilePicture(),
                      child: const Text('Ubah Foto Profil',
                          style: TextStyle(color: Colors.green)))
                ],
              ),
            ),
            const SizedBox(height: DSizes.spaceBtwItems / 2),
            const Divider(),
            const SizedBox(height: DSizes.spaceBtwItems),

            //Informasi Akun
            InformasiAkun(
                title: DTexts.namalengkap,
                value: controller.user.value.fullName,
                onPressed: () => Get.to(() => const EditNamaScreen())),
            InformasiAkun(
                title: DTexts.username,
                value: controller.user.value.username,
                onPressed: () => Get.to(() => const EditUsernameScreen())),
            InformasiAkun(
                title: DTexts.email,
                value: controller.user.value.email,
                onPressed: () => Get.to(() => const EditEmailScreen())),
            InformasiAkun(
                title: DTexts.phoneNo,
                value: controller.user.value.phoneNo,
                onPressed: () => Get.to(() => const EditNotelpScreen())),

            const SizedBox(height: DSizes.spaceBtwSections),
            TextButton(
                onPressed: () =>
                    controller.deleteAccountWarningPopup(controller.user.value),
                child: const Text('Hapus Akun',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.red,
                        fontWeight: FontWeight.w600)))
          ]),
        ),
      ),
      // floatingActionButton: Padding(
      //     padding: const EdgeInsets.all(DSizes.defaultSpace),
      //     child: TextButton(
      //         onPressed: () =>
      //             controller.deleteAccountWarningPopup(controller.user.value),
      //         child: const Text('Hapus Akun',
      //             style: TextStyle(
      //                 fontSize: 15,
      //                 color: Colors.red,
      //                 fontWeight: FontWeight.w600))
      //                 )
      //     ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class InformasiAkun extends StatelessWidget {
  const InformasiAkun({
    super.key,
    required this.title,
    required this.value,
    required this.onPressed,
  });

  final VoidCallback onPressed;
  final String title, value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: DSizes.spaceBtwItems / 1.5),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Expanded(
              child: Icon(Icons.edit, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
