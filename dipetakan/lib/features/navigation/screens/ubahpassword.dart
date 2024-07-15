import 'package:dipetakan/features/authentication/controllers/forget_password/forget_password_controller.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:dipetakan/util/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class UbahPassword extends StatefulWidget {
  const UbahPassword({super.key});

  @override
  State<UbahPassword> createState() => _UbahPasswordState();
}

class _UbahPasswordState extends State<UbahPassword> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: DColors.primary,
        title: const Text(
          'Ubah Password',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontStyle: FontStyle.normal),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: DSizes.defaultSpace,
            left: DSizes.defaultSpace,
            right: DSizes.defaultSpace,
            bottom: DSizes.defaultSpace,
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Masukkan Ulang Email',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: DSizes.spaceBtwItems),
                TextFormField(
                  controller: controller.email,
                  validator: TValidator.validateEmail,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.direct_right),
                      labelText: DTexts.email),
                ),

                const SizedBox(height: DSizes.spaceBtwSections),

                //Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => controller.sendPasswordResetEmail(),
                      child: const Text(DTexts.submit)),
                ),
              ]),
        ),
      ),
    );
  }
}
