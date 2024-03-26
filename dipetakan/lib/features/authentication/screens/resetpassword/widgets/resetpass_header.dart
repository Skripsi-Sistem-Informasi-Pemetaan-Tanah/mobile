import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:flutter/material.dart';

class DResetPassHeader extends StatelessWidget {
  const DResetPassHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(DTexts.resetPasswordTitle,
              style: Theme.of(context).textTheme.headlineLarge),
        ],
      ),
    );
  }
}
