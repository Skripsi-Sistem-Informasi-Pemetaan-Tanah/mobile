import 'package:dipetakan/features/authentication/screens/forgetpassword/email_sent.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
// import 'package:dipetakan/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class DForgetPassBody extends StatelessWidget {
  const DForgetPassBody({
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
            //Email
            TextFormField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: DTexts.email),
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
                          builder: (context) => const EmailSentScreen()),
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
