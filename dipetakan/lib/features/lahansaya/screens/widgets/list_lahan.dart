import 'package:dipetakan/features/lahansaya/controllers/lahansaya_controller.dart';
import 'package:dipetakan/features/lahansaya/screens/deskripsi_lahan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ListLahan extends StatelessWidget {
  const ListLahan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LahanSayaController());
    return Obx(() {
      if (controller.profileLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.lahanList.isEmpty) {
        return const Center(child: Text('No Lahan found'));
      }
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.lahanList.length,
        itemBuilder: ((context, index) {
          final lahan = controller.lahanList[index];
          String imageUrl = 'assets/images/farm.jpg';

          for (var patokan in lahan.patokan) {
            if (patokan.fotoPatokan.isNotEmpty) {
              imageUrl = patokan.fotoPatokan;
              break;
            }
          }
          return InkWell(
            child: Padding(
              padding: const EdgeInsets.only(top: 3, left: 8, right: 8),
              child: Card(
                elevation: 0,
                clipBehavior: Clip.antiAlias,
                color: Colors.white,
                surfaceTintColor: Colors.white,
                child: Container(
                  height: 110,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0)),
                              image: DecorationImage(
                                  image: imageUrl.startsWith('assets/')
                                      ? AssetImage(imageUrl) as ImageProvider
                                      : NetworkImage(imageUrl),
                                  fit: BoxFit.fill)),
                        ),
                      ),
                      const Spacer(flex: 1),
                      Expanded(
                        flex: 14,
                        child: Container(
                          padding: const EdgeInsets.only(top: 7),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(lahan.namaLahan,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                              const SizedBox(height: 2),
                              Row(
                                children: <Widget>[
                                  Text('Status verifikasi : ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  Text('${lahan.progress}%',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium)
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(lahan.jenisLahan,
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                      ),
                      const Expanded(
                          flex: 2,
                          // child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Iconsax.arrow_right_3),
                            ],
                          )
                          // )
                          ),
                    ],
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeskripsiLahan(lahan: lahan)));
            },
          );
        }),
      );
    });
  }
}
