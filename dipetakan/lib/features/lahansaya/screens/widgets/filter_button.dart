import 'package:flutter/material.dart';
import 'package:dipetakan/features/tambahlahan/data/jenislahanlist.dart';

class FilterButton extends StatefulWidget {
  final double size;
  final Function(List<String>, List<String>) onFilterChanged;

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
  List<String> selectedStatusValidasi = [];

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
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
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
                    // ...jenisLahanList.map((jenisLahan) {
                    //   return
                    //   Padding(
                    //     padding: const EdgeInsets.all(0),
                    //     child: CheckboxListTile(
                    //       contentPadding: EdgeInsets.zero,
                    //       controlAffinity: ListTileControlAffinity.leading,
                    //       title: Text(jenisLahan.jenisLahan,
                    //           style: Theme.of(context).textTheme.bodySmall),
                    //       value: selectedJenisLahan
                    //           .contains(jenisLahan.jenisLahan),
                    //       onChanged: (bool? value) {
                    //         setState(() {
                    //           if (value == true) {
                    //             selectedJenisLahan.add(jenisLahan.jenisLahan);
                    //           } else {
                    //             selectedJenisLahan
                    //                 .remove(jenisLahan.jenisLahan);
                    //           }
                    //         });
                    //       },
                    //     ),
                    //   );
                    // }),
                    const SizedBox(height: 12),
                    Text('Status Validasi',
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: [
                        FilterChip(
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          label: Text(
                            'Sudah Tervalidasi',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: selectedStatusValidasi
                                          .contains('sudah tervalidasi')
                                      ? Colors.white
                                      : Colors.black,
                                ),
                          ),
                          selected: selectedStatusValidasi
                              .contains('sudah tervalidasi'),
                          selectedColor: Colors.green,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                selectedStatusValidasi.add('sudah tervalidasi');
                              } else {
                                selectedStatusValidasi
                                    .remove('sudah tervalidasi');
                              }
                            });
                          },
                        ),
                        FilterChip(
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          label: Text(
                            'Belum Tervalidasi',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: selectedStatusValidasi
                                          .contains('belum tervalidasi')
                                      ? Colors.white
                                      : Colors.black,
                                ),
                          ),
                          selected: selectedStatusValidasi
                              .contains('belum tervalidasi'),
                          selectedColor: Colors.green,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                selectedStatusValidasi.add('belum tervalidasi');
                              } else {
                                selectedStatusValidasi
                                    .remove('belum tervalidasi');
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    // CheckboxListTile(
                    //   contentPadding: EdgeInsets.zero,
                    //   controlAffinity: ListTileControlAffinity.leading,
                    //   title: const Text('Sudah Tervalidasi'),
                    //   value:
                    //       selectedStatusValidasi.contains('sudah tervalidasi'),
                    //   onChanged: (bool? value) {
                    //     setState(() {
                    //       if (value == true) {
                    //         selectedStatusValidasi.add('sudah tervalidasi');
                    //       } else {
                    //         selectedStatusValidasi.remove('sudah tervalidasi');
                    //       }
                    //     });
                    //   },
                    // ),
                    // CheckboxListTile(
                    //   title: const Text('Belum Tervalidasi'),
                    //   value:
                    //       selectedStatusValidasi.contains('belum tervalidasi'),
                    //   onChanged: (bool? value) {
                    //     setState(() {
                    //       if (value == true) {
                    //         selectedStatusValidasi.add('belum tervalidasi');
                    //       } else {
                    //         selectedStatusValidasi.remove('belum tervalidasi');
                    //       }
                    //     });
                    //   },
                    // ),
                  ],
                ),
              ),
              actions: [
                // TextButton(
                //   child: const Text('Cancel',
                //       style: TextStyle(color: Colors.black)),
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                // ),
                SizedBox(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        selectedJenisLahan.clear();
                        selectedStatusValidasi.clear();
                      });
                    },
                    child: Text('Hapus Semua',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.green)),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onFilterChanged(
                          selectedJenisLahan, selectedStatusValidasi);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Terapkan'),
                  ),
                ),
                // TextButton(
                //   child: const Text('Apply',
                //       style: TextStyle(color: Colors.green)),
                //   onPressed: () {
                //     widget.onFilterChanged(
                //         selectedJenisLahan, selectedStatusValidasi);
                //     Navigator.of(context).pop();
                //   },
                // ),
              ],
            );
          },
        );
      },
    );
  }
}
