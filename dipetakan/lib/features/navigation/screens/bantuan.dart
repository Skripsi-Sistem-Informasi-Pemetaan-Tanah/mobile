import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:flutter/material.dart';

class BantuanScreen extends StatefulWidget {
  const BantuanScreen({super.key});

  @override
  State<BantuanScreen> createState() => _BantuanScreenState();
}

class _BantuanScreenState extends State<BantuanScreen> {
  final List<Map<String, dynamic>> faqs = [
    {
      'question': 'Bagaimana cara membuat akun di aplikasi ini?',
      'answer': [
        '1. Buka aplikasi dan akan muncul splashscreen, kemudian halaman login.',
        '2. Klik tombol “Buat Akun” di halaman login.',
        '3. Isi form pendaftaran di halaman signup, centang persetujuan kebijakan privasi dan ketentuan penggunaan, lalu klik tombol “Buat Akun”.',
        '4. Aplikasi akan menampilkan halaman verifikasi email dengan pesan “Selamat! Akun anda sudah berhasil dibuat, silahkan verifikasi email Anda untuk melanjutkan.”',
      ],
    },
    {
      'question': 'Bagaimana cara login ke dalam aplikasi?',
      'answer': [
        '1. Masukkan email dan kata sandi di halaman login.',
        '2. Centang opsi “Ingat Saya” jika ingin menyimpan data login di perangkat.',
        '3. Klik tombol “Masuk”.',
        '4. Setelah login, Anda akan diarahkan ke halaman Menu dengan nama lengkap Anda di bagian atas.',
      ],
    },
    {
      'question': 'Bagaimana cara memverifikasi email yang telah didaftarkan?',
      'answer': [
        '1. Cek kotak masuk email Anda setelah mendaftar.',
        '2. Klik link verifikasi yang dikirimkan melalui email.',
        '3. Jika email belum diverifikasi setelah 120 detik, aplikasi akan mengarahkan Anda kembali ke halaman login. Jika diverifikasi dalam 120 detik, aplikasi akan menampilkan pesan bahwa akun berhasil dibuat.',
      ],
    },
    {
      'question': 'Bagaimana cara mengubah kata sandi akun?',
      'answer': [
        '1. Di halaman Menu, klik navigation bottom “Akun Saya”.',
        '2. Pilih menu “Ubah Kata Sandi”.',
        '3. Masukkan kata sandi lama dan kata sandi baru Anda, lalu klik “Ubah”.',
      ],
    },
    {
      'question': 'Bagaimana cara mengubah nama lengkap akun?',
      'answer': [
        '1. Di halaman “Akun Saya”, pilih menu “Profil Saya”.',
        '2. Klik ikon edit di sebelah informasi nama lengkap.',
        '3. Masukkan nama lengkap baru dan klik tombol “Ubah”.',
      ],
    },
    {
      'question': 'Bagaimana cara mengubah username?',
      'answer': [
        '1. Di halaman “Profil Saya”, klik ikon edit di sebelah informasi username.',
        '2. Masukkan username baru dan klik tombol “Ubah”.',
      ],
    },
    {
      'question': 'Bagaimana cara mengubah nomor telepon akun?',
      'answer': [
        '1. Di halaman “Profil Saya”, klik ikon edit di sebelah informasi nomor telepon.',
        '2. Masukkan nomor telepon baru dan klik tombol “Ubah”.',
      ],
    },
    {
      'question': 'Bagaimana cara mengubah email akun?',
      'answer': [
        '1. Di halaman “Profil Saya”, klik ikon edit di sebelah informasi email.',
        '2. Masukkan kata sandi dan email baru, lalu klik “Lanjutkan”.',
        '3. Verifikasi email baru yang dikirimkan ke email baru Anda.',
      ],
    },
    {
      'question': 'Bagaimana cara menghapus akun?',
      'answer': [
        '1. Di halaman “Profil Saya”, klik “Hapus Akun”.',
        '2. Pada dialog konfirmasi, klik “Hapus”.',
        '3. Akun Anda akan dihapus, dan Anda akan diarahkan ke halaman login.',
      ],
    },
    {
      'question': 'Bagaimana cara menambah atau mengubah foto profil?',
      'answer': [
        '1. Di halaman “Profil Saya”, klik “Ubah Foto Profil”.',
        '2. Pilih foto dari galeri atau file, dan foto tersebut akan ditampilkan sebagai foto profil.',
      ],
    },
    {
      'question': 'Bagaimana cara menambah lahan dan informasi terkait lahan?',
      'answer': [
        '1. Di halaman Menu, pilih halaman “Plot Lahan”.',
        '2. Isi informasi lahan dan foto patok batas lahan, kemudian klik “Kirim”.',
      ],
    },
    {
      'question': 'Bagaimana cara melihat semua lahan yang dimiliki?',
      'answer': [
        '1. Di halaman Menu, pilih halaman “Lahan Saya”.',
        '2. Semua lahan yang Anda miliki akan ditampilkan di halaman ini.',
      ],
    },
    {
      'question': 'Bagaimana cara melacak status verifikasi lahan?',
      'answer': [
        '1. Di halaman “Lahan Saya”, klik tombol “Lacak Status”.',
        '2. Status verifikasi lahan akan ditampilkan di halaman ini.',
      ],
    },
    {
      'question': 'Bagaimana cara mencari nama lahan?',
      'answer': [
        '1. Di halaman “Lahan Saya”, gunakan search bar untuk mencari nama lahan.',
        '2. Lahan yang Anda cari akan ditampilkan berdasarkan kata kunci yang dimasukkan.',
      ],
    },
    {
      'question': 'Bagaimana cara menerapkan filter pada lahan yang dimiliki?',
      'answer': [
        '1. Di halaman “Lahan Saya”, klik ikon filter.',
        '2. Pilih jenis lahan atau status verifikasi yang ingin difilter, lalu klik “Terapkan”.',
      ],
    },
    {
      'question':
          'Bagaimana cara menambahkan atau merevisi foto patokan lahan?',
      'answer': [
        '1. Di halaman “Lacak Status”, klik “Revisi Foto Patokan”.',
        '2. Pilih marker titik koordinat di peta dan ambil foto baru untuk revisi.',
      ],
    },
    {
      'question': 'Bagaimana cara memvalidasi titik koordinat lahan?',
      'answer': [
        '1. Di halaman “Lacak Status”, klik “Validasi Titik Koordinat”.',
        '2. Setujui atau tidak setujui titik koordinat yang diberikan, dan simpan perubahan.',
      ],
    },
    {
      'question': 'Bagaimana cara menampilkan peta lahan yang dimiliki?',
      'answer': [
        '1. Di halaman Menu, pilih menu “Peta Lahan”.',
        '2. Lahan yang Anda miliki akan ditampilkan sebagai polygon di peta.',
      ],
    },
    {
      'question':
          'Bagaimana cara menampilkan informasi lahan milik pengguna lain?',
      'answer': [
        '1. Di halaman “Peta Lahan”, klik polygon lahan milik pengguna lain.',
        '2. Informasi lahan akan ditampilkan dalam bottomsheet, klik “Lihat Detail” untuk informasi lebih lanjut.',
      ],
    },
    {
      'question': 'Bagaimana cara melihat panduan penggunaan aplikasi?',
      'answer': [
        '1. Di halaman Menu, pilih menu “Bantuan”.',
        '2. Aplikasi akan menampilkan halaman panduan penggunaan.',
      ],
    },
    {
      'question': 'Bagaimana cara melihat informasi tentang aplikasi ini?',
      'answer': [
        '1. Di halaman “Akun Saya”, pilih menu “Tentang Aplikasi”.',
        '2. Informasi tentang aplikasi akan ditampilkan di halaman ini.',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: DColors.primary,
        title: const Text(
          'Bantuan',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(DSizes.defaultSpace),
          child: Column(
            children: faqs.map((faq) {
              return ExpansionTile(
                title: Text(faq['question']!,
                    style: Theme.of(context).textTheme.headlineSmall),
                children: (faq['answer']! as List<String>).map((answer) {
                  return ListTile(
                    title: Text(answer,
                        style: Theme.of(context).textTheme.bodyMedium),
                  );
                }).toList(),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
