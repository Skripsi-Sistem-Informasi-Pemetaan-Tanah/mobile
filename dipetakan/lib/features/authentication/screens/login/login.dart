import 'package:dipetakan/common/styles/spacing_styles.dart';
import 'package:dipetakan/features/authentication/screens/login/widgets/login_body.dart';
import 'package:dipetakan/features/authentication/screens/login/widgets/login_header.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
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
