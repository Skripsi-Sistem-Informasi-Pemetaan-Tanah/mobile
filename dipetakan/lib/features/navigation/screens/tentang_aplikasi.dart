import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:flutter/material.dart';

class TentangAplikasiScreen extends StatefulWidget {
  const TentangAplikasiScreen({super.key});

  @override
  State<TentangAplikasiScreen> createState() => _TentangAplikasiScreenState();
}

class _TentangAplikasiScreenState extends State<TentangAplikasiScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: DColors.primary,
        title: const Text(
          'Tentang Aplikasi',
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
                'Tentang Aplikasi DIPETAKAN',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: DSizes.spaceBtwItems),
              Text(
                'Selamat datang di DIPETAKAN, aplikasi inovatif yang dirancang untuk memudahkan Anda dalam mengelola dan memverifikasi lahan dengan berbagai fitur yang lengkap. DIPETAKAN memungkinkan pengguna untuk melakukan pendaftaran akun, login, dan menyimpan data pribadi dengan aman.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: DSizes.spaceBtwItems),
              Text(
                'Fitur utama dari DIPETAKAN meliputi:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Pendaftaran dan Login',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Aplikasi ini memungkinkan pengguna untuk mendaftar akun baru dengan mudah, serta login dengan mengingat data akun untuk kenyamanan akses di masa mendatang.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Manajemen Profil',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Pengguna dapat mengubah data profil seperti nama lengkap, username, email, nomor telepon, dan kata sandi langsung melalui aplikasi.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Pengelolaan Lahan',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Pengguna dapat menambah, melihat, dan mengelola lahan milik mereka sendiri, lengkap dengan informasi detail seperti nama lahan, jenis lahan, deskripsi, titik koordinat, dan foto patok batas lahan.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Validasi Koordinat Lahan',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'DIPETAKAN memfasilitasi proses validasi titik koordinat lahan, dimana pengguna dapat menyetujui atau tidak menyetujui koordinat yang diberikan oleh validator. Sistem ini juga memungkinkan revisi foto patokan apabila diperlukan.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Peta Lahan',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Aplikasi menampilkan peta yang memperlihatkan semua lahan baik milik pribadi maupun pengguna lain dalam bentuk polygon. Pengguna juga dapat menerapkan filter berdasarkan jenis lahan dan status verifikasi.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Informasi Aplikasi',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Aplikasi ini juga menyertakan halaman yang memberikan informasi tentang aplikasi dan tim yang mengembangkannya.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Panduan Penggunaan',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: DSizes.sm),
              Text(
                'Untuk memudahkan pengguna dalam memahami dan menggunakan aplikasi, DIPETAKAN menyediakan panduan penggunaan yang dapat diakses dengan mudah.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
