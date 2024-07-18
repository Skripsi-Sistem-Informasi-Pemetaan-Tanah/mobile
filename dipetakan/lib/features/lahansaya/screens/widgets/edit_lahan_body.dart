import 'package:dipetakan/features/lahansaya/screens/widgets/list_patokan_edit.dart';
// import 'package:dipetakan/features/tambahlahan/controllers/tambahlahan_controller.dart';
import 'package:dipetakan/features/tambahlahan/controllers/tambahlahan_controller_dua.dart';
import 'package:dipetakan/features/tambahlahan/models/lahan_model.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditLahanBody extends StatefulWidget {
  final LahanModel lahan;
  const EditLahanBody({super.key, required this.lahan});

  @override
  State<EditLahanBody> createState() => _EditLahanBodyState();
}

class _EditLahanBodyState extends State<EditLahanBody> {
  final TambahLahanControllerOld controller =
      Get.put(TambahLahanControllerOld());

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers and other state variables with the data from widget.lahan
    // controller.namaLahanController.text = widget.lahan.namaLahan;
    // controller.deskripsiLahanController.text = widget.lahan.deskripsiLahan;
    // controller.jenisLahanNotifier.value = jenisLahanList.firstWhere(
    //   (jenisLahan) => jenisLahan.jenisLahan == widget.lahan.jenisLahan,
    //   orElse: () => jenisLahanList[0],
    // );
    controller.patokanList.value = widget.lahan.patokan;
  }

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
                // Text(DTexts.informasiLahan,
                //     style: Theme.of(context).textTheme.headlineSmall),
                // const SizedBox(height: DSizes.spaceBtwInputFields),
                // //Nama Lahan
                // TextFormField(
                //   controller: controller.namaLahanController,
                //   decoration:
                //       const InputDecoration(labelText: DTexts.namaLahan),
                // ),
                // const SizedBox(height: DSizes.spaceBtwInputFields),
                // //Jenis Lahan
                // // FormField<String>(builder: (FormFieldState<String> state) {
                // //   return InputDecorator(
                // //     decoration: const InputDecoration(
                // //         // labelText: DTexts.jenisLahan,
                // //         // errorText: "Wrong Choice",
                // //         ),
                // //     child: DropdownButtonHideUnderline(
                // //         child: DropdownButton<JenisLahanDataModel>(
                // //       hint: const Text("Pilih Jenis Lahan",
                // //           style: TextStyle(fontSize: 14, color: Colors.grey)),
                // //       items: jenisLahanList
                // //           .map<DropdownMenuItem<JenisLahanDataModel>>(
                // //               (JenisLahanDataModel value) {
                // //         return DropdownMenuItem(
                // //           value: value,
                // //           child: Text(value.jenisLahan,
                // //               style: const TextStyle(
                // //                   fontSize: 14, color: Colors.black)),
                // //         );
                // //       }).toList(),
                // //       isExpanded: true,
                // //       isDense: true,
                // //       onChanged: (JenisLahanDataModel? newSelectedJenisLahan) {
                // //         _onDropDownItemSelected(newSelectedJenisLahan);
                // //       },
                // //       value: _jenislahanChoose,
                // //     )),
                // //   );
                // // }),

                // ValueListenableBuilder<JenisLahanDataModel?>(
                //   valueListenable: controller.jenisLahanNotifier,
                //   builder: (context, selectedJenisLahan, child) {
                //     return DropdownButtonFormField<JenisLahanDataModel>(
                //       decoration: const InputDecoration(
                //         labelText: "Pilih Jenis Lahan",
                //         // You can also add errorText or other InputDecoration properties here
                //       ),
                //       items: jenisLahanList
                //           .map<DropdownMenuItem<JenisLahanDataModel>>(
                //               (JenisLahanDataModel value) {
                //         return DropdownMenuItem<JenisLahanDataModel>(
                //           value: value,
                //           child: Text(value.jenisLahan,
                //               style: const TextStyle(
                //                   fontSize: 14, color: Colors.black)),
                //         );
                //       }).toList(),
                //       isExpanded: true,
                //       isDense: true,
                //       onChanged: (JenisLahanDataModel? newSelectedJenisLahan) {
                //         controller.jenisLahanNotifier.value =
                //             newSelectedJenisLahan;
                //       },
                //       value: selectedJenisLahan,
                //     );
                //   },
                // ),

                // const SizedBox(height: DSizes.spaceBtwInputFields),
                // //Deskripsi Lahan
                // TextFormField(
                //   controller: controller.deskripsiLahanController,
                //   validator: (value) =>
                //       TValidator.validateEmptyText('DeskripsiLahan', value),
                //   decoration:
                //       const InputDecoration(labelText: DTexts.deskripsiLahan),
                // ),
                // const SizedBox(height: DSizes.spaceBtwInputFields),

                // const SizedBox(height: DSizes.spaceBtwItems),
                //Foto Patokan
                Text(DTexts.fotoPatokan,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: DSizes.spaceBtwInputFields),

                ListPatokanEdit(initialPatokanList: widget.lahan.patokan),
                // const ListPatokanOld(),

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
                      onPressed: () =>
                          controller.updateFotoPatokan(widget.lahan),
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
