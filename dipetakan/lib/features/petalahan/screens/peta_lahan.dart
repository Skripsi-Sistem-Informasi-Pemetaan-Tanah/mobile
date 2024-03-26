// import 'dart:async';

import 'package:dipetakan/features/lahansaya/screens/widgets/search_bar.dart';
// import 'package:dipetakan/features/petalahan/screens/widgets/maps.dart';
// import 'package:dipetakan/features/petalahan/screens/widgets/maps_copy.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PetaLahanScreen extends StatefulWidget {
  const PetaLahanScreen({super.key});

  @override
  State<PetaLahanScreen> createState() => _PetaLahanScreenState();
}

class _PetaLahanScreenState extends State<PetaLahanScreen> {
  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(children: <Widget>[
        GoogleMap(
            mapType: MapType.satellite,
            initialCameraPosition:
                CameraPosition(target: _pGooglePlex, zoom: 15)),
        Positioned(child: CustomSearchBar()),
      ]),
    );
  }
}

// class PetaLahanScreen extends StatelessWidget {
//   const PetaLahanScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//         backgroundColor: Colors.grey,
//         body:
//         Stack(
//           children: <Widget>[
//             MapsSample2(),
//             Positioned(child: CustomSearchBar()),
//           ],
//         )
//     );
//   }
// }
