import 'dart:io';

// import 'package:dipetakan/features/tambahlahan/controllers/tambahlahan_controller.dart';
import 'package:dipetakan/features/lahansaya/controllers/petafotopatokan_controller.dart';
import 'package:dipetakan/features/tambahlahan/models/lahan_model.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ListPatokanEdit extends StatefulWidget {
  final List<PatokanModel> initialPatokanList;
  final PetaFotoPatokanController controller;
  // final LahanModel lahan;

  const ListPatokanEdit({
    super.key,
    required this.initialPatokanList,
    required this.controller,
    // required this.lahan
  });

  @override
  // ignore: library_private_types_in_public_api
  _ListPatokanEditState createState() => _ListPatokanEditState();
}

class _ListPatokanEditState extends State<ListPatokanEdit> {
  // final TambahLahanControllerOld controller =
  //     Get.put(TambahLahanControllerOld());
  // final PetaFotoPatokanController controller =
  //     Get.put(PetaFotoPatokanController());

  final ImagePicker imagePicker = ImagePicker();
  String strLatLong = 'Belum mendapatkan Lat dan Long';
  bool loading = false;

  @override
  void initState() {
    super.initState();
    // Initialize the controller's patokanList with the provided initial list
    widget.controller.patokanList.value = widget.initialPatokanList
        .map((patokan) => PatokanModel(
              coordinates: patokan.coordinates,
              fotoPatokan: patokan.fotoPatokan,
              coordComment: patokan.coordComment,
              coordCommentUser: patokan.coordCommentUser,
              coordVerif: patokan.coordVerif,
              coordStatus: patokan.coordStatus,
              coordPercent: patokan.coordPercent,
              localPath: patokan.localPath, // Initialize with null
            ))
        .toList()
        .obs;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Filter patokanList based on coordComment condition
      var filteredPatokanList = widget.controller.patokanList
          .where((patokan) =>
              patokan.coordComment.contains("foto patokan perlu direvisi"))
          .toList();
      double listHeight = filteredPatokanList.length * 80.0;
      return SizedBox(
        height: listHeight + 80.0,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: filteredPatokanList.length,
          itemBuilder: (context, index) {
            // if (index == 0) {
            //   return SizedBox(
            //     width: double.infinity,
            //     child: OutlinedButton(
            //         onPressed: () => controller.addPatokan(context),
            //         child: const Text('Tambah Patokan')),
            //   );
            // } else {
            return InkWell(
              onTap: () => widget.controller.replaceFotoPatokan(
                context, filteredPatokanList[index].coordinates,
                //     (updatedPatokanList) {
                //   setState(() {
                //     controller.patokanList.value = updatedPatokanList;
                //     if (kDebugMode) {
                //       print(updatedPatokanList);
                //     }
                //   });
                // }
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey)),
                  height: 80,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: filteredPatokanList[index].localPath.isNotEmpty
                            ? Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.file(
                                    File(filteredPatokanList[index].localPath),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            // : filteredPatokanList[index].fotoPatokan.isNotEmpty
                            //     ? Container(
                            //         decoration: const BoxDecoration(
                            //           borderRadius: BorderRadius.all(
                            //               Radius.circular(8.0)),
                            //         ),
                            //         child: ClipRRect(
                            //           borderRadius: BorderRadius.circular(12.0),
                            //           child: Image.network(
                            //             controller
                            //                 .patokanList[index].fotoPatokan,
                            //             fit: BoxFit.cover,
                            //           ),
                            //         ),
                            //       )
                            : Container(
                                alignment: Alignment.center,
                                height: 80,
                                decoration: const BoxDecoration(
                                  color: DColors.secondary,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                child: Text('No Image',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    textAlign: TextAlign.center),
                              ),
                      ),
                      const Spacer(flex: 1),
                      Expanded(
                        flex: 14,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              filteredPatokanList[index].coordinates,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      // Expanded(
                      //   child: SizedBox(
                      //     width: double.infinity,
                      //     child: ElevatedButton(
                      //         onPressed: () =>
                      //             controller.updateFotoPatokan(widget.lahan),
                      //         child: const Text(DTexts.submit)),
                      //   ),
                      // ),
                      // const Expanded(
                      //   flex: 2,
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: <Widget>[
                      // GestureDetector(
                      //   onTap: () => controller.deletePatokan(index - 1),
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       color: Colors.grey[800],
                      //     ),
                      //     padding: const EdgeInsets.all(4),
                      //     child: const Icon(
                      //       Icons.close,
                      //       color: Colors.white,
                      //       size: 15,
                      //     ),
                      //   ),
                      // ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            );
            // }
          },
        ),
      );
    });
  }
}
