import 'package:dipetakan/features/authentication/screens/forgetpassword/forget_password.dart';
import 'package:dipetakan/features/authentication/screens/signup/signup.dart';
import 'package:dipetakan/features/navigation/screens/navigation.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class DLoginBody extends StatefulWidget {
  const DLoginBody({
    super.key,
  });

  @override
  State<DLoginBody> createState() => _DLoginBodyState();
}

class _DLoginBodyState extends State<DLoginBody> {
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
            const SizedBox(height: DSizes.spaceBtwInputFields / 2),

            //Remember me & Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Remember Me
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value;
                        });
                      },
                    ),
                    const Text(DTexts.rememberMe),
                  ],
                ),

                //Forget Password
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgetPassScreen()),
                      );
                    },
                    child: const Text(DTexts.forgetPassword)),
              ],
            ),
            const SizedBox(height: DSizes.spaceBtwSections),

            //Sign in Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NavigationMenu()),
                    );
                  },
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
