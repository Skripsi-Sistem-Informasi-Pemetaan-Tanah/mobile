import 'package:dipetakan/features/authentication/screens/resetpassword/reset_success.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
// import 'package:dipetakan/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class DResetPassBody extends StatelessWidget {
  const DResetPassBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // final dark = DHelperFunctions.isDarkMode(context);
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: DSizes.spaceBtwSections),
        child: Column(
          children: [
            //New Password
            TextFormField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.password_check),
                  labelText: DTexts.newPassword),
            ),

            const SizedBox(height: DSizes.spaceBtwInputFields),

            //Confirm Pass
            TextFormField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.password_check),
                  labelText: DTexts.confirmPassword),
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
                          builder: (context) => const ResetPassSuccessScreen()),
                    );
                  },
                  child: const Text(DTexts.submit)),
            ),
            const SizedBox(height: DSizes.spaceBtwItems),
          ],
        ),
      ),
    );
  }
}
