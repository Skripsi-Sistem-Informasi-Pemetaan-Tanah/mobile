// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsSample2 extends StatefulWidget {
  const MapsSample2({super.key});

  @override
  State<MapsSample2> createState() => _MapsSample2State();
}

class _MapsSample2State extends State<MapsSample2> {
  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GoogleMap(
          initialCameraPosition: CameraPosition(target: _pGooglePlex, zoom: 2)),
    );
  }
}
