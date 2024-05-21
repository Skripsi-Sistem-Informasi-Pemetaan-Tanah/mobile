import 'package:dipetakan/features/lahansaya/screens/widgets/search_bar.dart';
import 'package:dipetakan/features/petalahan/controllers/petalahan_controller.dart';
// import 'package:dipetakan/features/petalahan/screens/widgets/infolahan_bottomsheet.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class PetaLahanScreen extends StatelessWidget {
  final controller = Get.put(PetaLahanController());

  PetaLahanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: DColors.primary,
          title: const Text(
            'Peta Lahan',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontStyle: FontStyle.normal),
          ),
        ),
        body: Obx(() {
          if (controller.currentLocation.value == null) {
            return const Center(child: Text("Loading"));
          } else {
            return Stack(children: <Widget>[
              GoogleMap(
                mapType: MapType.satellite,
                initialCameraPosition: CameraPosition(
                    target: LatLng(controller.currentLocation.value!.latitude!,
                        controller.currentLocation.value!.longitude!),
                    zoom: 20),
                onMapCreated: (mapController) {
                  if (!controller.mapController.isCompleted) {
                    controller.mapController.complete(mapController);
                  }
                },
                // ignore: unnecessary_null_comparison
                markers: controller.markerbitmap.value != null
                    ? {
                        Marker(
                          markerId: const MarkerId("1"),
                          position: LatLng(
                              controller.currentLocation.value!.latitude!,
                              controller.currentLocation.value!.longitude!),
                        )
                      }
                    : <Marker>{},
                // circles: {
                //   Circle(
                //       circleId: const CircleId("1"),
                //       center: LatLng(
                //           controller.currentLocation.value!.latitude!,
                //           controller.currentLocation.value!.longitude!),
                //       radius: 25,
                //       strokeWidth: 2,
                //       strokeColor: Colors.yellow,
                //       fillColor: Colors.yellow.withOpacity(0.2)),
                // },
                polygons: controller.buildPolygons(),
                zoomControlsEnabled: true,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                compassEnabled: true,
              ),
              const Positioned(child: CustomSearchBar()),
            ]);
          }
        }));
  }
}
