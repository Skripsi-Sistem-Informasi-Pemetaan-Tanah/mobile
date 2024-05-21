import 'package:dipetakan/features/navigation/controllers/update_name_controller.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:dipetakan/util/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class EditNamaScreen extends StatefulWidget {
  const EditNamaScreen({super.key});

  @override
  State<EditNamaScreen> createState() => _EditNamaScreenState();
}

class _EditNamaScreenState extends State<EditNamaScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateNameController());
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
            //Edit nama
            Form(
              key: controller.updateUserFullnameFormKey,
              child: TextFormField(
                controller: controller.fullName,
                validator: ((value) =>
                    TValidator.validateEmptyText('Nama Lengkap', value)),
                decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.user),
                    labelText: DTexts.namalengkap),
              ),
            ),

            const SizedBox(height: DSizes.spaceBtwSections),

            //Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => controller.updateUserFullname(),
                  child: const Text('Ubah')),
            ),
            const SizedBox(height: DSizes.spaceBtwItems),
          ]),
        ),
      ),
    );
  }
}
