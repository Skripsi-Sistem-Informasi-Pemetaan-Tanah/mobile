import 'package:dipetakan/features/petalahan/controllers/petalahan_controller.dart';
import 'package:dipetakan/features/petalahan/screens/widgets/filter_button_petalahan.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class PetaLahanScreen extends StatefulWidget {
  const PetaLahanScreen({super.key});

  @override
  State<PetaLahanScreen> createState() => _PetaLahanScreenState();
}

class _PetaLahanScreenState extends State<PetaLahanScreen> {
  final controller = Get.put(PetaLahanController());

  @override
  void initState() {
    controller.setFilters([], []);
    super.initState();
  }

  List<String> selectedJenisLahan = [];
  List<int> selectedStatusValidasi = [];

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
              markers: controller.markers.toSet(),
              polygons: controller.buildPolygons(),
              zoomControlsEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              compassEnabled: true,
            ),
            Positioned(
              top: 1,
              right: 50,
              child: FilterButtonPetaLahan(
                size: 38,
                onFilterChanged: controller.setFilters,
              ),
            ),
          ]);
        }
      }),
    );
  }
}
