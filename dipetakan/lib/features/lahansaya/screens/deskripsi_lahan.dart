import 'package:dipetakan/features/lahansaya/controllers/lahansaya_controller.dart';
import 'package:dipetakan/features/lahansaya/screens/edit_lahan.dart';
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
    final controller = Get.put(LahanSayaController());

    // Filter the patokan list to include only those with fotoPatokan
    final List<String> photoUrls = widget.lahan.patokan
        .where((patokan) => patokan.fotoPatokan.isNotEmpty)
        .map((patokan) => patokan.fotoPatokan)
        .toList();

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Foto Lahan & Patokan
            CarouselSlide(
              photos: photoUrls,
            ),

            //Informasi Lahan
            Padding(
              padding: const EdgeInsets.all(DSizes.defaultSpace),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.user.value.fullName,
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: DSizes.xs),
                    Text(widget.lahan.namaLahan,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: DSizes.md),
                    Text(widget.lahan.statusverifikasi,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: DSizes.xs),
                    Text(widget.lahan.jenisLahan,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: DSizes.lg),
                    Text(widget.lahan.deskripsiLahan,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            )

            //Nama Pemilik Lahan

            //Nama Lahan

            //
          ],
        ),
      ),

      floatingActionButton:
          // Container(
          //   child:
          Padding(
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
                  MaterialPageRoute(builder: (context) => const EditLahan()),
                );
              },
              child: const Text('Edit')),
        ),
      ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
