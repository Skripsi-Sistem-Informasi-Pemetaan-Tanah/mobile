import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:flutter/material.dart';

class KetentuanPenggunaan extends StatefulWidget {
  const KetentuanPenggunaan({super.key});

  @override
  State<KetentuanPenggunaan> createState() => _KetentuanPenggunaanState();
}

class _KetentuanPenggunaanState extends State<KetentuanPenggunaan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: DColors.primary,
        title: const Text(
          'Ketentuan Penggunaan',
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
                'Ketentuan Penggunaan',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: DSizes.spaceBtwItems),
              Text(
                '1. Penerimaan Ketentuan:',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Dengan mengakses dan menggunakan aplikasi ini, Anda setuju untuk mematuhi dan terikat oleh Ketentuan Penggunaan ini. Jika Anda tidak setuju dengan ketentuan ini, Anda tidak diperkenankan untuk menggunakan aplikasi ini.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: DSizes.spaceBtwItems),
              Text(
                '2. Kelayakan Pengguna:',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Pengguna aplikasi ini harus berusia minimal 18 tahun atau lebih, atau telah mendapatkan izin dari orang tua atau wali jika di bawah usia tersebut.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: DSizes.spaceBtwItems),
              Text(
                '3. Akun Pengguna:',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Anda bertanggung jawab untuk menjaga kerahasiaan informasi akun Anda, termasuk kata sandi, dan Anda bertanggung jawab penuh atas semua aktivitas yang terjadi di bawah akun Anda.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: DSizes.spaceBtwItems),
              Text(
                '4. Penggunaan yang Diperbolehkan:',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Anda setuju untuk menggunakan aplikasi ini hanya untuk tujuan yang sah dan sesuai dengan Ketentuan Penggunaan ini. Anda dilarang menggunakan aplikasi ini untuk melakukan tindakan yang melanggar hukum atau merugikan pihak lain.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: DSizes.spaceBtwItems),
              Text(
                '5. Ketersediaan Layanan:',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Kami berhak untuk menghentikan atau membatasi akses Anda ke aplikasi ini kapan saja, tanpa pemberitahuan sebelumnya, jika kami yakin Anda melanggar ketentuan ini.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: DSizes.spaceBtwItems),
              Text(
                '6. Batasan Tanggung Jawab:',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Aplikasi ini disediakan "sebagaimana adanya" dan "sebagaimana tersedia". Kami tidak memberikan jaminan apapun terkait dengan aplikasi ini, dan kami tidak bertanggung jawab atas kerugian atau kerusakan apapun yang timbul dari penggunaan aplikasi ini.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: DSizes.spaceBtwItems),
              Text(
                '7. Pembaruan dan Perubahan:',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Kami dapat memperbarui atau mengubah Ketentuan Penggunaan ini dari waktu ke waktu. Setiap perubahan akan diberitahukan melalui aplikasi atau email, dan versi terbaru akan selalu tersedia di dalam aplikasi.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: DSizes.spaceBtwItems),
              Text(
                '8. Hukum yang Berlaku:',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Ketentuan Penggunaan ini diatur oleh dan ditafsirkan sesuai dengan hukum yang berlaku di Indonesia. Setiap sengketa yang timbul dari atau terkait dengan Ketentuan Penggunaan ini akan diselesaikan melalui pengadilan di Indonesia.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: DSizes.spaceBtwItems),
              Text(
                '9. Kontak:',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Jika Anda memiliki pertanyaan tentang Ketentuan Penggunaan ini, Anda dapat menghubungi kami melalui aplikasipemetaantanah@gmail.com',
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
