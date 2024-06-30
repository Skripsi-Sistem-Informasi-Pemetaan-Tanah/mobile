import 'package:dipetakan/features/lahansaya/controllers/lahansaya_controller.dart';
import 'package:dipetakan/features/lahansaya/screens/deskripsi_lahan.dart';
import 'package:dipetakan/features/tambahlahan/models/lahan_model.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ListLahan extends StatelessWidget {
  final List<String> selectedJenisLahan;
  final List<String> selectedStatusValidasi;
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

    return FutureBuilder<Stream<List<LahanModel>>>(
      future: controller.getLahanStream(),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (futureSnapshot.hasError) {
          return const Center(child: Text('Failed to load lahan records'));
        }

        if (futureSnapshot.hasData) {
          return StreamBuilder<List<LahanModel>>(
            stream: futureSnapshot.data,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(
                    child: Text('Failed to load lahan records'));
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
                    .where((lahan) =>
                        selectedJenisLahan.contains(lahan.jenisLahan))
                    .toList();
              }

              if (selectedStatusValidasi.isNotEmpty) {
                lahanList = lahanList.where((lahan) {
                  if (lahan.verifikasi.isNotEmpty) {
                    return selectedStatusValidasi.contains(
                        lahan.verifikasi.last.statusverifikasi.trim());
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
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: lahanList.length,
                itemBuilder: ((context, index) {
                  final lahan = lahanList[index];
                  String imageUrl = '';

                  for (var patokan in lahan.patokan) {
                    if (patokan.fotoPatokan.isNotEmpty) {
                      imageUrl = patokan.fotoPatokan;
                      break;
                    }
                  }

                  Widget imageWidget;

                  if (imageUrl.isNotEmpty) {
                    imageWidget = ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
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
                  String newestStatusVerifikasi = lahan.verifikasi.isNotEmpty
                      ? lahan.verifikasi.first.statusverifikasi
                      : '-';

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          Text(newestStatusVerifikasi,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium)
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(lahan.jenisLahan,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                    ],
                                  ),
                                ),
                              ),
                              const Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                              builder: (context) =>
                                  DeskripsiLahan(lahan: lahan)));
                    },
                  );
                }),
              );
            },
          );
        }

        return const Center(child: Text('Tidak Ada Lahan'));
      },
    );
  }
}



// import 'package:dipetakan/features/lahansaya/controllers/lahansaya_controller.dart';
// import 'package:dipetakan/features/lahansaya/screens/deskripsi_lahan.dart';
// import 'package:dipetakan/features/tambahlahan/models/lahan_model.dart';
// import 'package:dipetakan/util/constants/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';

// class ListLahan extends StatelessWidget {
//   final List<String> selectedJenisLahan;
//   final List<String> selectedStatusValidasi;
//   final String searchQuery;

//   const ListLahan({
//     super.key,
//     required this.selectedJenisLahan,
//     required this.selectedStatusValidasi,
//     required this.searchQuery,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(LahanSayaController());

//     return StreamBuilder<List<LahanModel>>(
//       stream: controller.lahanStream,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return Center(
//               child: Text('Failed to load lahan records : ${snapshot.error}'));
//         }

//         // final lahanList = snapshot.data;

//         // if (lahanList == null || lahanList.isEmpty) {
//         //   return const Center(child: Text('Tidak Ada Lahan'));
//         // }

//         // // / Sort lahanList by the newest verifiedAt timestamp in verifikasi list
//         // lahanList.sort((a, b) {
//         //   Timestamp? newestVerifiedAtA = a.verifikasi.isNotEmpty
//         //       ? a.verifikasi
//         //           .map((v) => v.verifiedAt)
//         //           .reduce((a, b) => (a.compareTo(b) > 0) ? a : b)
//         //       : null;

//         //   Timestamp? newestVerifiedAtB = b.verifikasi.isNotEmpty
//         //       ? b.verifikasi
//         //           .map((v) => v.verifiedAt)
//         //           .reduce((a, b) => (a.compareTo(b) > 0) ? a : b)
//         //       : null;

//         //   if (newestVerifiedAtA == null && newestVerifiedAtB == null) {
//         //     return 0;
//         //   } else if (newestVerifiedAtA == null) {
//         //     return 1;
//         //   } else if (newestVerifiedAtB == null) {
//         //     return -1;
//         //   } else {
//         //     return newestVerifiedAtB.compareTo(newestVerifiedAtA);
//         //   }
//         // });

//         List<LahanModel> lahanList = snapshot.data ?? [];

//         // Apply search filter
//         if (searchQuery.isNotEmpty) {
//           lahanList = lahanList
//               .where((lahan) => lahan.namaLahan
//                   .toLowerCase()
//                   .contains(searchQuery.toLowerCase()))
//               .toList();
//         }

//         // Apply filters
//         if (selectedJenisLahan.isNotEmpty) {
//           lahanList = lahanList
//               .where((lahan) => selectedJenisLahan.contains(lahan.jenisLahan))
//               .toList();
//         }

//         if (selectedStatusValidasi.isNotEmpty) {
//           lahanList = lahanList.where((lahan) {
//             if (lahan.verifikasi.isNotEmpty) {
//               return selectedStatusValidasi
//                   .contains(lahan.verifikasi.last.statusverifikasi.trim());
//             }
//             return false;
//           }).toList();
//         }

//         // Sort lahanList by updated_at timestamp in descending order
//         lahanList.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

//         if (lahanList.isEmpty) {
//           return const Center(child: Text('Tidak Ada Lahan'));
//         }

//         return ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: lahanList.length,
//           itemBuilder: ((context, index) {
//             final lahan = lahanList[index];
//             String imageUrl = '';

//             for (var patokan in lahan.patokan) {
//               if (patokan.fotoPatokan.isNotEmpty) {
//                 imageUrl = patokan.fotoPatokan;
//                 break;
//               }
//             }

//             Widget imageWidget;

//             if (imageUrl.isNotEmpty) {
//               imageWidget = ClipRRect(
//                 borderRadius: BorderRadius.circular(8.0),
//                 child: Image.network(
//                   imageUrl,
//                   fit: BoxFit.cover,
//                 ),
//               );
//             } else {
//               imageWidget = Container(
//                 alignment: Alignment.center,
//                 decoration: const BoxDecoration(
//                   color: DColors.secondary,
//                   borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                 ),
//                 child: Text('Tidak Ada\nFoto Patokan',
//                     style: Theme.of(context).textTheme.bodySmall,
//                     textAlign: TextAlign.center),
//               );
//             }

//             // Sort the verifikasi list by verifiedAt in descending order
//             lahan.verifikasi
//                 .sort((a, b) => b.verifiedAt.compareTo(a.verifiedAt));

//             // Get the newest statusverifikasi
//             String newestStatusVerifikasi = lahan.verifikasi.isNotEmpty
//                 ? lahan.verifikasi.first.statusverifikasi
//                 : '-';

//             return InkWell(
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 3, left: 8, right: 8),
//                 child: Card(
//                   elevation: 0,
//                   clipBehavior: Clip.antiAlias,
//                   color: Colors.white,
//                   surfaceTintColor: Colors.white,
//                   child: Container(
//                     height: 110,
//                     padding: const EdgeInsets.all(8),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           flex: 6,
//                           child: Container(
//                             decoration: const BoxDecoration(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(8.0)),
//                             ),
//                             child: imageWidget,
//                           ),
//                         ),
//                         const Spacer(flex: 1),
//                         Expanded(
//                           flex: 14,
//                           child: Container(
//                             padding: const EdgeInsets.only(top: 7),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: <Widget>[
//                                 Text(lahan.namaLahan,
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .headlineSmall),
//                                 const SizedBox(height: 2),
//                                 Row(
//                                   children: <Widget>[
//                                     Text('Status : ',
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .bodyMedium),
//                                     Text(newestStatusVerifikasi,
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .bodyMedium)
//                                   ],
//                                 ),
//                                 const SizedBox(height: 2),
//                                 Text(lahan.jenisLahan,
//                                     style:
//                                         Theme.of(context).textTheme.bodySmall),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const Expanded(
//                             flex: 2,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Icon(Iconsax.arrow_right_3),
//                               ],
//                             )),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => DeskripsiLahan(lahan: lahan)));
//               },
//             );
//           }),
//         );
//       },
//     );
//   }
// }
