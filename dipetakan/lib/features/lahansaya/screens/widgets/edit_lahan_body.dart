import 'package:dipetakan/features/lahansaya/controllers/petafotopatokan_controller.dart';
import 'package:dipetakan/features/lahansaya/screens/peta_revisi_foto_patokan.dart';
import 'package:dipetakan/features/lahansaya/screens/widgets/list_patokan_edit.dart';
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
  final PetaFotoPatokanController controller =
      Get.put(PetaFotoPatokanController());

  @override
  void initState() {
    super.initState();
    controller.patokanList.value = widget.lahan.patokan;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: DSizes.spaceBtwSections),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Form(
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
                ),

                //Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () =>
                          controller.updateFotoPatokan(widget.lahan),
                      child: const Text(DTexts.submit)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
