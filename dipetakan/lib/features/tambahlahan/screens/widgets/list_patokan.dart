import 'dart:io';

import 'package:dipetakan/features/tambahlahan/data/patokan.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

class ListPatokan extends StatefulWidget {
  const ListPatokan({
    super.key,
  });

  @override
  State<ListPatokan> createState() => _ListPatokanState();
}

class _ListPatokanState extends State<ListPatokan> {
  final imagePicker = ImagePicker();
  final List<Patokan> _images = [];
  String strLatLong = 'Belum mendapatkan Lat dan Long, Silahkan tekan tombol';

  bool loading = false;
  //getLatLong
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location service Not Enabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permission denied forever, we cannot access');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> getFromCamera() async {
    try {
      // Set loading to true while fetching location
      setState(() {
        loading = true;
      });

      // Fetch current location
      Position position = await _getGeoLocationPosition();

      // Set loading to false after fetching location
      setState(() {
        loading = false;
      });

      // Capture image from the camera
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.camera);

      // If an image is picked successfully
      if (pickedFile != null) {
        setState(() {
          _images.add(
              Patokan(imagePath: pickedFile.path, coordinates: strLatLong));
          strLatLong = '${position.latitude}, ${position.longitude}';
        });
      }
    } catch (e) {
      // Handle errors if any
      // ignore: avoid_print
      print("Error: $e");
      // You can add error handling code here, such as showing an error message to the user
    }
  }

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

  void _replaceImage(int index) async {
    try {
      // Set loading to true while fetching location
      setState(() {
        loading = true;
      });

      // Fetch current location
      Position position = await _getGeoLocationPosition();

      // Set loading to false after fetching location
      setState(() {
        loading = false;
      });

      // Capture image from the camera
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.camera);

      // If an image is picked successfully
      if (pickedFile != null) {
        setState(() {
          _images[index] =
              Patokan(imagePath: pickedFile.path, coordinates: strLatLong);
          strLatLong = '${position.latitude}, ${position.longitude}';
        });
      }
    } catch (e) {
      // Handle errors if any
      // ignore: avoid_print
      print("Error: $e");
      // You can add error handling code here, such as showing an error message to the user
    }
  }

  void _deleteImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    double listHeight = _images.length * 80.0;
    return SizedBox(
      height: listHeight + 60.0,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _images.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                  onPressed: getFromCamera,
                  child: const Text('Tambah Patokan')),
            );
            // GestureDetector(
            //   onTap: getFromCamera,
            //   child:
            //   Container(
            //     // margin: EdgeInsets.symmetric(horizontal: 8.0),
            //     // width: 80,
            //     height: 100,
            //     decoration: BoxDecoration(
            //       borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            //       color: Colors.grey[200],
            //     ),
            //     child: const Icon(
            //       Icons.camera_alt,
            //       size: 40,
            //       color: Colors.grey,
            //     ),
            //   ),
            // );
          } else {
            return

                // Stack(
                //   children: [
                //     GestureDetector(
                //       onTap: getFromCamera,
                //       child: Container(
                //         margin: const EdgeInsets.only(left: 8.0),
                //         decoration: BoxDecoration(
                //           borderRadius:
                //               const BorderRadius.all(Radius.circular(12.0)),
                //           color: Colors.grey[200],
                //         ),
                //         width: 80,
                //         height: 150,
                //         child: ClipRRect(
                //           borderRadius: BorderRadius.circular(12.0),
                //           child: Image.file(
                //             _images[index - 1],
                //             fit: BoxFit.cover,
                //           ),
                //         ),
                //       ),
                //     ),
                //     Positioned(
                //       top: 5,
                //       right: 5,
                //       child: GestureDetector(
                //         onTap: () => _deleteImage(index - 1),
                //         child: Container(
                //           decoration: BoxDecoration(
                //             shape: BoxShape.circle,
                //             color: Colors.grey[800],
                //           ),
                //           padding: const EdgeInsets.all(4),
                //           child: const Icon(
                //             Icons.close,
                //             color: Colors.white,
                //             size: 15,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // );

                InkWell(
                    onTap: () => _replaceImage(index - 1),
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
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.file(
                                    File(_images[index - 1].imagePath),
                                    fit: BoxFit.cover,
                                  ),
                                ),
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
                                  Text(_images[index - 1].coordinates,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),

                                  // Row(
                                  //   children: <Widget>[
                                  //     Text('Latitude, ',
                                  //         style: Theme.of(context)
                                  //             .textTheme
                                  //             .bodyLarge),
                                  //     Text('Longitude',
                                  //         style: Theme.of(context)
                                  //             .textTheme
                                  //             .bodyLarge)
                                  //   ],
                                  // ),
                                ],
                              ),
                              // ),
                            ),
                            Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () => _deleteImage(index - 1),
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
                                )),
                          ],
                        ),
                      ),
                    ));
          }
        },
      ),
    );

    // ListView.builder(
    //   shrinkWrap: true,
    //   physics: const NeverScrollableScrollPhysics(),
    //   itemCount: 4,
    //   itemBuilder: ((context, index) {
    //     return
    //         // Padding(
    //         //   padding: const EdgeInsets.only(top: 3, left: 8, right: 8),
    //         //   child:

    //         //   Card(
    //         // elevation: 0,
    //         // // clipBehavior: Clip.antiAlias,
    //         // color: Colors.white,
    //         // surfaceTintColor: Colors.white,
    //         // child:

    //         // ListTile(
    //         //   leading: AspectRatio(
    //         //     aspectRatio: 1,
    //         //     child: ClipRRect(
    //         //       borderRadius: const BorderRadius.all(Radius.circular(4.0)),
    //         //       child: Image.network(
    //         //         'https://www.goodnewsfromindonesia.id/uploads/post/large-shutterstock-1033560724-744a102c3f5aca7dc197c497dbaed7cf.jpg',
    //         //         fit: BoxFit.cover,
    //         //       ),
    //         //     ),
    //         //   ),
    //         //   title: const Text('Title'),
    //         //   subtitle: const Text('Subtitle'),
    //         // ),

    //         InkWell(
    //       child: Padding(
    //         padding: const EdgeInsets.symmetric(vertical: 3.0),
    //         child: Container(
    //           decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(15),
    //               border: Border.all(color: Colors.grey)),
    //           height: 80,
    //           padding: const EdgeInsets.all(8),
    //           child: Row(
    //             children: [
    //               Expanded(
    //                 flex: 4,
    //                 child: Container(
    //                   decoration: const BoxDecoration(
    //                       borderRadius: BorderRadius.all(Radius.circular(8.0)),
    //                       image: DecorationImage(
    //                           image: AssetImage('assets/images/farm.jpg'),
    //                           fit: BoxFit.fill)),
    //                 ),
    //               ),
    //               const Spacer(flex: 1),
    //               Expanded(
    //                 flex: 14,
    //                 // child: Container(
    //                 // padding: const EdgeInsets.only(top: 7),
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: <Widget>[
    //                     // Text('Patokan 1',
    //                     //     style: Theme.of(context).textTheme.bodyLarge),
    //                     // const SizedBox(height: 2),
    //                     Row(
    //                       children: <Widget>[
    //                         Text('Latitude, ',
    //                             style: Theme.of(context).textTheme.bodyLarge),
    //                         Text('Longitude',
    //                             style: Theme.of(context).textTheme.bodyLarge)
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //                 // ),
    //               ),
    //               const Expanded(
    //                   flex: 2,
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: <Widget>[
    //                       Icon(Iconsax.arrow_right_3),
    //                     ],
    //                   )),
    //             ],
    //           ),
    //         ),
    //       ),
    //       onTap: () {
    //         Navigator.push(context,
    //             MaterialPageRoute(builder: (context) => const EditPatokan()));
    //       },
    //     )
    //         // )
    //         // )
    //         ;
    //   }),
    // );
  }
}
