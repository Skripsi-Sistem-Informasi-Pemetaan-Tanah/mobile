import 'package:dipetakan/features/authentication/controllers/signup/signup_controller.dart';
// import 'package:dipetakan/features/authentication/controllers/signup/signup_controller_postgres.dart';
import 'package:dipetakan/features/authentication/screens/signup/kebijakan_privasi.dart';
import 'package:dipetakan/features/authentication/screens/signup/ketentuan_penggunaan.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:dipetakan/util/validators/validation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';

class DSignupBody extends StatefulWidget {
  const DSignupBody({
    super.key,
  });

  @override
  State<DSignupBody> createState() => _DSignupBodyState();
}

class _DSignupBodyState extends State<DSignupBody> {
  // ignore: prefer_typing_uninitialized_variables
  // var _passwordInVisible;
  // ignore: prefer_typing_uninitialized_variables
  // var isChecked;

  @override
  void initState() {
    super.initState();
    // _passwordInVisible = true;
    // isChecked = false;
  }

  @override
  Widget build(BuildContext context) {
    // final dark = DHelperFunctions.isDarkMode(context);
    final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: DSizes.spaceBtwSections),
        child: Column(
          children: [
            //Nama Lengkap
            TextFormField(
              controller: controller.namaLengkap,
              validator: (value) =>
                  TValidator.validateEmptyText('Nama lengkap', value),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.user),
                  labelText: DTexts.namalengkap),
            ),
            const SizedBox(height: DSizes.spaceBtwInputFields),

            //Username
            TextFormField(
              controller: controller.username,
              validator: (value) =>
                  TValidator.validateEmptyText('Username', value),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.user_edit),
                  labelText: DTexts.username),
            ),
            const SizedBox(height: DSizes.spaceBtwInputFields),

            //Email
            TextFormField(
              controller: controller.email,
              validator: (value) => TValidator.validateEmail(value),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: DTexts.email),
            ),
            const SizedBox(height: DSizes.spaceBtwInputFields),

            //No Telepon
            TextFormField(
              controller: controller.phoneNo,
              validator: (value) => TValidator.validatePhoneNumber(value),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.call), labelText: DTexts.phoneNo),
            ),
            const SizedBox(height: DSizes.spaceBtwInputFields),

            //Password
            Obx(
              () => TextFormField(
                controller: controller.password,
                validator: (value) => TValidator.validatePassword(value),
                obscureText: controller.hidePassword.value,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.password_check),
                  labelText: DTexts.password,
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye),
                  ),
                ),
              ),
            ),
            const SizedBox(height: DSizes.spaceBtwInputFields),

            //Privacy Policy
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Obx(
                    () => Checkbox(
                        value: controller.privacyPolicy.value,
                        onChanged: (value) => controller.privacyPolicy.value =
                            !controller.privacyPolicy.value),
                  ),
                ),
                const SizedBox(width: DSizes.spaceBtwItems),
                Expanded(
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: '${DTexts.iAgreeTo} ',
                          style: Theme.of(context).textTheme.bodySmall),
                      TextSpan(
                        text: DTexts.privacyPolicy,
                        style: Theme.of(context).textTheme.bodySmall!.apply(
                              color: DColors.primary,
                              // dark ? DColors.white : DColors.primary,
                              decoration: TextDecoration.underline,
                              decorationColor: DColors.primary,
                              // dark ? DColors.white : DColors.primary,
                            ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigate to the Privacy Policy screen
                            Get.to(() => const KebijakanPrivasi());
                          },
                      ),
                      TextSpan(
                          text: ' ${DTexts.and} ',
                          style: Theme.of(context).textTheme.bodySmall),
                      TextSpan(
                        text: DTexts.termsOfUse,
                        style: Theme.of(context).textTheme.bodySmall!.apply(
                              color: DColors.primary,
                              // dark ? DColors.white : DColors.primary,
                              decoration: TextDecoration.underline,
                              decorationColor: DColors.primary,
                              // dark ? DColors.white : DColors.primary,
                            ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigate to the Privacy Policy screen
                            Get.to(() => const KetentuanPenggunaan());
                          },
                      ),
                    ]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DSizes.spaceBtwSections),

            //Sign up Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => controller.signup(),
                  child: const Text(DTexts.createAccount)),
            ),
            const SizedBox(height: DSizes.spaceBtwItems),

            //Sign in Button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Sudah Punya Akun? Login',
                      style: TextStyle(color: Colors.black))),
            ),
            const SizedBox(height: DSizes.spaceBtwItems),
          ],
        ),
      ),
    );
  }
}
