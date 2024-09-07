import 'dart:io';

// import 'package:dipetakan/features/tambahlahan/controllers/tambahlahan_controller.dart';
import 'package:dipetakan/features/tambahlahan/controllers/tambahlahan_controller.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ListPatokan extends StatefulWidget {
  const ListPatokan({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListPatokanState createState() => _ListPatokanState();
}

class _ListPatokanState extends State<ListPatokan> {
  final TambahLahanController controller = Get.put(TambahLahanController());
  // final TambahLahanController controller = Get.put(TambahLahanController());
  final ImagePicker imagePicker = ImagePicker();
  String strLatLong = 'Belum mendapatkan Lat dan Long';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      double listHeight = controller.patokanList.length * 80.0;
      return SizedBox(
        height: listHeight + 80.0,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: controller.patokanList.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                    onPressed: () =>
                        // controller.addMarker,
                        controller.addPatokan(context),
                    child: const Text('Tambah Patokan')),
              );
            } else {
              return InkWell(
                onTap: () => controller.editPatokan(context, index - 1),
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
                          child: controller
                                  .patokanList[index - 1].localPath.isNotEmpty
                              ? Container(
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Image.file(
                                      File(controller
                                          .patokanList[index - 1].localPath),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
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
                                controller.patokanList[index - 1].coordinates,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () =>
                                    controller.deletePatokan(index - 1),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[800],
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      );
    });
  }
}
