import 'package:dipetakan/features/tambahlahan/controllers/tambahlahan_controller.dart';
import 'package:dipetakan/features/tambahlahan/data/jenislahanlist.dart';
import 'package:dipetakan/features/tambahlahan/models/jenislahanmodel.dart';
import 'package:dipetakan/features/tambahlahan/screens/widgets/list_patokan.dart';
import 'package:dipetakan/features/tambahlahan/screens/widgets/pin_point.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:dipetakan/util/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TambahLahanBody extends StatefulWidget {
  const TambahLahanBody({super.key});

  @override
  State<TambahLahanBody> createState() => _TambahLahanBodyState();
}

class _TambahLahanBodyState extends State<TambahLahanBody> {
  final TambahLahanController controller = Get.put(TambahLahanController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: DSizes.spaceBtwSections),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Form(
            key: controller.tambahLahanFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //Informasi Lahan Title
                Text(DTexts.informasiLahan,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: DSizes.spaceBtwInputFields),
                //Nama Lahan
                TextFormField(
                  controller: controller.namaLahanController,
                  validator: (value) =>
                      TValidator.validateEmptyText('Nama lahan', value),
                  decoration:
                      const InputDecoration(labelText: DTexts.namaLahan),
                ),
                const SizedBox(height: DSizes.spaceBtwInputFields),
                //Jenis Lahan
                ValueListenableBuilder<JenisLahanDataModel?>(
                  valueListenable: controller.jenisLahanNotifier,
                  builder: (context, selectedJenisLahan, child) {
                    return DropdownButtonFormField<JenisLahanDataModel>(
                      dropdownColor: Colors.white,
                      decoration: const InputDecoration(
                        labelText: "Pilih Jenis Lahan",
                      ),
                      items: jenisLahanList
                          .map<DropdownMenuItem<JenisLahanDataModel>>(
                              (JenisLahanDataModel value) {
                        return DropdownMenuItem<JenisLahanDataModel>(
                          value: value,
                          child: Text(value.jenisLahan,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black)),
                        );
                      }).toList(),
                      isExpanded: true,
                      isDense: true,
                      onChanged: (JenisLahanDataModel? newSelectedJenisLahan) {
                        controller.jenisLahanNotifier.value =
                            newSelectedJenisLahan;
                      },
                      value: selectedJenisLahan,
                      validator: (value) =>
                          TValidator.validateJenisLahan('Jenis Lahan', value),
                    );
                  },
                ),
                const SizedBox(height: DSizes.spaceBtwInputFields),
                //Deskripsi Lahan
                TextFormField(
                  controller: controller.deskripsiLahanController,
                  validator: (value) =>
                      TValidator.validateEmptyText('Deskripsi Lahan', value),
                  decoration:
                      const InputDecoration(labelText: DTexts.deskripsiLahan),
                ),
                const SizedBox(height: DSizes.spaceBtwInputFields),

                const SizedBox(height: DSizes.spaceBtwItems),
                //Foto Patokan
                Text(DTexts.fotoPatokan,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: DSizes.spaceBtwInputFields),

                Text(
                  "Harap tambahkan patok dan titik koordinat secara berurutan untuk membentuk bidang atau bangun dasar lahan Anda.",
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: DSizes.spaceBtwInputFields),

                const SizedBox(height: 500, child: PinPoint()),

                const SizedBox(height: DSizes.spaceBtwInputFields),

                const ListPatokan(),

                const SizedBox(height: DSizes.spaceBtwInputFields),

                //Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () =>
                          controller.confirmAndSaveTambahLahanForm(),
                      child: const Text(DTexts.submit)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
