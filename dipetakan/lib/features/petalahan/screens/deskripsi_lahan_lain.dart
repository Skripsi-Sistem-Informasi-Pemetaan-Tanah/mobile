import 'package:dipetakan/features/lahansaya/screens/edit_lahan.dart';
import 'package:dipetakan/features/lahansaya/screens/widgets/carousel_slide.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:flutter/material.dart';

class DeskripsiLahanLain extends StatefulWidget {
  const DeskripsiLahanLain({super.key});

  @override
  State<DeskripsiLahanLain> createState() => _DeskripsiLahanLainState();
}

class _DeskripsiLahanLainState extends State<DeskripsiLahanLain> {
  @override
  Widget build(BuildContext context) {
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
            const CarouselSlide(
              photos: [
                'assets/images/farm.jpg',
                'assets/images/farm.jpg',
                'assets/images/farm.jpg'
              ],
            ),

            //Informasi Lahan
            Padding(
              padding: const EdgeInsets.all(DSizes.defaultSpace),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DTexts.namaPemilikLahan,
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: DSizes.xs),
                    Text(DTexts.namaLahan,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: DSizes.md),
                    Text(DTexts.statusverifikasi,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: DSizes.xs),
                    Text(DTexts.jenisLahan,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: DSizes.lg),
                    Text(DTexts.deskripsiLahan,
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
              child: const Text('Beri Komentar')),
        ),
      ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
