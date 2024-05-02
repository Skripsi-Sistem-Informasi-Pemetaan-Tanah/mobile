import 'package:dipetakan/features/authentication/controllers/login/login_controller.dart';
import 'package:dipetakan/features/authentication/screens/forgetpassword/forget_password.dart';
import 'package:dipetakan/features/authentication/screens/signup/signup.dart';
// import 'package:dipetakan/features/navigation/screens/navigation.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:dipetakan/util/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: unnecessary_import
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:iconsax/iconsax.dart';

class DLoginBody extends StatefulWidget {
  const DLoginBody({
    super.key,
  });

  @override
  State<DLoginBody> createState() => _DLoginBodyState();
}

class _DLoginBodyState extends State<DLoginBody> {
  final controller = Get.put(LoginController());
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  // ignore: prefer_typing_uninitialized_variables
  // var _passwordInVisible;
  // ignore: prefer_typing_uninitialized_variables
  // var isChecked;

  // @override
  // void initState() {
  //   super.initState();
  //   // _passwordInVisible = true;
  //   // isChecked = false;
  // }

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(LoginController());

    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: DSizes.spaceBtwSections),
        child: Column(
          children: [
            //Email
            TextFormField(
              controller: controller.email,
              validator: (value) => TValidator.validateEmail(value),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: DTexts.email),
            ),
            const SizedBox(height: DSizes.spaceBtwInputFields),

            //Password
            Obx(
              () => TextFormField(
                controller: controller.password,
                validator: (value) =>
                    TValidator.validateEmptyText('Password', value),
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
            const SizedBox(height: DSizes.spaceBtwInputFields / 2),

            //Remember me & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Remember Me
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                          value: controller.rememberMe.value,
                          onChanged: (value) => controller.rememberMe.value =
                              !controller.rememberMe.value),
                    ),
                    const Text(DTexts.rememberMe),
                  ],
                ),

                //Forget Password
                TextButton(
                    onPressed: () => Get.off(() => const ForgetPassScreen()),
                    child: const Text(DTexts.forgetPassword)),
              ],
            ),
            const SizedBox(height: DSizes.spaceBtwSections),

            //Sign in Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => controller.emailAndPasswordSignIn(),
                  child: const Text(DTexts.signIn)),
            ),
            const SizedBox(height: DSizes.spaceBtwItems),

            //Create Account Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupScreen()),
                    );
                  },
                  child: const Text(DTexts.createAccount)),
            ),
          ],
        ),
      ),
    );
  }
}
