import 'package:dipetakan/features/authentication/screens/signup/widgets/signup_body.dart';
import 'package:dipetakan/features/authentication/screens/signup/widgets/signup_header.dart';
import 'package:dipetakan/util/constants/sizes.dart';
// import 'package:dipetakan/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final dark = DHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: DSizes.sm,
            left: DSizes.defaultSpace,
            right: DSizes.defaultSpace,
            bottom: DSizes.defaultSpace,
          ),
          child: Column(
            children: [
              /// Title & Sub-Title
              DSignupHeader(),

              /// Form & Button
              DSignupBody(),
            ],
          ),
        ),
      ),
    );
  }
}
