import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:flutter/material.dart';

class DSignupHeader extends StatelessWidget {
  const DSignupHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(DTexts.signupTitle,
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: DSizes.sm),
          Text(DTexts.signupSubTitle,
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
