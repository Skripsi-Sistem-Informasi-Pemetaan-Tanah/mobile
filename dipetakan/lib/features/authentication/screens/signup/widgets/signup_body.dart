import 'package:dipetakan/features/authentication/screens/signup/account_created.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:dipetakan/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
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
  var _passwordInVisible;
  // ignore: prefer_typing_uninitialized_variables
  var isChecked;

  @override
  void initState() {
    super.initState();
    _passwordInVisible = true;
    isChecked = false;
  }

  @override
  Widget build(BuildContext context) {
    final dark = DHelperFunctions.isDarkMode(context);
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: DSizes.spaceBtwSections),
        child: Column(
          children: [
            //Nama Lengkap
            TextFormField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.user),
                  labelText: DTexts.namalengkap),
            ),
            const SizedBox(height: DSizes.spaceBtwInputFields),

            //Username
            TextFormField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.user_edit),
                  labelText: DTexts.username),
            ),
            const SizedBox(height: DSizes.spaceBtwInputFields),

            //Email
            TextFormField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: DTexts.email),
            ),
            const SizedBox(height: DSizes.spaceBtwInputFields),

            //No Telepon
            TextFormField(
              decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.call), labelText: DTexts.phoneNo),
            ),
            const SizedBox(height: DSizes.spaceBtwInputFields),

            //Password
            TextFormField(
              obscureText: _passwordInVisible,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check),
                labelText: DTexts.password,
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordInVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordInVisible =
                          !_passwordInVisible; //change boolean value
                    });
                  },
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
                  child: Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: DSizes.spaceBtwItems),
                Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: '${DTexts.iAgreeTo} ',
                        style: Theme.of(context).textTheme.bodySmall),
                    TextSpan(
                        text: DTexts.privacyPolicy,
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                              color: dark ? DColors.white : DColors.primary,
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  dark ? DColors.white : DColors.primary,
                            )),
                    TextSpan(
                        text: ' ${DTexts.and} ',
                        style: Theme.of(context).textTheme.bodySmall),
                    TextSpan(
                        text: DTexts.termsOfUse,
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                              color: dark ? DColors.white : DColors.primary,
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  dark ? DColors.white : DColors.primary,
                            )),
                  ]),
                ),
              ],
            ),
            const SizedBox(height: DSizes.spaceBtwSections),

            //Sign up Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AccountCreatedScreen()),
                    );
                  },
                  child: const Text(DTexts.createAccount)),
            ),
            const SizedBox(height: DSizes.spaceBtwItems),
          ],
        ),
      ),
    );
  }
}
