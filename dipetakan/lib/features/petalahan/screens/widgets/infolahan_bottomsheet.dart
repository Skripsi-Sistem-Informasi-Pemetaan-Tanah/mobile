import 'package:dipetakan/features/lahansaya/screens/deskripsi_lahan.dart';
import 'package:dipetakan/features/tambahlahan/models/lahan_model.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:flutter/material.dart';

class InfoLahanBottomSheet extends StatefulWidget {
  final LahanModel lahan;
  const InfoLahanBottomSheet({super.key, required this.lahan});

  @override
  State<InfoLahanBottomSheet> createState() => _InfoLahanBottomSheetState();
}

class _InfoLahanBottomSheetState extends State<InfoLahanBottomSheet> {
  @override
  Widget build(BuildContext context) {

    widget.lahan.verifikasi
        .sort((a, b) => b.verifiedAt.compareTo(a.verifiedAt));

    int newestStatusVerifikasi = widget.lahan.verifikasi.isNotEmpty
        ? widget.lahan.verifikasi.first.statusverifikasi
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


    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Informasi Lahan
          Padding(
            padding:
                const EdgeInsets.only(bottom: 10.0, left: 24.0, right: 24.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.lahan.namaPemilik,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: DSizes.xs),
                  Text(widget.lahan.namaLahan,
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: DSizes.xs),
                  Text('Status Verifikasi : $statusVerifikasiText',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: DSizes.xs),
                  Text(widget.lahan.jenisLahan,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: DSizes.spaceBtwInputFields),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DeskripsiLahan(lahan: widget.lahan)),
                          );
                        },
                        child: const Text('Lihat Detail')),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
