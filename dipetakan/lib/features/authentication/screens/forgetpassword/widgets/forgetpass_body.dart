import 'package:dipetakan/features/authentication/controllers/forget_password/forget_password_controller.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:dipetakan/util/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class DForgetPassBody extends StatefulWidget {
  const DForgetPassBody({
    super.key,
  });

  @override
  State<DForgetPassBody> createState() => _DForgetPassBodyState();
}

class _DForgetPassBodyState extends State<DForgetPassBody> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Form(
      key: controller.forgetPasswordFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: DSizes.spaceBtwSections),
        child: Column(
          children: [
            //Email
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
            const SizedBox(height: DSizes.spaceBtwItems),
          ],
        ),
      ),
    );
  }
}
