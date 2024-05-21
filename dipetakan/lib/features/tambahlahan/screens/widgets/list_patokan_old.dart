// import 'dart:io';

import 'package:dipetakan/features/tambahlahan/models/patokan.dart';
import 'package:dipetakan/features/tambahlahan/screens/editpatokan.dart';
import 'package:dipetakan/features/tambahlahan/screens/tambahpatokan.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:geolocator/geolocator.dart';

class ListPatokanOld extends StatefulWidget {
  const ListPatokanOld({
    super.key,
  });

  @override
  State<ListPatokanOld> createState() => _ListPatokanOldState();
}

class _ListPatokanOldState extends State<ListPatokanOld> {
  final imagePicker = ImagePicker();
  // final List<Patokan> _images = [];
  String strLatLong = 'Belum mendapatkan Lat dan Long, Silahkan tekan tombol';

  bool loading = false;
  //getLatLong
  // Future<Position> _getGeoLocationPosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();

  //   if (!serviceEnabled) {
  //     await Geolocator.openLocationSettings();
  //     return Future.error('Location service Not Enabled');
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permission denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permission denied forever, we cannot access');
  //   }

  //   return await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );
  // }

  final List<Patokan> _patokanList = [];

  // void _addPatokan(Patokan patokan) {
  //   setState(() {
  //     _patokanList.add(patokan);
  //   });
  // }

  // Future<void> getFromCamera() async {
  //   try {
  //     // Set loading to true while fetching location
  //     setState(() {
  //       loading = true;
  //     });

  //     // Fetch current location
  //     Position position = await _getGeoLocationPosition();

  //     // Set loading to false after fetching location
  //     setState(() {
  //       loading = false;
  //     });

  //     // Capture image from the camera
  //     final pickedFile =
  //         await imagePicker.pickImage(source: ImageSource.camera);

  //     // If an image is picked successfully
  //     if (pickedFile != null) {
  //       setState(() {
  //         _images.add(
  //             Patokan(imagePath: pickedFile.path, coordinates: strLatLong));
  //         strLatLong = '${position.latitude}, ${position.longitude}';
  //       });
  //     }
  //   } catch (e) {
  //     // Handle errors if any
  //     // ignore: avoid_print
  //     print("Error: $e");
  //     // You can add error handling code here, such as showing an error message to the user
  //   }
  // }

  // Future<void> getFromCamera() async {
  //   final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _images.add(File(pickedFile.path));
  //       // if (_images.isNotEmpty) {
  //       //   // If there is already an image, replace it with the new one
  //       //     _images[0] = File(pickedFile.path);
  //       //   } else {
  //       //   _images.add(File(pickedFile.path));
  //       // }
  //     });
  //   }
  // }

  // void _replaceImage(int index) async {
  //   try {
  //     // Set loading to true while fetching location
  //     setState(() {
  //       loading = true;
  //     });

  //     // Fetch current location
  //     Position position = await _getGeoLocationPosition();

  //     // Set loading to false after fetching location
  //     setState(() {
  //       loading = false;
  //     });

  //     // Capture image from the camera
  //     final pickedFile =
  //         await imagePicker.pickImage(source: ImageSource.camera);

  //     // If an image is picked successfully
  //     if (pickedFile != null) {
  //       setState(() {
  //         _images[index] =
  //             Patokan(imagePath: pickedFile.path, coordinates: strLatLong);
  //         strLatLong = '${position.latitude}, ${position.longitude}';
  //       });
  //     }
  //   } catch (e) {
  //     // Handle errors if any
  //     // ignore: avoid_print
  //     print("Error: $e");
  //     // You can add error handling code here, such as showing an error message to the user
  //   }
  // }

  // void _deleteImage(int index) {
  //   setState(() {
  //     _images.removeAt(index);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _patokanList.length,
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
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                                Text('Longitude',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge)
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditPatokan()));
              },
            )
                // )
                // )
                ;
          }),
        ),
        const SizedBox(height: DSizes.spaceBtwInputFields),
//Tambah Patokan Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TambahPatokan()),
                );
              },
              child: const Text(DTexts.tambahPatokan)),
        ),
        const SizedBox(height: DSizes.spaceBtwSections),
      ],
    );
  }
}
