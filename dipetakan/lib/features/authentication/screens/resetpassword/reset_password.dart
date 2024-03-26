// import 'package:dipetakan/features/authentication/screens/resetpassword/resetpass_header.dart';
import 'package:dipetakan/features/authentication/screens/resetpassword/widgets/resetpass_body.dart';
import 'package:dipetakan/features/authentication/screens/resetpassword/widgets/resetpass_header.dart';
import 'package:dipetakan/util/constants/sizes.dart';
// import 'package:dipetakan/util/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class ResetPassScreen extends StatelessWidget {
  const ResetPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final dark = DHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
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
              DResetPassHeader(),

              /// Form & Button
              DResetPassBody(),
            ],
          ),
        ),
      ),
    );
  }
}
