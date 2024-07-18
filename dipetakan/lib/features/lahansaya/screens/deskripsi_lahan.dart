// import 'package:dipetakan/data/repositories/authentication/authentication_repository.dart';
// import 'package:dipetakan/features/authentication/models/user_model.dart';
// import 'package:dipetakan/features/lahansaya/screens/edit_lahan.dart';
// import 'package:dipetakan/features/lahansaya/screens/lacak_status.dart';
// import 'package:dipetakan/features/petalahan/controllers/infolahan_controller.dart'; // Import InfoLahanController
// import 'package:dipetakan/features/lahansaya/screens/widgets/carousel_slide.dart';
// import 'package:dipetakan/features/tambahlahan/models/lahan_model.dart';
// import 'package:dipetakan/util/constants/colors.dart';
// import 'package:dipetakan/util/constants/sizes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class DeskripsiLahan extends StatefulWidget {
//   final LahanModel lahan;

//   const DeskripsiLahan({super.key, required this.lahan});

//   @override
//   State<DeskripsiLahan> createState() => _DeskripsiLahanState();
// }

// class _DeskripsiLahanState extends State<DeskripsiLahan> {
//   final controller = Get.put(InfoLahanController());
//   final authRepository = Get.find<AuthenticationRepository>();

//   @override
//   Widget build(BuildContext context) {
//     final String currentUserId = authRepository.authUser?.uid ?? '';
//     int newestProgressVerifikasi = widget.lahan.verifikasi.first.progress;

//     Widget buildCarousel(List<String> photoUrls) {
//       if (photoUrls.isNotEmpty) {
//         return CarouselSlide(photos: photoUrls);
//       } else {
//         return Container(
//           height: 200,
//           color: DColors.secondary,
//           child: const Center(
//             child: Text(
//               'Tidak Ada Foto Patokan',
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         );
//       }
//     }

//     return Scaffold(
//       backgroundColor: DColors.white,
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         backgroundColor: DColors.primary,
//         title: const Text(
//           'Informasi Lahan',
//           style: TextStyle(
//               color: Colors.white,
//               fontFamily: 'Inter',
//               fontStyle: FontStyle.normal),
//         ),
//       ),
//       body: Obx(() {
//         if (controller.profileLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (controller.lahanList.isEmpty) {
//           return const Center(child: Text('No data available'));
//         }

//         final lahan = controller.lahanList.firstWhere(
//           (element) => element.id == widget.lahan.id,
//           orElse: () => widget.lahan,
//         );

//                 // Find the user who owns this lahan
//         final user = controller.userList.firstWhere(
//             (user) => user.id == lahan.userId,
//             orElse: () => UserModel.empty());

//         // Filter the patokan list to include only those with fotoPatokan
//         final List<String> photoUrls = lahan.patokan
//             .where((patokan) => patokan.fotoPatokan.isNotEmpty)
//             .map((patokan) => patokan.fotoPatokan)
//             .toList();

//         // Sort the verifikasi list by verifiedAt in descending order
//         lahan.verifikasi.sort((a, b) => b.verifiedAt.compareTo(a.verifiedAt));

//         // Get the newest statusverifikasi
//         int newestStatusVerifikasi = lahan.verifikasi.isNotEmpty
//             ? lahan.verifikasi.first.statusverifikasi
//             : 3;

//         String statusVerifikasiText;
//         switch (newestStatusVerifikasi) {
//           case 0:
//             statusVerifikasiText = 'Belum tervalidasi';
//             break;
//           case 1:
//             statusVerifikasiText = 'Dalam progress';
//             break;
//           case 2:
//             statusVerifikasiText = 'Sudah tervalidasi';
//             break;
//           case 3:
//             statusVerifikasiText = 'Tidak ada status';
//             break;
//           default:
//             statusVerifikasiText = 'Tidak ada status';
//         }

//         return SingleChildScrollView(
//           child: Column(
//             children: [
//               // Foto Lahan & Patokan
//               buildCarousel(photoUrls),

//               // Informasi Lahan
//               Padding(
//                 padding: const EdgeInsets.all(DSizes.defaultSpace),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(user.fullName,
//                           style: Theme.of(context).textTheme.bodyLarge),
//                       const SizedBox(height: DSizes.xs),
//                       Text(lahan.namaLahan,
//                           style: Theme.of(context).textTheme.headlineMedium),
//                       const SizedBox(height: DSizes.md),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('Status: $statusVerifikasiText',
//                               style: Theme.of(context).textTheme.bodyMedium),
//                           Visibility(
//                             visible: currentUserId == widget.lahan.userId,
//                             child: TextButton(
//                               onPressed: () => Get.off(
//                                   () => LacakStatusScreen(lahan: widget.lahan)),
//                               child: Text(
//                                 'Lacak Status',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyMedium
//                                     ?.copyWith(color: DColors.primary),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Text(lahan.jenisLahan,
//                           style: Theme.of(context).textTheme.bodyMedium),
//                       const SizedBox(height: DSizes.lg),
//                       Text(lahan.deskripsiLahan,
//                           style: Theme.of(context).textTheme.bodyMedium),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         );
//       }),
//       floatingActionButton:
//           newestProgressVerifikasi == 20 && currentUserId == widget.lahan.userId
//               ? Padding(
//                   padding: const EdgeInsets.only(
//                     left: DSizes.defaultSpace,
//                     right: DSizes.defaultSpace,
//                     bottom: DSizes.defaultSpace,
//                   ),
//                   child: SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     EditLahan(lahan: widget.lahan)),
//                           );
//                         },
//                         child: const Text('Edit')),
//                   ),
//                 )
//               : null,
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }
// }

import 'package:dipetakan/data/repositories/authentication/authentication_repository.dart';
// import 'package:dipetakan/features/authentication/models/user_model.dart';
import 'package:dipetakan/features/lahansaya/screens/edit_lahan.dart';
import 'package:dipetakan/features/lahansaya/screens/lacak_status.dart';
import 'package:dipetakan/features/petalahan/controllers/infolahan_controller.dart';
// import 'package:dipetakan/features/lahansaya/screens/edit_lahan.dart';
import 'package:dipetakan/features/lahansaya/screens/widgets/carousel_slide.dart';
import 'package:dipetakan/features/tambahlahan/models/lahan_model.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeskripsiLahan extends StatefulWidget {
  final LahanModel lahan;

  const DeskripsiLahan({super.key, required this.lahan});

  @override
  State<DeskripsiLahan> createState() => _DeskripsiLahanState();
}

class _DeskripsiLahanState extends State<DeskripsiLahan> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InfoLahanController());
    // Get the newest progressVerifikasi
    int newestProgressVerifikasi = widget.lahan.verifikasi.isNotEmpty
        ? widget.lahan.verifikasi.first.progress
        : 0;
    final authRepository = Get.find<AuthenticationRepository>();
    final String currentUserId = authRepository.authUser?.uid ?? '';

    // Foto Lahan & Patokan
    Widget buildCarousel(List<String> photoUrls) {
      if (photoUrls.isNotEmpty) {
        return CarouselSlide(photos: photoUrls);
      } else {
        return Container(
          height: 200,
          color: DColors.secondary,
          child: const Center(
            child: Text(
              'Tidak Ada Foto Patokan',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: DColors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: DColors.primary,
        title: const Text(
          'Informasi Lahan',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontStyle: FontStyle.normal),
        ),
      ),
      body: StreamBuilder<List<LahanModel>>(
        stream: controller.lahanStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load lahan data'));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          }

          final lahanList = snapshot.data!;
          final lahan = lahanList.firstWhere(
            (element) => element.id == widget.lahan.id,
            orElse: () => widget.lahan,
          );

          // Filter the patokan list to include only those with fotoPatokan
          final List<String> photoUrls = lahan.patokan
              .where((patokan) => patokan.fotoPatokan.isNotEmpty)
              .map((patokan) => patokan.fotoPatokan)
              .toList();

          // Sort the verifikasi list by verifiedAt in descending order
          lahan.verifikasi.sort((a, b) => b.verifiedAt.compareTo(a.verifiedAt));

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
              statusVerifikasiText = 'Tidak ada status';
              break;
            default:
              statusVerifikasiText = 'Tidak ada status';
          }

          // Find the user who owns this lahan
          // final user = controller.userList.firstWhere(
          //     (user) => user.id == lahan.userId,
          //     orElse: () => UserModel.empty());

          return SingleChildScrollView(
            child: Column(
              children: [
                // Foto Lahan & Patokan
                buildCarousel(photoUrls),

                // Informasi Lahan
                Padding(
                  padding: const EdgeInsets.all(DSizes.defaultSpace),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lahan.namaPemilik,
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: DSizes.xs),
                        Text(lahan.namaLahan,
                            style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: DSizes.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Status: $statusVerifikasiText',
                                style: Theme.of(context).textTheme.bodyMedium),
                            Visibility(
                              visible: Get.find<AuthenticationRepository>()
                                      .authUser
                                      ?.uid ==
                                  widget.lahan.userId,
                              child: TextButton(
                                onPressed: () => Get.off(() =>
                                    LacakStatusScreen(lahan: widget.lahan)),
                                child: Text(
                                  'Lacak Status',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: DColors.primary),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(height: DSizes.xs),
                        Text(lahan.jenisLahan,
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: DSizes.lg),
                        Text(lahan.deskripsiLahan,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton:
          newestProgressVerifikasi == 20 && currentUserId == widget.lahan.userId
              ? Padding(
                  padding: const EdgeInsets.only(
                    left: DSizes.defaultSpace,
                    right: DSizes.defaultSpace,
                    bottom: DSizes.defaultSpace,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditLahan(lahan: widget.lahan)),
                          );
                        },
                        child: const Text('Edit')),
                  ),
                )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
