import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:flutter/material.dart';

class KebijakanPrivasi extends StatefulWidget {
  const KebijakanPrivasi({super.key});

  @override
  State<KebijakanPrivasi> createState() => _KebijakanPrivasiState();
}

class _KebijakanPrivasiState extends State<KebijakanPrivasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: DColors.primary,
        title: const Text(
          'Kebijakan Privasi',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontStyle: FontStyle.normal),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(DSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kebijakan Privasi',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: DSizes.spaceBtwItems),
              Text(
                '1. Pengumpulan Informasi:',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Kami mengumpulkan informasi pribadi yang Anda berikan saat mendaftar akun, seperti nama, email, nomor telepon, dan informasi lainnya. Selain itu, kami juga mengumpulkan data lokasi dan informasi tentang lahan yang Anda masukkan ke dalam aplikasi.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: DSizes.spaceBtwItems),
              Text(
                '2. Penggunaan Informasi:',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Informasi yang kami kumpulkan digunakan untuk menyediakan, memelihara, dan meningkatkan layanan kami. Kami juga dapat menggunakan data Anda untuk tujuan internal, seperti analisis data, pengujian, penelitian, dan untuk meningkatkan fungsionalitas aplikasi.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: DSizes.spaceBtwItems),
              Text(
                '3. Perlindungan Data:',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Kami berkomitmen untuk melindungi data pribadi Anda. Kami menggunakan berbagai metode keamanan untuk melindungi data Anda dari akses, penggunaan, atau pengungkapan yang tidak sah.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: DSizes.spaceBtwItems),
              Text(
                '4. Pengungkapan Data:',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Kami tidak akan membagikan informasi pribadi Anda kepada pihak ketiga kecuali jika diperlukan untuk mematuhi hukum, peraturan, atau permintaan pemerintah, atau jika Anda memberikan izin.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: DSizes.spaceBtwItems),
              Text(
                '5. Hak Pengguna:',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Anda berhak untuk mengakses, memperbarui, atau menghapus informasi pribadi Anda yang kami miliki. Jika Anda ingin melakukannya, silakan hubungi kami melalui kontak yang tersedia di aplikasi.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: DSizes.spaceBtwItems),
              Text(
                '6. Perubahan Kebijakan Privasi:',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Kami dapat memperbarui Kebijakan Privasi ini dari waktu ke waktu. Setiap perubahan akan diberitahukan melalui aplikasi atau email, dan versi terbaru akan selalu tersedia di dalam aplikasi.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: DSizes.spaceBtwItems),
              Text(
                '7. Kontak:',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Jika Anda memiliki pertanyaan atau masalah mengenai Kebijakan Privasi ini, Anda dapat menghubungi kami melalui aplikasipemetaantanah@gmail.com.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: DSizes.spaceBtwItems),
            ],
          ),
        ),
      ),
    );
  }
}
