import 'package:dipetakan/features/petalahan/screens/deskripsi_lahan_lain.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:flutter/material.dart';

class InfoLahanBottomSheet extends StatelessWidget {
  const InfoLahanBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          //Informasi Lahan
          Padding(
            padding:
                const EdgeInsets.only(bottom: 10.0, left: 24.0, right: 24.0),
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
                  const SizedBox(height: DSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const DeskripsiLahanLain()),
                          );
                        },
                        child: const Text('Lihat Detail')),
                  ),
                ],
              ),
            ),
          )

          //Nama Pemilik Lahan

          //Nama Lahan

          //
        ],
      ),
    );
  }
}
