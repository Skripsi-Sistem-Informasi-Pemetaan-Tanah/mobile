import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:flutter/material.dart';

class DLoginHeader extends StatefulWidget {
  const DLoginHeader({
    super.key,
  });

  @override
  State<DLoginHeader> createState() => _DLoginHeaderState();
}

class _DLoginHeaderState extends State<DLoginHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: DSizes.xl),
        Text(DTexts.loginTitle,
            style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: DSizes.sm),
        Text(DTexts.loginSubTitle,
            style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
