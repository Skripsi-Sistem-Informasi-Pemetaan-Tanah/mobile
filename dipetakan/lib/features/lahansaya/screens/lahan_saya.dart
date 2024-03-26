import 'package:dipetakan/features/lahansaya/screens/widgets/list_lahan.dart';
import 'package:dipetakan/features/lahansaya/screens/widgets/search_bar.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:flutter/material.dart';

class LahanSayaScreen extends StatelessWidget {
  const LahanSayaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: DColors.secondary,
      body: SingleChildScrollView(
        child: Column(children: [
          CustomSearchBar(),
          ListLahan(),
        ]),
      ),
    );
  }
}
