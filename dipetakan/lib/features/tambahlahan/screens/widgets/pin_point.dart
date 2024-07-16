// import 'package:dipetakan/features/lahansaya/screens/widgets/search_bar.dart';
// import 'package:dipetakan/features/lahansaya/screens/widgets/filter_button.dart';
// import 'package:dipetakan/features/petalahan/controllers/petalahan_controller.dart';
// import 'package:dipetakan/features/tambahlahan/controllers/pinpoint_controller.dart';
// import 'package:dipetakan/features/tambahlahan/controllers/tambahlahan_controller.dart';
import 'package:dipetakan/features/tambahlahan/controllers/tambahlahan_controller_dua.dart';
// import 'package:dipetakan/features/petalahan/screens/widgets/infolahan_bottomsheet.dart';
// import 'package:dipetakan/util/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class PinPoint extends StatefulWidget {
  const PinPoint({super.key});

  @override
  State<PinPoint> createState() => _PinPointState();
}

class _PinPointState extends State<PinPoint> {
  // final TambahLahanController controller = Get.put(TambahLahanController());
  final TambahLahanControllerOld controller =
      Get.put(TambahLahanControllerOld());
  // final controller = Get.put(TambahLahanController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   iconTheme: const IconThemeData(color: Colors.white),
      //   backgroundColor: DColors.primary,
      //   title: const Text(
      //     'Peta Lahan',
      //     style: TextStyle(
      //         color: Colors.white,
      //         fontFamily: 'Inter',
      //         fontStyle: FontStyle.normal),
      //   ),
      // ),
      // body: Obx(() {
      //   if (controller.currentLocation.value == null) {
      //     return const Center(child: Text("Loading"));
      //   } else {
      //     return Stack(children: <Widget>[
      //       GoogleMap(
      //         mapType: MapType.satellite,
      //         initialCameraPosition: CameraPosition(
      //             target: LatLng(controller.currentLocation.value!.latitude!,
      //                 controller.currentLocation.value!.longitude!),
      //             zoom: 20),
      //         onMapCreated: (mapController) {
      //           if (!controller.mapController.isCompleted) {
      //             controller.mapController.complete(mapController);
      //           }
      //         },
      //         onTap: (LatLng position) {
      //           // Handle tap event to add marker
      //           controller.addPatokan(context);
      //         },
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
              // onTap: (LatLng position) {
              //   // Handle tap event to add marker
              //   controller.addPatokan(context, position);
              // },
              // ignore: unnecessary_null_comparison
              markers: controller.markers.toSet(),
              // markers: controller.markerbitmap.value != null
              //     ? {
              //         Marker(
              //           markerId: const MarkerId("1"),
              //           position: LatLng(
              //               controller.currentLocation.value!.latitude!,
              //               controller.currentLocation.value!.longitude!),
              //         )
              //       }
              //     : <Marker>{},
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
              // polygons: controller.buildPolygons(),
              zoomControlsEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              compassEnabled: true,
            ),

            // Obx(() {
            //   if (controller.shouldReloadMap.value) {
            //     // Reload map logic here
            //     // For example, you can create a GlobalKey for the map controller
            //     // and call `mapController.currentState.animateCamera(...)`
            //     controller.shouldReloadMap.value = false;
            //   }
            //   return Container(); // Or any other widget you need
            // }),
            // Positioned(
            //   top: 1,
            //   right: 50,
            //   child: FilterButton(
            //     size: 38,
            //     onFilterChanged:
            //         // setFilters,
            //         controller.setFilters,
            //     //   (jenisLahan, statusValidasi) {
            //     // controller.setFilters(jenisLahan, statusValidasi);
            //     // },
            //   ),
            // ),
          ]);
        }
      }),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => controller.addPatokan(context, null),
      //   child: Icon(Icons.add_location),
      // ),
    );
  }
}
