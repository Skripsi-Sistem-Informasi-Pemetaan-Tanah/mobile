// import 'package:dipetakan/features/tambahlahan/screens/widgets/submit_lahan.dart';
import 'package:dipetakan/features/tambahlahan/screens/widgets/tambah_lahan_body.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:flutter/material.dart';

class TambahLahan extends StatefulWidget {
  const TambahLahan({super.key});

  @override
  State<TambahLahan> createState() => _TambahLahanState();
}

class _TambahLahanState extends State<TambahLahan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DColors.lightGrey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: DColors.primary,
        title: const Text(
          'Plot Lahan',
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
            TambahLahanBody(),
            // SubmitLahan(),
          ]),
        ),
      ),
    );
  }
}
