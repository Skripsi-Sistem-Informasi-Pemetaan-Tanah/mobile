import 'package:dipetakan/features/lahansaya/controllers/lahansaya_controller.dart';
import 'package:dipetakan/features/lahansaya/screens/deskripsi_lahan.dart';
import 'package:dipetakan/features/tambahlahan/models/lahan_model.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ListLahan extends StatelessWidget {
  final List<String> selectedJenisLahan;
  final List<int> selectedStatusValidasi;
  final String searchQuery;

  const ListLahan({
    super.key,
    required this.selectedJenisLahan,
    required this.selectedStatusValidasi,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LahanSayaController());

    return FutureBuilder<List<LahanModel>>(
      future: controller.fetchDataFromPostgresql(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.green));
        }

        if (snapshot.hasError) {
          return Center(
              child: Text('Gagal mendapatkan data lahan : ${snapshot.error}'));
        }

        List<LahanModel> lahanList = snapshot.data ?? [];

        // Apply search filter
        if (searchQuery.isNotEmpty) {
          lahanList = lahanList
              .where((lahan) => lahan.namaLahan
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
              .toList();
        }

        // Apply filters
        if (selectedJenisLahan.isNotEmpty) {
          lahanList = lahanList
              .where((lahan) => selectedJenisLahan.contains(lahan.jenisLahan))
              .toList();
        }

        if (selectedStatusValidasi.isNotEmpty) {
          lahanList = lahanList.where((lahan) {
            if (lahan.verifikasi.isNotEmpty) {
              return selectedStatusValidasi
                  .contains(lahan.verifikasi.last.statusverifikasi);
            }
            return false;
          }).toList();
        }

        // Sort lahanList by updated_at timestamp in descending order
        lahanList.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

        if (lahanList.isEmpty) {
          return const Center(child: Text('Tidak Ada Lahan'));
        }

        return ListView.builder(
          itemCount: lahanList.length,
          itemBuilder: ((context, index) {
            final lahan = lahanList[index];
            // Check image URL extraction
            for (var lahan in lahanList) {
              if (kDebugMode) {
                print(
                    'lahan ID: ${lahan.id}, fotoPatokan: ${lahan.patokan.first.fotoPatokan}');
              }
            }
            String imageUrl =
                lahan.patokan.isNotEmpty ? lahan.patokan[0].fotoPatokan : '';

            Widget imageWidget;
            if (imageUrl.isNotEmpty) {
              imageWidget = ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: DColors.secondary,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Text('Tidak Ada\nFoto Patokan',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center),
                    );
                  },
                ),
              );
            } else {
              imageWidget = Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: DColors.secondary,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Text('Tidak Ada\nFoto Patokan',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center),
              );
            }

            // Sort the verifikasi list by verifiedAt in descending order
            lahan.verifikasi
                .sort((a, b) => b.verifiedAt.compareTo(a.verifiedAt));

            // Get the newest statusverifikasi
            int newestStatusVerifikasi = lahan.verifikasi.isNotEmpty
                ? lahan.verifikasi.first.statusverifikasi
                : 3;

            String statusVerifikasiText;
            switch (newestStatusVerifikasi) {
              case 0:
                statusVerifikasiText = 'Belum tervalidasi';
                break;
              case 1:
                statusVerifikasiText = 'Dalam progress';
                break;
              case 2:
                statusVerifikasiText = 'Sudah tervalidasi';
                break;
              case 3:
                statusVerifikasiText = 'Ditolak';
                break;
              default:
                statusVerifikasiText = 'Tidak ada status';
            }

            return InkWell(
              child: Padding(
                padding: const EdgeInsets.only(top: 3, left: 8, right: 8),
                child: Card(
                  elevation: 0,
                  clipBehavior: Clip.antiAlias,
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  child: Container(
                    height: 110,
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            child: imageWidget,
                          ),
                        ),
                        const Spacer(flex: 1),
                        Expanded(
                          flex: 14,
                          child: Container(
                            padding: const EdgeInsets.only(top: 7),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(lahan.namaLahan,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall),
                                const SizedBox(height: 2),
                                Row(
                                  children: <Widget>[
                                    Text('Status : ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    Text(statusVerifikasiText,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium)
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(lahan.jenisLahan,
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                        ),
                        const Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Iconsax.arrow_right_3),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeskripsiLahan(lahan: lahan)));
              },
            );
          }),
        );
      },
    );
  }
}
