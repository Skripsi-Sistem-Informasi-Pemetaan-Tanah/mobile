import 'package:dipetakan/features/lahansaya/screens/widgets/edit_lahan_body.dart';
import 'package:dipetakan/features/tambahlahan/models/lahan_model.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditLahan extends StatefulWidget {
  final LahanModel lahan;

  const EditLahan({super.key, required this.lahan});

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
          'Revisi Foto Patokan',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontStyle: FontStyle.normal),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: DSizes.defaultSpace,
            right: DSizes.defaultSpace,
            bottom: DSizes.defaultSpace,
          ),
          child: Column(children: <Widget>[
            EditLahanBody(lahan: widget.lahan),
          ]),
        ),
      ),
    );
  }
}
