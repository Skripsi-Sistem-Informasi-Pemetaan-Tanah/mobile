import 'dart:io';
// import 'dart:js';

import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class TambahPatokanBody extends StatefulWidget {
  const TambahPatokanBody({super.key});

  @override
  State<TambahPatokanBody> createState() => _TambahPatokanBodyState();
}

class _TambahPatokanBodyState extends State<TambahPatokanBody> {
  File? imageFile;
  final imagePicker = ImagePicker();

  String strLatLong = 'Belum mendapatkan Lat dan Long, Silahkan tekan tombol';
  String strAlamat = 'Mencari Lokasi';
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

  //getAddress
  // Future<void> getAddressFromLongLat(Position position) async {
  //   List<Placemark> placemarks =
  //       await placemarkFromCoordinates(position.latitude, position.longitude);
  //   // ignore: avoid_print
  //   print(placemarks);

  //   Placemark place = placemarks[0];
  //   setState(() {
  //     strAlamat =
  //         '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: DSizes.spaceBtwSections),
        // const EdgeInsets.all(0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              //Informasi Lahan Title
              Text(DTexts.fotoPatokan,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: DSizes.sm),

              Container(
                margin: const EdgeInsets.all(20),
                width: size.width,
                height: 250,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  color: Colors.grey,
                  strokeWidth: 1,
                  dashPattern: const [5, 5],
                  child: SizedBox.expand(
                    child: FittedBox(
                        child: imageFile != null
                            ? Image.file(File(imageFile!.path),
                                fit: BoxFit.cover)
                            : const Icon(Icons.image_outlined,
                                color: Colors.grey)),
                  ),
                ),
              ),

              // Container(
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(15),
              //       border: Border.all(color: Colors.grey)),
              //   height: 150,
              //   width: double.infinity,
              //   child: const Icon(Icons.image, size: 100, color: Colors.grey),
              // ),
              const SizedBox(height: DSizes.spaceBtwInputFields),
              //Ambil Gambar Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      // showPictureDialog();
                      getFromCamera();
                    },
                    child: const Text(DTexts.ambilfotoPatokan)),
              ),
              const SizedBox(height: DSizes.spaceBtwInputFields),
              //Hapus Gambar Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        imageFile = null;
                      });
                    },
                    child: const Text(DTexts.hapusFoto)),
              ),
              const SizedBox(height: DSizes.spaceBtwSections),

              //Titik Koordinat
              Text(DTexts.titikKoordinat,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: DSizes.spaceBtwInputFields),

              Text(strLatLong, style: Theme.of(context).textTheme.bodyLarge),
              // const SizedBox(height: DSizes.spaceBtwInputFields),
              // Text(strAlamat, style: Theme.of(context).textTheme.bodyLarge),

              const SizedBox(height: DSizes.defaultSpace),

              //Dapatkan Lokasi Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });

                      Position position = await _getGeoLocationPosition();
                      setState(() {
                        loading = false;
                        strLatLong =
                            '${position.latitude}, ${position.longitude}';
                      });

                      // getAddressFromLongLat(position);
                    },
                    child: const Text(DTexts.dapatkanLokasi)),
              ),

              const SizedBox(height: DSizes.spaceBtwSections),
              //Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {}, child: const Text(DTexts.submit)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showPictureDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Action'),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  getFromCamera();
                  Navigator.of(context).pop();
                },
                child: const Text('Open Camera'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  getFromGallery();
                  Navigator.of(context).pop();
                },
                child: const Text('Open Gallery'),
              ),
            ],
          );
        });
  }

  getFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxWidth: 1000, maxHeight: 1000);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  getFromCamera() async {
    final pickedFile = await imagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 1000, maxWidth: 1000);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}
