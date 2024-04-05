import 'dart:async';
import 'dart:convert';

import 'package:dipetakan/features/lahansaya/screens/widgets/search_bar.dart';
import 'package:dipetakan/features/petalahan/screens/deskripsi_lahan_lain.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class PetaLahanScreen extends StatefulWidget {
  const PetaLahanScreen({super.key});

  @override
  State<PetaLahanScreen> createState() => _PetaLahanScreenState();
}

class _PetaLahanScreenState extends State<PetaLahanScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor markerbitmap = BitmapDescriptor.defaultMarker;

  LatLng initialLocation = const LatLng(-6.885786, 109.681040);
  LocationData? currentLocation;
  Location location = Location();

  List<LatLng> polygonPoint = const [
    LatLng(-6.885293, 109.680546),
    LatLng(-6.885351, 109.680754),
    LatLng(-6.885668, 109.680717),
    LatLng(-6.885664, 109.680526),
  ];

  List<dynamic> lahanData = [];

  @override
  void initState() {
    getCurrentLocation();
    fetchData();
    addCustomMarker();
    super.initState();
  }

  void getCurrentLocation() async {
    try {
      final LocationData locationData = await location.getLocation();
      setState(() {
        currentLocation = locationData;
      });
    } catch (error) {
      print("Error getting location: $error");
    }
  }

  // Future<void> fetchData() async {
  //   final response = await http.get(Uri.parse('assets/sampledata/lahan.json'));

  //   if (response.statusCode == 200) {
  //     final jsonData = json.decode(response.body);
  //     setState(() {
  //       lahanData = jsonData['lahan'];
  //     });
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }

  Future<void> fetchData() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/sampledata/lahan.json');
    setState(() {
      lahanData = json.decode(data)['lahan'];
    });
  }

  Future<void> addCustomMarker() async {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), 'assets/images/location_icon.png')
        .then((markerIcon) {
      setState(() {
        markerbitmap = markerIcon;
      });
    });
  }

  Set<Polygon> _buildPolygons() {
    Set<Polygon> polygons = {};

    for (var lahan in lahanData) {
      List<LatLng> polygonPoints = [];

      for (var patokan in lahan['patokan']) {
        var coordinates = patokan['koordinat_patokan']
            .split(',')
            .map((coord) => double.parse(coord.trim()))
            .toList();
        polygonPoints.add(LatLng(coordinates[0], coordinates[1]));
      }

      polygons.add(Polygon(
        polygonId: PolygonId(lahan['nama_lahan']),
        points: polygonPoints,
        strokeColor: Colors.yellow,
        strokeWidth: 2,
        fillColor: Colors.yellow.withOpacity(0.2),
      ));
    }

    return polygons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            //currentLocation == null
            //     ? const Center(child: Text("Loading"))
            // :
            Stack(children: <Widget>[
      // FutureBuilder(
      //   future: addCustomMarker(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       return GoogleMap(
      //         mapType: MapType.satellite,
      //         initialCameraPosition:
      //             CameraPosition(target: initialLocation, zoom: 15),
      //         onMapCreated: (controller) {
      //           _controller.complete(controller);
      //         },
      //         markers: {
      //           Marker(
      //             markerId: const MarkerId("1"),
      //             position: initialLocation,
      //             icon: markerbitmap,
      //           )
      //         },
      //       );
      //     } else {
      //       return Center(child: CircularProgressIndicator());
      //     }
      //   },
      // ),
      if (currentLocation == null)
        const Center(child: Text("Loading"))
      else
        GoogleMap(
          mapType: MapType.satellite,
          initialCameraPosition: CameraPosition(
              target: LatLng(
                  currentLocation!.latitude!, currentLocation!.longitude!),
              zoom: 20),
          onMapCreated: (controller) {
            _controller.complete(controller);
          },
          // ignore: unnecessary_null_comparison
          markers: markerbitmap != null
              ? {
                  Marker(
                    markerId: const MarkerId("1"),
                    position: LatLng(currentLocation!.latitude!,
                        currentLocation!.longitude!),
                    // icon: markerbitmap,
                    // infoWindow:
                  )
                }
              : Set<Marker>(),
          circles: {
            Circle(
                circleId: const CircleId("1"),
                center: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
                radius: 25,
                strokeWidth: 2,
                strokeColor: Colors.yellow,
                fillColor: Colors.yellow.withOpacity(0.2)),
          },
          polygons: _buildPolygons(),
          // {
          //   Polygon(
          //     polygonId: const PolygonId("1"),
          //     points: polygonPoint,
          //     strokeWidth: 2,
          //     strokeColor: Colors.yellow,
          //     fillColor: Colors.yellow.withOpacity(0.2),
          //     consumeTapEvents: true,
          //     onTap: () async {
          //       await showDialog<void>(
          //           context: context,
          //           builder: (context) => const AlertDialog(
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.all(
          //                   Radius.circular(
          //                     20.0,
          //                   ),
          //                 ),
          //               ),
          //               contentPadding: EdgeInsets.only(
          //                 top: 0,
          //               ),
          //               content: DeskripsiLahanLain()));
          //     },
          //   )
          // },
          zoomControlsEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          compassEnabled: true,
        ),
      const Positioned(child: CustomSearchBar()),
    ]));
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
