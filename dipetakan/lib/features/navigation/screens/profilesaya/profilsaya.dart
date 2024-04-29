// import 'package:dipetakan/features/navigation/screens/profilesaya/edit_profil.dart';
import 'package:dipetakan/features/navigation/screens/profilesaya/editprofil/edit_email.dart';
import 'package:dipetakan/features/navigation/screens/profilesaya/editprofil/edit_nama.dart';
import 'package:dipetakan/features/navigation/screens/profilesaya/editprofil/edit_notelp.dart';
import 'package:dipetakan/features/navigation/screens/profilesaya/editprofil/edit_username.dart';
import 'package:dipetakan/features/navigation/screens/profilesaya/widgets/circular_image.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:flutter/material.dart';

class ProfilSayaScreen extends StatefulWidget {
  const ProfilSayaScreen({super.key});

  @override
  State<ProfilSayaScreen> createState() => _ProfilSayaScreenState();
}

class _ProfilSayaScreenState extends State<ProfilSayaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: DColors.primary,
        title: const Text(
          'Profile Saya',
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
                  const DCircularImages(
                      image: 'assets/images/user.png', width: 100, height: 100),
                  TextButton(
                      onPressed: () {}, child: const Text('Ubah Foto Profil'))
                ],
              ),
            ),
            const SizedBox(height: DSizes.spaceBtwItems / 2),
            const Divider(),
            const SizedBox(height: DSizes.spaceBtwItems),

            //Informasi Akun
            InformasiAkun(
                title: DTexts.namalengkap,
                value: DTexts.accountName,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditNamaScreen()));
                }),
            InformasiAkun(
                title: DTexts.username,
                value: 'asriaziziyah',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditUsernameScreen()));
                }),
            InformasiAkun(
                title: DTexts.email,
                value: 'asriaziziyah123@gmail.com',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditEmailScreen()));
                }),
            InformasiAkun(
                title: DTexts.phoneNo,
                value: '089612080576',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditNotelpScreen()));
                }),

            const SizedBox(height: DSizes.spaceBtwSections),
          ]),
        ),
      ),
      floatingActionButton: Padding(
          padding: const EdgeInsets.all(DSizes.defaultSpace),
          child: TextButton(
              onPressed: () {},
              child: const Text('Hapus Akun',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.red,
                      fontWeight: FontWeight.w600)))

          // Column(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     //Edit Profile
          //     SizedBox(
          //       width: double.infinity,
          //       child: ElevatedButton(
          //           onPressed: () {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => const EditProfilScreen()),
          //             );
          //           },
          //           child: const Text('Edit Profile')),
          //     ),
          //     const SizedBox(height: DSizes.spaceBtwInputFields),
          //     //Hapus Akun Button
          //     TextButton(
          //         onPressed: () {},
          //         child: const Text('Hapus Akun',
          //             style: TextStyle(
          //                 fontSize: 15,
          //                 color: Colors.red,
          //                 fontWeight: FontWeight.w600)))
          //     // SizedBox(
          //     //   width: double.infinity,
          //     //   child: ElevatedButton(
          //     //       onPressed: () {},
          //     //       style: ElevatedButton.styleFrom(
          //     //         backgroundColor: Colors.red,
          //     //         side: const BorderSide(color: Colors.red),
          //     //       ),
          //     //       child: const Text('Hapus Akun')),
          //     // ),
          //   ],
          // ),
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
