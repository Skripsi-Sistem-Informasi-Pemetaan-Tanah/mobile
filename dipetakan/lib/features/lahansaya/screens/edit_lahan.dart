import 'package:dipetakan/features/lahansaya/screens/widgets/edit_lahan_body.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:flutter/material.dart';

class EditLahan extends StatefulWidget {
  const EditLahan({super.key});

  @override
  State<EditLahan> createState() => _EditLahanState();
}

class _EditLahanState extends State<EditLahan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DColors.lightGrey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: DColors.primary,
        title: const Text(
          'Edit Lahan',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontStyle: FontStyle.normal),
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: DSizes.defaultSpace,
            right: DSizes.defaultSpace,
            bottom: DSizes.defaultSpace,
          ),
          child: Column(children: <Widget>[
            EditLahanBody(),
            // SubmitLahan(),
          ]),
        ),
      ),
    );
  }
}
