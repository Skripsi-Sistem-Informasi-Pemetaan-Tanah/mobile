import 'package:dipetakan/features/lahansaya/controllers/petafotopatokan_controller.dart';
// import 'package:dipetakan/features/petalahan/controllers/petalahan_controller.dart';
import 'package:dipetakan/features/lahansaya/screens/widgets/filter_button.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class PetaRevisiFotoPatokan extends StatefulWidget {
  final String mapId;

  const PetaRevisiFotoPatokan({super.key, required this.mapId});

  @override
  State<PetaRevisiFotoPatokan> createState() => _PetaRevisiFotoPatokanState();
}

class _PetaRevisiFotoPatokanState extends State<PetaRevisiFotoPatokan> {
  final PetaFotoPatokanController controller =
      Get.put(PetaFotoPatokanController());

  // LatLng? _initialPosition;

  // late CameraPosition _initialCameraPosition;

  // @override
  // void initState() {
  //   super.initState();
  //   // controller.setInitialCameraPosition(widget.mapId);
  // }

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
      body: Obx(() {
        if (controller.currentLocation.value == null) {
          return const Center(child: Text("Loading"));
        } else {
          return Stack(
            children: <Widget>[
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
                  controller.update();
                },
                markers: controller.buildMarkers(mapId: widget.mapId),
                polygons: controller.buildPolygons(mapId: widget.mapId),
                zoomControlsEnabled: true,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                compassEnabled: true,
              ),
              Positioned(
                top: 1,
                right: 50,
                child: FilterButton(
                  size: 38,
                  onFilterChanged: controller.setFilters,
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
