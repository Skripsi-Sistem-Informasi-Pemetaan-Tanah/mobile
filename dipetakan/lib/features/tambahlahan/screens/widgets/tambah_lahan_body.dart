// import 'package:dipetakan/features/tambahlahan/controllers/tambahlahan_controller.dart';
import 'package:dipetakan/features/tambahlahan/controllers/tambahlahan_controller_dua.dart';
import 'package:dipetakan/features/tambahlahan/data/jenislahanlist.dart';
import 'package:dipetakan/features/tambahlahan/models/jenislahanmodel.dart';
import 'package:dipetakan/features/tambahlahan/screens/widgets/list_patokan.dart';
import 'package:dipetakan/features/tambahlahan/screens/widgets/list_patokan_geolocator.dart';
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
  // final TambahLahanController controller = Get.put(TambahLahanController());
  final TambahLahanControllerOld controller =
      Get.put(TambahLahanControllerOld());
  // JenisLahanDataModel? _jenislahanChoose;

  // void _onDropDownItemSelected(JenisLahanDataModel? newSelectedJenisLahan) {
  //   if (newSelectedJenisLahan != null) {
  //     setState(() {
  //       _jenislahanChoose = newSelectedJenisLahan;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(TambahLahanController());
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: DSizes.spaceBtwSections),
        // const EdgeInsets.all(0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Form(
            key: controller.tambahLahanFormKey,
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
                  controller: controller.namaLahanController,
                  validator: (value) =>
                      TValidator.validateEmptyText('Nama lahan', value),
                  decoration:
                      const InputDecoration(labelText: DTexts.namaLahan),
                ),
                const SizedBox(height: DSizes.spaceBtwInputFields),
                //Jenis Lahan
                // FormField<String>(builder: (FormFieldState<String> state) {
                //   return InputDecorator(
                //     decoration: const InputDecoration(
                //         // labelText: DTexts.jenisLahan,
                //         // errorText: "Wrong Choice",
                //         ),
                //     child: DropdownButtonHideUnderline(
                //         child: DropdownButton<JenisLahanDataModel>(
                //       hint: const Text("Pilih Jenis Lahan",
                //           style: TextStyle(fontSize: 14, color: Colors.grey)),
                //       items: jenisLahanList
                //           .map<DropdownMenuItem<JenisLahanDataModel>>(
                //               (JenisLahanDataModel value) {
                //         return DropdownMenuItem(
                //           value: value,
                //           child: Text(value.jenisLahan,
                //               style: const TextStyle(
                //                   fontSize: 14, color: Colors.black)),
                //         );
                //       }).toList(),
                //       isExpanded: true,
                //       isDense: true,
                //       onChanged: (JenisLahanDataModel? newSelectedJenisLahan) {
                //         _onDropDownItemSelected(newSelectedJenisLahan);
                //       },
                //       value: _jenislahanChoose,
                //     )),
                //   );
                // }),

                ValueListenableBuilder<JenisLahanDataModel?>(
                  valueListenable: controller.jenisLahanNotifier,
                  builder: (context, selectedJenisLahan, child) {
                    return DropdownButtonFormField<JenisLahanDataModel>(
                      decoration: const InputDecoration(
                        labelText: "Pilih Jenis Lahan",
                        // You can also add errorText or other InputDecoration properties here
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

                const SizedBox(height: 500, child: PinPoint()),

                const SizedBox(height: DSizes.spaceBtwInputFields),

                Obx(() {
                  final patokanList = controller.patokanList;
                  final availableHeight = MediaQuery.of(context).size.height;
                  final listHeight =
                      (patokanList.length * 80).clamp(0, availableHeight * 1);
                  // availableHeight * 0.3 +
                  //     (patokanList.length * 80).clamp(0, availableHeight * 0.5);

                  return SizedBox(
                    height: listHeight.toDouble(),
                    child: ListPatokan(
                      patokanList: patokanList,
                    ),
                  );
                }),
                // SizedBox(
                //   height: 300, // Set a fixed height for ListPatokan
                //   child: ListPatokan(
                //     patokanList: controller.patokanList,
                //   ),
                // ),
                // const ListPatokanOld(),
                const ListPatokanGeo(),

                const SizedBox(height: DSizes.spaceBtwInputFields),

                //Tambah Patokan Button
                // SizedBox(
                //   width: double.infinity,
                //   child: OutlinedButton(
                //       onPressed: () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => const TambahPatokan()),
                //         );
                //       },
                //       child: const Text(DTexts.tambahPatokan)),
                // ),
                // const SizedBox(height: DSizes.spaceBtwSections),
                // //Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => controller.saveTambahLahanForm(),
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
