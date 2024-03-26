import 'package:dipetakan/features/lahansaya/screens/deskripsi_lahan.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ListLahan extends StatelessWidget {
  const ListLahan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 15,
      itemBuilder: ((context, index) {
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
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            image: DecorationImage(
                                image: AssetImage('assets/images/farm.jpg'),
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
                            Text(DTexts.namaLahan,
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                            const SizedBox(height: 2),
                            Row(
                              children: <Widget>[
                                Text('Status verifikasi lahan : ',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                                Text('80%',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium)
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(DTexts.deskripsiLahan,
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
                    builder: (context) => const DeskripsiLahan()));
          },
        );
      }),
    );
  }
}
