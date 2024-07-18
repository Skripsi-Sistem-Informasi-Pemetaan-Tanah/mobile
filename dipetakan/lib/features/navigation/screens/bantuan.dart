// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dipetakan/util/constants/api_constants.dart';
import 'package:dipetakan/util/constants/colors.dart';
import 'package:dipetakan/util/constants/sizes.dart';
import 'package:dipetakan/util/constants/text_strings.dart';
import 'package:dipetakan/util/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BantuanScreen extends StatefulWidget {
  const BantuanScreen({super.key});

  @override
  State<BantuanScreen> createState() => _BantuanScreenState();
}

class _BantuanScreenState extends State<BantuanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: DColors.primary,
        title: const Text(
          'Bantuan',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontStyle: FontStyle.normal),
        ),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(DSizes.defaultSpace),
          child: Column(children: <Widget>[
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //       onPressed: _fetchDataFromPostgresql,
            //       child: Text(DTexts.tContinue)),
            // ),
          ]),
        ),
      ),
    );
  }
}

// Future<void> _fetchDataFromPostgresql() async {
//   final userId = AuthenticationRepository.instance.authUser?.uid;
//   var url = Uri.parse('$baseUrl/getAllLahanbyUserId/$userId');
//   var response = await http.get(url);

//   if (response.statusCode == 200) {
//     Map<String, dynamic> responseData = json.decode(response.body);

//     final FirebaseFirestore db = FirebaseFirestore.instance;

//     // Using a batch write to Firestore for efficiency
//     WriteBatch batch = db.batch();

//     // Update data in Firestore
//     if (responseData.containsKey('lahan')) {
//       List<dynamic> lahanData = responseData['lahan'];
//       for (var lahan in lahanData) {
//         String userId = lahan['user_id'];
//         String mapId = lahan['map_id'];
//         DocumentReference lahanRef = db.collection('Lahan').doc(mapId);

//         // Convert updated_at in lahan to Firestore Timestamp
//         if (lahan.containsKey('updated_at')) {
//           String updatedAtString = lahan['updated_at'];
//           DateTime updatedAt = DateTime.parse(updatedAtString);
//           Timestamp updatedAtTimestamp = Timestamp.fromDate(updatedAt);
//           lahan['updated_at'] = updatedAtTimestamp;
//         }

//         Map<String, dynamic> lahanDataToUpdate = {
//           'koordinat': lahan.containsKey('koordinat')
//               ? List<Map<String, dynamic>>.from(lahan['koordinat'])
//               : [],
//           'verifikasi': lahan.containsKey('verifikasi')
//               ? List<Map<String, dynamic>>.from(lahan['verifikasi'])
//               : [],
//           'updated_at': lahan['updated_at']
//         };

//         // Convert updated_at in verifikasi to Firestore Timestamp
//         if (lahan.containsKey('verifikasi')) {
//           List<Map<String, dynamic>> verifikasiList =
//               List<Map<String, dynamic>>.from(lahan['verifikasi']);
//           for (var verifikasi in verifikasiList) {
//             if (verifikasi.containsKey('updated_at')) {
//               String verifikasiUpdatedAtString = verifikasi['updated_at'];
//               DateTime verifikasiUpdatedAt =
//                   DateTime.parse(verifikasiUpdatedAtString);
//               Timestamp verifikasiUpdatedAtTimestamp =
//                   Timestamp.fromDate(verifikasiUpdatedAt);
//               verifikasi['updated_at'] = verifikasiUpdatedAtTimestamp;
//             }
//           }
//           lahanDataToUpdate['verifikasi'] = verifikasiList;
//         }

//         batch.set(lahanRef, lahanDataToUpdate, SetOptions(merge: true));

//         // Also update in the user-specific collection
//         DocumentReference userLahanRef =
//             db.collection('Users').doc(userId).collection('Lahan').doc(mapId);
//         batch.set(userLahanRef, lahanDataToUpdate, SetOptions(merge: true));
//       }
//     }

//     // Commit the batch write
//     await batch.commit();
//     DLoaders.successSnackBar(
//         title: 'Success', message: 'Data updated successfully in Firestore');
//   } else {
//     DLoaders.errorSnackBar(title: 'Fail', message: 'Failed to fetch data');
//   }
// }

// Future<void> _fetchDataFromPostgresql() async {
//   // Check server and database connection
//   final serverurl =
//       Uri.parse('http://192.168.1.34:5000/checkConnectionDatabase');
//   final http.Response serverresponse = await http.get(serverurl);
//   if (serverresponse.statusCode != 200
//       // ||
//       //     json.decode(serverresponse.body)['connected'] != true
//       ) {
//     DLoaders.errorSnackBar(
//         title: 'Oh Snap!', message: 'Server or Database is not connected');
//     // DFullScreenLoader.stopLoading();
//     return;
//   }

//   var url = Uri.parse('$baseUrl/getAllLahan');
//   var response = await http.get(url);

//   if (response.statusCode == 200) {
//     Map<String, dynamic> responseData = json.decode(response.body);

//     final FirebaseFirestore db = FirebaseFirestore.instance;

//     // Using a batch write to Firestore for efficiency
//     WriteBatch batch = db.batch();

//     // Update data in Firestore
//     if (responseData.containsKey('lahan')) {
//       List<dynamic> lahanData = responseData['lahan'];
//       for (var lahan in lahanData) {
//         String userId = lahan['user_id'];
//         String mapId = lahan['map_id'];
//         DocumentReference lahanRef = db.collection('Lahan').doc(mapId);

//         // Convert updated_at in lahan to Firestore Timestamp
//         if (lahan.containsKey('updated_at')) {
//           String updatedAtString = lahan['updated_at'];
//           DateTime updatedAt = DateTime.parse(updatedAtString);
//           Timestamp updatedAtTimestamp = Timestamp.fromDate(updatedAt);
//           lahan['updated_at'] = updatedAtTimestamp;
//         }

//         Map<String, dynamic> lahanDataToUpdate = {
//           'koordinat': lahan.containsKey('koordinat')
//               ? List<Map<String, dynamic>>.from(lahan['koordinat'])
//               : [],
//           'verifikasi': lahan.containsKey('verifikasi')
//               ? List<Map<String, dynamic>>.from(lahan['verifikasi'])
//               : [],
//           'updated_at': lahan['updated_at']
//         };

//         // Convert updated_at in verifikasi to Firestore Timestamp
//         if (lahan.containsKey('verifikasi')) {
//           List<Map<String, dynamic>> verifikasiList =
//               List<Map<String, dynamic>>.from(lahan['verifikasi']);
//           for (var verifikasi in verifikasiList) {
//             if (verifikasi.containsKey('updated_at')) {
//               String verifikasiUpdatedAtString = verifikasi['updated_at'];
//               DateTime verifikasiUpdatedAt =
//                   DateTime.parse(verifikasiUpdatedAtString);
//               Timestamp verifikasiUpdatedAtTimestamp =
//                   Timestamp.fromDate(verifikasiUpdatedAt);
//               verifikasi['updated_at'] = verifikasiUpdatedAtTimestamp;
//             }
//           }
//           lahanDataToUpdate['verifikasi'] = verifikasiList;
//         }

//         batch.set(lahanRef, lahanDataToUpdate, SetOptions(merge: true));

//         // Also update in the user-specific collection
//         DocumentReference userLahanRef =
//             db.collection('Users').doc(userId).collection('Lahan').doc(mapId);
//         batch.set(userLahanRef, lahanDataToUpdate, SetOptions(merge: true));
//       }
//     }

//     // Commit the batch write
//     await batch.commit();
//     DLoaders.successSnackBar(
//         title: 'Success', message: 'Data updated successfully in Firestore');
//   } else {
//     DLoaders.errorSnackBar(title: 'Fail', message: 'Failed to fetch data');
//   }
// }

Future<void> _fetchDataFromPostgresql() async {
  // Check server and database connection
  final serverurl = Uri.parse('$baseUrl/checkConnectionDatabase');
  final http.Response serverresponse = await http.get(serverurl);

  if (serverresponse.statusCode != 200) {
    DLoaders.errorSnackBar(
      title: 'Oh Snap!',
      message: 'Server or Database is not connected',
    );
    return;
  }

  var url = Uri.parse('$baseUrl/getAllLahan');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = json.decode(response.body);

    final FirebaseFirestore db = FirebaseFirestore.instance;
    WriteBatch batch = db.batch();

    if (responseData.containsKey('data') &&
        responseData['data'].containsKey('lahan')) {
      List<dynamic> lahanData = responseData['data']['lahan'];

      for (var lahan in lahanData) {
        String userId = lahan['user_id'];
        String mapId = lahan['map_id'];
        DocumentReference lahanRef = db.collection('Lahan').doc(mapId);
        DocumentReference userLahanRef =
            db.collection('Users').doc(userId).collection('Lahan').doc(mapId);

        // Convert updated_at to Firestore Timestamp
        if (lahan.containsKey('updated_at')) {
          String updatedAtString = lahan['updated_at'];
          Timestamp updatedAt = Timestamp.fromMillisecondsSinceEpoch(
              DateTime.parse(updatedAtString).millisecondsSinceEpoch);
          lahan['updated_at'] = updatedAt;
        }

        Map<String, dynamic> lahanDataToUpdate = {
          'koordinat': lahan.containsKey('koordinat') ? lahan['koordinat'] : [],
          'verifikasi':
              lahan.containsKey('verifikasi') ? lahan['verifikasi'] : [],
          'updated_at': lahan['updated_at'],
        };

        // Update verifikasi 'updated_at' to Firestore Timestamp
        if (lahan.containsKey('verifikasi')) {
          List<dynamic> verifikasiList = lahan['verifikasi'];
          for (var verifikasi in verifikasiList) {
            if (verifikasi.containsKey('updated_at')) {
              String verifikasiUpdatedAtString = verifikasi['updated_at'];
              Timestamp verifikasiUpdatedAt =
                  Timestamp.fromMillisecondsSinceEpoch(
                      DateTime.parse(verifikasiUpdatedAtString)
                          .millisecondsSinceEpoch);
              verifikasi['updated_at'] = verifikasiUpdatedAt;
            }
          }
          lahanDataToUpdate['verifikasi'] = verifikasiList;
        }

        batch.set(lahanRef, lahanDataToUpdate, SetOptions(merge: true));
        batch.set(userLahanRef, lahanDataToUpdate, SetOptions(merge: true));
      }
    }

    await batch.commit();
    DLoaders.successSnackBar(
      title: 'Success',
      message: 'Data updated successfully in Firestore',
    );
  } else {
    DLoaders.errorSnackBar(
      title: 'Fail',
      message: 'Failed to fetch data',
    );
  }
}
