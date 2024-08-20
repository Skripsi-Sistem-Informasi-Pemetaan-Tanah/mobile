import 'package:dipetakan/features/lahansaya/controllers/petafotopatokan_controller.dart';
import 'package:dipetakan/features/lahansaya/screens/peta_revisi_foto_patokan.dart';
import 'package:dipetakan/features/lahansaya/screens/peta_titik_validasi.dart';
import 'package:dipetakan/features/lahansaya/screens/widgets/list_patokan_edit.dart';
// import 'package:dipetakan/features/tambahlahan/controllers/tambahlahan_controller.dart';
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
  // final TambahLahanControllerOld controller =
  //     Get.put(TambahLahanControllerOld());
  final PetaFotoPatokanController controller =
      Get.put(PetaFotoPatokanController());

  @override
  void initState() {
    super.initState();
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
            // key: controller.tambahLahanFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(DTexts.fotoPatokan,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: DSizes.spaceBtwInputFields),

                SizedBox(
                    height: 500,
                    child: PetaRevisiFotoPatokan(mapId: widget.lahan.id)),

                const SizedBox(height: DSizes.spaceBtwItems),

                ListPatokanEdit(
                  initialPatokanList: widget.lahan.patokan,
                  controller: controller,
                  // lahan: widget.lahan
                ),
                // const ListPatokanOld(),
                //Submit Button
                Obx(() {
                  if (widget.lahan.verifikasi.isNotEmpty) {
                    // Sort the verifikasi list by verifiedAt in descending order
                    widget.lahan.verifikasi
                        .sort((a, b) => b.verifiedAt.compareTo(a.verifiedAt));

                    // Get the newest comentar
                    String newestCommentVerifikasi =
                        widget.lahan.verifikasi.first.comentar.trim();

                    // Check if the newest comentar starts with "foto patokan perlu direvisi"
                    if (newestCommentVerifikasi
                        .startsWith("foto patokan perlu direvisi")) {
                      return Container(); // Hide the button
                    } else {
                      // Check if any patokan needs a photo revision
                      bool needToRevisePhoto = controller.patokanList.any(
                          (patokan) => patokan.coordComment
                              .contains("foto patokan perlu direvisi"));

                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (needToRevisePhoto) {
                              controller.updateFotoPatokan(widget.lahan);
                            } else {
                              Get.to(
                                  () => PetaTitikValidasi(lahan: widget.lahan));
                            }
                          },
                          child:
                              Text(needToRevisePhoto ? 'Kirim' : 'Selanjutnya'),
                        ),
                      );
                    }
                  } else {
                    return Container(); // Hide the button if verifikasi is empty
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
