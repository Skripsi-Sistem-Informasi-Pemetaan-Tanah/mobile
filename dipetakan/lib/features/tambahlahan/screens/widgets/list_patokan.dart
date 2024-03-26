import 'package:dipetakan/features/tambahlahan/screens/editpatokan.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ListPatokan extends StatelessWidget {
  const ListPatokan({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: ((context, index) {
        return
            // Padding(
            //   padding: const EdgeInsets.only(top: 3, left: 8, right: 8),
            //   child:

            //   Card(
            // elevation: 0,
            // // clipBehavior: Clip.antiAlias,
            // color: Colors.white,
            // surfaceTintColor: Colors.white,
            // child:

            // ListTile(
            //   leading: AspectRatio(
            //     aspectRatio: 1,
            //     child: ClipRRect(
            //       borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            //       child: Image.network(
            //         'https://www.goodnewsfromindonesia.id/uploads/post/large-shutterstock-1033560724-744a102c3f5aca7dc197c497dbaed7cf.jpg',
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ),
            //   title: const Text('Title'),
            //   subtitle: const Text('Subtitle'),
            // ),

            InkWell(
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
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          image: DecorationImage(
                              image: AssetImage('assets/images/farm.jpg'),
                              fit: BoxFit.fill)),
                    ),
                  ),
                  const Spacer(flex: 1),
                  Expanded(
                    flex: 14,
                    // child: Container(
                    // padding: const EdgeInsets.only(top: 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Text('Patokan 1',
                        //     style: Theme.of(context).textTheme.bodyLarge),
                        // const SizedBox(height: 2),
                        Row(
                          children: <Widget>[
                            Text('Latitude, ',
                                style: Theme.of(context).textTheme.bodyLarge),
                            Text('Longitude',
                                style: Theme.of(context).textTheme.bodyLarge)
                          ],
                        ),
                      ],
                    ),
                    // ),
                  ),
                  const Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Iconsax.arrow_right_3),
                        ],
                      )),
                ],
              ),
            ),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const EditPatokan()));
          },
        )
            // )
            // )
            ;
      }),
    );
  }
}
