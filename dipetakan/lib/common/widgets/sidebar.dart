import 'package:dipetakan/features/authentication/screens/resetpassword/reset_password.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:dipetakan/features/authentication/screens/login/login.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          // const SizedBox(height: DSizes.spaceBtwItems),

          //User Header
          UserAccountsDrawerHeader(
            accountName: Text(DTexts.accountName,
                style: Theme.of(context).textTheme.headlineSmall),
            accountEmail: Text(DTexts.accountEmail,
                style: Theme.of(context).textTheme.bodyMedium),
            currentAccountPicture: const CircleAvatar(),
            currentAccountPictureSize: const Size.fromRadius(35),
            decoration: const BoxDecoration(color: Colors.white),
          ),

          //Profil Saya
          ListTile(
            leading: const Icon(Iconsax.user),
            title: Text(DTexts.profile,
                style: Theme.of(context).textTheme.bodyLarge),
            onTap: () {},
          ),

          //Ubah Password
          ListTile(
            leading: const Icon(Iconsax.lock),
            title: Text(DTexts.ubahPassword,
                style: Theme.of(context).textTheme.bodyLarge),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ResetPassScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Iconsax.message_question),
            title: Text(DTexts.bantuan,
                style: Theme.of(context).textTheme.bodyLarge),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Iconsax.logout),
            title: Text(DTexts.signOut,
                style: Theme.of(context).textTheme.bodyLarge),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
