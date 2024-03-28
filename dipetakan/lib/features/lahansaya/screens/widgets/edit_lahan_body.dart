import 'package:dipetakan/features/tambahlahan/data/jenislahanlist.dart';
import 'package:dipetakan/features/tambahlahan/models/jenislahanmodel.dart';
import 'package:dipetakan/features/tambahlahan/screens/tambahpatokan.dart';
import 'package:dipetakan/features/tambahlahan/screens/widgets/list_patokan.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:flutter/material.dart';

class EditLahanBody extends StatefulWidget {
  const EditLahanBody({super.key});

  @override
  State<EditLahanBody> createState() => _EditLahanBodyState();
}

class _EditLahanBodyState extends State<EditLahanBody> {
  JenisLahanDataModel? _jenislahanChoose;

  void _onDropDownItemSelected(JenisLahanDataModel? newSelectedJenisLahan) {
    if (newSelectedJenisLahan != null) {
      setState(() {
        _jenislahanChoose = newSelectedJenisLahan;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: DSizes.spaceBtwSections),
        // const EdgeInsets.all(0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              //Informasi Lahan Title
              Text(DTexts.informasiLahan,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: DSizes.spaceBtwInputFields),
              //Nama Lahan
              TextFormField(
                decoration: const InputDecoration(labelText: DTexts.namaLahan),
              ),
              const SizedBox(height: DSizes.spaceBtwInputFields),
              //Jenis Lahan
              FormField<String>(builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: const InputDecoration(
                      // labelText: DTexts.jenisLahan,
                      // errorText: "Wrong Choice",
                      ),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<JenisLahanDataModel>(
                    hint: const Text("Pilih Jenis Lahan",
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                    items: jenisLahanList
                        .map<DropdownMenuItem<JenisLahanDataModel>>(
                            (JenisLahanDataModel value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value.jenisLahan,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black)),
                      );
                    }).toList(),
                    isExpanded: true,
                    isDense: true,
                    onChanged: (JenisLahanDataModel? newSelectedJenisLahan) {
                      _onDropDownItemSelected(newSelectedJenisLahan);
                    },
                    value: _jenislahanChoose,
                  )),
                );
              }),

              const SizedBox(height: DSizes.spaceBtwInputFields),
              //Deskripsi Lahan
              TextFormField(
                decoration:
                    const InputDecoration(labelText: DTexts.deskripsiLahan),
              ),
              const SizedBox(height: DSizes.spaceBtwInputFields),

              const SizedBox(height: DSizes.spaceBtwItems),
              //Foto Patokan
              Text(DTexts.fotoPatokan,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: DSizes.spaceBtwInputFields),

              const ListPatokan(),

              const SizedBox(height: DSizes.spaceBtwInputFields),

              //Tambah Patokan Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TambahPatokan()),
                      );
                    },
                    child: const Text(DTexts.tambahPatokan)),
              ),
              const SizedBox(height: DSizes.spaceBtwSections),
              //Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TambahPatokan()),
                      );
                    },
                    child: const Text(DTexts.submit)),
              ),
              const SizedBox(height: DSizes.spaceBtwInputFields),
              //Delete Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('Hapus')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
