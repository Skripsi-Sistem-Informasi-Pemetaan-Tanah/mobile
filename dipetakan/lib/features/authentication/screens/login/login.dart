import 'package:dipetakan/common/styles/spacing_styles.dart';
import 'package:dipetakan/features/authentication/screens/login/widgets/login_body.dart';
import 'package:dipetakan/features/authentication/screens/login/widgets/login_header.dart';
// import 'package:dipetakan/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
          ],
        ),
      )),
    );
  }
}
