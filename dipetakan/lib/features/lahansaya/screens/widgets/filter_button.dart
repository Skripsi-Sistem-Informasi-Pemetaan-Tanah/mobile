import 'package:dipetakan/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:dipetakan/features/tambahlahan/data/jenislahanlist.dart';

class FilterButton extends StatefulWidget {
  final double size;
  final Function(List<String>, List<int>) onFilterChanged;

  const FilterButton({
    super.key,
    required this.size,
    required this.onFilterChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FilterButtonState createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  List<String> selectedJenisLahan = [];
  List<int> selectedStatusValidasi = [];

  final Map<int, String> statusValidasiMap = {
    0: 'Belum Tervalidasi',
    1: 'Dalam Progress',
    2: 'Sudah Tervalidasi',
    3: 'Ditolak'
  };

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 5, right: 12, left: 10),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: const Icon(Icons.filter_list, color: Colors.grey),
        ),
      ),
      onTap: () {
        _showFilterDialog(context);
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              title: Text('Opsi Filter',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('Jenis Lahan',
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: jenisLahanList.map((jenisLahan) {
                        return FilterChip(
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          label: Text(
                            jenisLahan.jenisLahan,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: selectedJenisLahan
                                              .contains(jenisLahan.jenisLahan)
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                          ),
                          selected: selectedJenisLahan
                              .contains(jenisLahan.jenisLahan),
                          selectedColor: Colors.green,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                selectedJenisLahan.add(jenisLahan.jenisLahan);
                              } else {
                                selectedJenisLahan
                                    .remove(jenisLahan.jenisLahan);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    Text('Status Validasi',
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: statusValidasiMap.entries.map((entry) {
                        return FilterChip(
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          label: Text(
                            entry.value,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color:
                                      selectedStatusValidasi.contains(entry.key)
                                          ? Colors.white
                                          : Colors.black,
                                ),
                          ),
                          selected: selectedStatusValidasi.contains(entry.key),
                          selectedColor: Colors.green,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                selectedStatusValidasi.add(entry.key);
                              } else {
                                selectedStatusValidasi.remove(entry.key);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                SizedBox(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        selectedJenisLahan.clear();
                        selectedStatusValidasi.clear();
                      });
                    },
                    child: Text('Hapus Semua',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.green)),
                  ),
                ),
                SizedBox(
                  width: DSizes.buttonWidth,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onFilterChanged(
                          selectedJenisLahan, selectedStatusValidasi);
                      Navigator.of(context).pop();
                    },
                    child: Text('Terapkan',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
