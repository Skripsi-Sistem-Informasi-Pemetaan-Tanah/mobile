import 'package:cloud_firestore/cloud_firestore.dart';

class LahanModel {
  String id;
  String namaLahan;
  String jenisLahan;
  String deskripsiLahan;
  List<PatokanModel> patokan;
  String statusverifikasi;
  int progress;
  Timestamp createdAt;
  Timestamp updatedAt;

  LahanModel({
    required this.id,
    required this.namaLahan,
    required this.jenisLahan,
    required this.deskripsiLahan,
    required this.patokan,
    this.statusverifikasi = 'Pending', // Default value
    this.progress = 0, // Default value
    Timestamp? createdAt,
    Timestamp? updatedAt,
  })  : createdAt = createdAt ?? Timestamp.now(),
        updatedAt = updatedAt ?? Timestamp.now();

  static LahanModel empty() => LahanModel(
      id: '', namaLahan: '', jenisLahan: '', deskripsiLahan: '', patokan: []);

  ///Convert model to JSON structure for storing data in Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'NamaLahan': namaLahan,
      'DeskripsiLahan': deskripsiLahan,
      'JenisLahan': jenisLahan,
      'Patokan': patokan.map((patokan) => patokan.toJson()).toList(),
      'StatusVerifikasi': statusverifikasi,
      'Progress': progress,
      'Created_at': createdAt,
      'Updated_at': updatedAt,
    };
  }

  factory LahanModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      final patokanList = (data['Patokan'] as List<dynamic>)
          .map((patokanData) => PatokanModel.fromJson(patokanData))
          .toList();

      return LahanModel(
        id: data['id'] ?? '',
        namaLahan: data['NamaLahan'] ?? '',
        deskripsiLahan: data['DeskripsiLahan'] ?? '',
        jenisLahan: data['JenisLahan'] ?? '',
        patokan: patokanList,
        statusverifikasi: data['StatusVerifikasi'],
        progress: data['Progress'],
        createdAt: data['Created_at'],
        updatedAt: data['Updated_at'],
      );
    } else {
      return LahanModel.empty();
    }
  }
}

class PatokanModel {
  final String localPath;
  final String fotoPatokan;
  final String coordinates;

  PatokanModel({
    required this.localPath,
    required this.fotoPatokan,
    required this.coordinates,
  });

  ///Convert model to JSON structure for storing data in Firestore
  Map<String, dynamic> toJson() {
    return {
      'LocalPath': localPath,
      'FotoPatokan': fotoPatokan,
      'Coordinates': coordinates,
    };
  }

  factory PatokanModel.fromJson(Map<String, dynamic> json) {
    return PatokanModel(
      localPath: json['LocalPath'] ?? '',
      fotoPatokan: json['FotoPatokan'] ?? '',
      coordinates: json['Coordinates'] ?? '',
    );
  }
}
