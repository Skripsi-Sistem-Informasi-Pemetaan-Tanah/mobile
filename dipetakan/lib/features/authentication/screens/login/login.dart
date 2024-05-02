import 'package:dipetakan/common/styles/spacing_styles.dart';
import 'package:dipetakan/features/authentication/screens/login/widgets/login_body.dart';
import 'package:dipetakan/features/authentication/screens/login/widgets/login_header.dart';
// import 'package:dipetakan/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final LoginController controller = Get.put(LoginController());

  // @override
  // void initState() {
  //   super.initState();
  //   // Call any initialization logic here
  // }

  @override
  Widget build(BuildContext context) {
    // final dark = DHelperFunctions.isDarkMode(context);

    return const Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: DSpacingStyle.paddingWithAppBarHeight,
        child: Column(
          children: [
            /// Title & Sub-Title
            DLoginHeader(),

            /// Form & Button
            DLoginBody(),
            // Form(
            //   key: controller.loginFormKey,
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(
            //         vertical: DSizes.spaceBtwSections),
            //     child: Column(
            //       children: [
            //         //Email
            //         TextFormField(
            //           controller: controller.email,
            //           validator: (value) => TValidator.validateEmail(value),
            //           decoration: const InputDecoration(
            //               prefixIcon: Icon(Iconsax.direct_right),
            //               labelText: DTexts.email),
            //         ),
            //         const SizedBox(height: DSizes.spaceBtwInputFields),

            //         //Password
            //         Obx(
            //           () => TextFormField(
            //             controller: controller.password,
            //             validator: (value) =>
            //                 TValidator.validateEmptyText('Password', value),
            //             obscureText: controller.hidePassword.value,
            //             decoration: InputDecoration(
            //               prefixIcon: const Icon(Iconsax.password_check),
            //               labelText: DTexts.password,
            //               suffixIcon: IconButton(
            //                 onPressed: () => controller.hidePassword.value =
            //                     !controller.hidePassword.value,
            //                 icon: Icon(controller.hidePassword.value
            //                     ? Iconsax.eye_slash
            //                     : Iconsax.eye),
            //               ),
            //             ),
            //           ),
            //         ),
            //         const SizedBox(height: DSizes.spaceBtwInputFields / 2),

            //         //Remember me & Forget Password
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             //Remember Me
            //             Row(
            //               children: [
            //                 Obx(
            //                   () => Checkbox(
            //                       value: controller.rememberMe.value,
            //                       onChanged: (value) => controller.rememberMe
            //                           .value = !controller.rememberMe.value),
            //                 ),
            //                 const Text(DTexts.rememberMe),
            //               ],
            //             ),

            //             //Forget Password
            //             TextButton(
            //                 onPressed: () {},
            //                 // => Get.off(() => const ForgetPassScreen()),
            //                 child: const Text(DTexts.forgetPassword)),
            //           ],
            //         ),
            //         const SizedBox(height: DSizes.spaceBtwSections),

            //         //Sign in Button
            //         SizedBox(
            //           width: double.infinity,
            //           child: ElevatedButton(
            //               onPressed: () => controller.emailAndPasswordSignIn(),
            //               child: const Text(DTexts.signIn)),
            //         ),
            //         const SizedBox(height: DSizes.spaceBtwItems),

            //         //Create Account Button
            //         SizedBox(
            //           width: double.infinity,
            //           child: OutlinedButton(
            //               onPressed: () {
            //                 Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                       builder: (context) => const SignupScreen()),
            //                 );
            //               },
            //               child: const Text(DTexts.createAccount)),
            //         ),
            //       ],
            //     ),
            //   ),
            // )
          ],
        ),
      )),
    );
  }
}
