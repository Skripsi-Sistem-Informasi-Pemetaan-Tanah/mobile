import 'package:dipetakan/features/lahansaya/screens/widgets/list_lahan.dart';
import 'package:dipetakan/features/lahansaya/screens/widgets/search_bar.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:flutter/material.dart';

class LahanSayaScreen extends StatelessWidget {
  const LahanSayaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DColors.secondary,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: DColors.primary,
        title: const Text(
          'Lahan Saya',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontStyle: FontStyle.normal),
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(children: [
          CustomSearchBar(),
          ListLahan(),
        ]),
      ),
    );
  }
}
