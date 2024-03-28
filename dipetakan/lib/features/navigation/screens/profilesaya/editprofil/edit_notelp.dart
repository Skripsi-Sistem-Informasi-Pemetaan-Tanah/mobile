import 'package:dipetakan/features/navigation/screens/profilesaya/profilsaya.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class EditNotelpScreen extends StatefulWidget {
  const EditNotelpScreen({super.key});

  @override
  State<EditNotelpScreen> createState() => _EditNotelpScreenState();
}

class _EditNotelpScreenState extends State<EditNotelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: DColors.primary,
        title: const Text(
          'Edit Profil',
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
            //Edit No telepon
            TextFormField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.call), labelText: DTexts.phoneNo),
            ),

            const SizedBox(height: DSizes.spaceBtwSections),

            //Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilSayaScreen()),
                    );
                  },
                  child: const Text('Ubah')),
            ),
            const SizedBox(height: DSizes.spaceBtwItems),
          ]),
        ),
      ),
    );
  }
}
