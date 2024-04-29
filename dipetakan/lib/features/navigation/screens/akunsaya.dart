import 'package:dipetakan/features/authentication/screens/login/login.dart';
import 'package:dipetakan/features/navigation/screens/bantuan.dart';
import 'package:dipetakan/features/navigation/screens/profilesaya/profilsaya.dart';
import 'package:dipetakan/features/navigation/screens/profilesaya/widgets/circular_image.dart';
import 'package:dipetakan/features/navigation/screens/ubahpassword.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AkunSaya extends StatelessWidget {
  const AkunSaya({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: DColors.primary,
          child: Column(
            children: [
              Container(
                color: DColors.primary,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.15,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, left: 24.0, right: 24.0, bottom: 24.0),
                  child: Row(
                    children: [
                      const DCircularImages(
                          image: 'assets/images/user.png',
                          width: 80,
                          height: 80,
                          padding: 0),
                      const SizedBox(width: DSizes.md),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Asri Aziziyah',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Colors.white, // Set the color to white
                                  fontWeight: FontWeight
                                      .bold, // Set the font weight to bold
                                ),
                          ),
                          const SizedBox(height: DSizes.xs),
                          Text(
                            'asriaziziyah123@gmail.com',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors
                                          .white, // Set the text color to white
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
                height: MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        //Profil Saya
                        ListTile(
                            leading: const Icon(Iconsax.user),
                            title: Text(DTexts.profile,
                                style: Theme.of(context).textTheme.bodyLarge),
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
                                style: Theme.of(context).textTheme.bodyLarge),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const UbahPassword()),
                              );
                            },
                            trailing: const Icon(Iconsax.arrow_right_3)),
                        const Divider(),
                        //Bantuan
                        ListTile(
                            leading: const Icon(Iconsax.message_question),
                            title: Text(DTexts.bantuan,
                                style: Theme.of(context).textTheme.bodyLarge),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BantuanScreen()),
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
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                  );
                                },
                                child: const Text(DTexts.signOut)),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
