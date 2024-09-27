import 'package:dipetakan/features/authentication/screens/forgetpassword/widgets/forgetpass_body.dart';
import 'package:dipetakan/features/authentication/screens/forgetpassword/widgets/forgetpass_header.dart';
import 'package:dipetakan/features/authentication/screens/login/login.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:flutter/material.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({super.key});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.arrow_back))),
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
              DForgetPassHeader(),

              /// Form & Button
              DForgetPassBody(),
            ],
          ),
        ),
      ),
    );
  }
}
