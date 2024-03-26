// import 'package:dipetakan/features/tambahlahan/screens/widgets/submit_lahan.dart';
import 'package:dipetakan/features/tambahlahan/screens/widgets/edit_patokan_body.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:flutter/material.dart';

class EditPatokan extends StatefulWidget {
  const EditPatokan({super.key});

  @override
  State<EditPatokan> createState() => _EditPatokanState();
}

class _EditPatokanState extends State<EditPatokan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DColors.lightGrey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: DColors.primary,
        title: const Text(
          'Edit Patokan',
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
            EditPatokanBody(),
            // SubmitLahan(),
          ]),
        ),
      ),
      // floatingActionButton:
      //     // Container(
      //     //   child:
      //     Padding(
      //   padding: const EdgeInsets.only(
      //     left: DSizes.defaultSpace,
      //     right: DSizes.defaultSpace,
      //     bottom: DSizes.defaultSpace,
      //   ),
      //   child: SizedBox(
      //     width: double.infinity,
      //     child: ElevatedButton(
      //         onPressed: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) => const EditPatokan()),
      //           );
      //         },
      //         child: const Text(DTexts.submit)),
      //   ),
      // ),
      // // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
