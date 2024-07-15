import 'package:dipetakan/features/lahansaya/screens/widgets/filter_button.dart';
import 'package:dipetakan/features/lahansaya/screens/widgets/list_lahan.dart';
import 'package:dipetakan/features/lahansaya/screens/widgets/search_bar.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:flutter/material.dart';

class LahanSayaScreen extends StatefulWidget {
  const LahanSayaScreen({super.key});

  @override
  State<LahanSayaScreen> createState() => _LahanSayaScreenState();
}

class _LahanSayaScreenState extends State<LahanSayaScreen> {
  List<String> selectedJenisLahan = [];
  List<int> selectedStatusValidasi = [];
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  void _updateFilters(List<String> jenisLahan, List<int> statusValidasi) {
    setState(() {
      selectedJenisLahan = jenisLahan;
      selectedStatusValidasi = statusValidasi;
    });
  }

  void _updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

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
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  double buttonSize = constraints.maxWidth * 0.09;
                  return Row(
                    children: [
                      Expanded(
                          child: CustomSearchBar(
                        controller: searchController,
                        onSearchChanged: _updateSearchQuery,
                      )),
                      FilterButton(
                        size: buttonSize,
                        onFilterChanged: _updateFilters,
                      ),
                    ],
                  );
                },
              ),
              Expanded(
                  child: ListLahan(
                      selectedJenisLahan: selectedJenisLahan,
                      selectedStatusValidasi: selectedStatusValidasi,
                      searchQuery: searchQuery)),
            ],
          ),
        ),
      ),
    );
  }
}
