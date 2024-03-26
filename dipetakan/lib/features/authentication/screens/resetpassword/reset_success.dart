import 'package:dipetakan/features/authentication/screens/login/login.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';

class ResetPassSuccessScreen extends StatelessWidget {
  const ResetPassSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(DSizes.defaultSpace),
            child: Column(
              children: [
                const SizedBox(height: DSizes.appBarHeight),

                ///Title & Subtitle
                Text(DTexts.resetPasswordSuccessTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center),
                const SizedBox(height: DSizes.spaceBtwItems),
                Text(DTexts.resetPasswordSuccessSubtitle,
                    style: Theme.of(context).textTheme.labelMedium,
                    textAlign: TextAlign.center),

                const SizedBox(height: DSizes.spaceBtwSections),

                ///Buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text(DTexts.signIn)),
                ),
              ],
            )),
      ),
    );
  }
}
