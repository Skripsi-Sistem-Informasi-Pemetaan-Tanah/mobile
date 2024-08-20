import 'package:dipetakan/features/navigation/controllers/update_username_controller.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:dipetakan/util/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class EditUsernameScreen extends StatefulWidget {
  const EditUsernameScreen({super.key});

  @override
  State<EditUsernameScreen> createState() => _EditUsernameScreenState();
}

class _EditUsernameScreenState extends State<EditUsernameScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateUsernameController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: DColors.primary,
        title: const Text(
          'Edit Username',
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
            //Edit Username
            Form(
              key: controller.updateUsernameFormKey,
              child: TextFormField(
                controller: controller.username,
                validator: ((value) =>
                    TValidator.validateEmptyText('Username', value)),
                decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.user_edit),
                    labelText: DTexts.username),
              ),
            ),

            const SizedBox(height: DSizes.spaceBtwSections),

            //Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => controller.updateUsername(),
                  child: const Text('Ubah')),
            ),
            const SizedBox(height: DSizes.spaceBtwItems),
          ]),
        ),
      ),
    );
  }
}
