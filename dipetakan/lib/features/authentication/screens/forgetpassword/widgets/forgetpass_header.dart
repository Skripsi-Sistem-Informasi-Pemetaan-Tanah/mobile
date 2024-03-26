import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:flutter/material.dart';

class DForgetPassHeader extends StatelessWidget {
  const DForgetPassHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(DTexts.forgetPasswordTitle,
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: DSizes.sm),
          Text(DTexts.forgetPasswordSubTitle,
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
