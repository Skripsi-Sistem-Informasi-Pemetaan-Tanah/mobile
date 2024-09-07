import 'package:dipetakan/features/lahansaya/controllers/petavalidasi_controller.dart';
// import 'package:dipetakan/features/petalahan/controllers/petalahan_controller.dart';
import 'package:dipetakan/features/lahansaya/screens/widgets/filter_button.dart';
import 'package:dipetakan/features/tambahlahan/models/lahan_model.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class PetaTitikValidasi extends StatefulWidget {
  // final String mapId;
  final LahanModel lahan;

  const PetaTitikValidasi({super.key, required this.lahan});

  @override
  State<PetaTitikValidasi> createState() => _PetaTitikValidasiState();
}

class _PetaTitikValidasiState extends State<PetaTitikValidasi> {
  final PetaValidasiController controller = Get.put(PetaValidasiController());
  var markers = <Marker>{}.obs;

  // LatLng? _initialPosition;

  // late CameraPosition _initialCameraPosition;

  @override
  void initState() {
    super.initState();
    // controller.buildMarkers();
    controller.patokanList.value = widget.lahan.patokan;
    // controller._onMarkerTapped;
    // controller.setInitialCameraPosition(widget.mapId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: DColors.primary,
        title: const Text(
          'Validasi Koordinat',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontStyle: FontStyle.normal),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.currentLocation.value == null) {
          return const Center(child: Text("Loading"));
        } else {
          return Stack(
            children: <Widget>[
              Obx(() {
                return GoogleMap(
                  mapType: MapType.satellite,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          controller.currentLocation.value!.latitude!,
                          controller.currentLocation.value!.longitude!),
                      zoom: 20),
                  onMapCreated: (mapController) {
                    if (!controller.mapController.isCompleted) {
                      controller.mapController.complete(mapController);
                    }
                  },
                  markers: controller.buildMarkers(mapId: widget.lahan.id),
                  // controller.markers.toSet(),
                  polygons: controller.buildPolygons(mapId: widget.lahan.id),
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                  // scrollGesturesEnabled: true,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  compassEnabled: true,
                );
              }),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          left: DSizes.defaultSpace,
          right: DSizes.defaultSpace,
          bottom: DSizes.defaultSpace,
        ),
//         child: Obx(() {
//   bool isButtonDisabled = false;

//   return SizedBox(
//     width: double.infinity,
//     child: ElevatedButton(
//       onPressed: isButtonDisabled
//           ? null // Disable the button
//           : () {
//               controller.verifikasiKoordinat(widget.lahan);
//               isButtonDisabled = true; // Disable the button after it's clicked
//             },
//       child: const Text(DTexts.submit),
//     ),
//   );
// }),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              onPressed: () => controller.verifikasiKoordinat(widget.lahan),
              child: const Text(DTexts.submit)),
        ),
      ),

      // : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
