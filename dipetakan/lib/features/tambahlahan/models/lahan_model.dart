import 'package:cloud_firestore/cloud_firestore.dart';

class LahanModel {
  String id;
  String userId;
  String namaPemilik;
  String namaLahan;
  String jenisLahan;
  String deskripsiLahan;
  List<PatokanModel> patokan;
  List<VerifikasiModel> verifikasi;
  // String statusverifikasi;
  // int progress;
  Timestamp createdAt;
  Timestamp updatedAt;

  LahanModel({
    required this.id,
    required this.userId,
    required this.namaPemilik,
    required this.namaLahan,
    required this.jenisLahan,
    required this.deskripsiLahan,
    required this.patokan,
    required this.verifikasi,
    // this.statusverifikasi = 'Pending', // Default value
    // this.progress = 0, // Default value
    Timestamp? createdAt,
    Timestamp? updatedAt,
  })  : createdAt = createdAt ?? Timestamp.now(),
        updatedAt = updatedAt ?? Timestamp.now();

  String formatTimestamp(Timestamp timestamp) {
    // Convert the Firestore Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();
    // Convert DateTime to UTC time
    DateTime utcDateTime = dateTime.toUtc();
    // Format the UTC DateTime as an ISO 8601 string
    return utcDateTime.toIso8601String();
  }

  static LahanModel empty() => LahanModel(
      id: '',
      userId: '',
      namaPemilik: '',
      namaLahan: '',
      jenisLahan: '',
      deskripsiLahan: '',
      patokan: [],
      verifikasi: []);

  ///Convert model to JSON structure for storing data in Firestore
  Map<String, dynamic> toJson() {
    return {
      'map_id': id,
      'user_id': userId,
      'nama_pemilik': namaPemilik,
      'nama_lahan': namaLahan,
      'deskripsi_lahan': deskripsiLahan,
      'jenis_lahan': jenisLahan,
      'koordinat': patokan.map((patokan) => patokan.toJson()).toList(),
      'verifikasi':
          verifikasi.map((verifikasi) => verifikasi.toJson()).toList(),
      // 'StatusVerifikasi': statusverifikasi,
      // 'Progress': progress,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  Map<String, dynamic> toJsonPostgres() {
    // Convert Firestore Timestamps to ISO 8601 strings
    String createdAtIso8601 = formatTimestamp(createdAt);
    String updatedAtIso8601 = formatTimestamp(updatedAt);
    return {
      'map_id': id,
      'user_id': userId,
      'nama_pemilik': namaPemilik,
      'nama_lahan': namaLahan,
      'deskripsi_lahan': deskripsiLahan,
      'jenis_lahan': jenisLahan,
      'koordinat': patokan.map((patokan) => patokan.toJson()).toList(),
      'verifikasi':
          verifikasi.map((verifikasi) => verifikasi.toJsonPostgres()).toList(),
      // 'StatusVerifikasi': statusverifikasi,
      // 'Progress': progress,
      'created_at': createdAtIso8601,
      'updated_at': updatedAtIso8601,
    };
  }

  factory LahanModel.fromJson(Map<String, dynamic> json) {
    final patokanList = (json['koordinat'] as List<dynamic>)
        .map((patokanData) => PatokanModel.fromJson(patokanData))
        .toList();

    final verifikasiList = (json['verifikasi'] as List<dynamic>)
        .map((verifikasiData) => VerifikasiModel.fromJson(verifikasiData))
        .toList();

    return LahanModel(
      id: json['map_id'] ?? '',
      userId: json['user_id'] ?? '',
      namaPemilik: json['nama_pemilik'] ?? '',
      namaLahan: json['nama_lahan'] ?? '',
      deskripsiLahan: json['deskripsi_lahan'] ?? '',
      jenisLahan: json['jenis_lahan'] ?? '',
      patokan: patokanList,
      verifikasi: verifikasiList,
      createdAt: json['created_at'] != null
          ? (json['created_at'] is String
              ? Timestamp.fromDate(DateTime.parse(json['created_at']))
              : json['created_at'])
          : Timestamp.now(),
      updatedAt: json['updated_at'] != null
          ? (json['updated_at'] is String
              ? Timestamp.fromDate(DateTime.parse(json['updated_at']))
              : json['updated_at'])
          : Timestamp.now(),
    );
  }

  factory LahanModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      final patokanList = (data['koordinat'] as List<dynamic>)
          .map((patokanData) => PatokanModel.fromJson(patokanData))
          .toList();

      final verifikasiList = (data['verifikasi'] as List<dynamic>)
          .map((verifikasiData) => VerifikasiModel.fromJson(verifikasiData))
          .toList();

      return LahanModel(
        id: data['map_id'] ?? '',
        userId: data['user_id'] ?? '',
        namaPemilik: data['nama_pemilik'] ?? '',
        namaLahan: data['nama_lahan'] ?? '',
        deskripsiLahan: data['deskripsi_lahan'] ?? '',
        jenisLahan: data['jenis_lahan'] ?? '',
        patokan: patokanList,
        verifikasi: verifikasiList,
        createdAt: data['created_at'] != null
            ? (data['created_at'] is String
                ? Timestamp.fromDate(DateTime.parse(data['created_at']))
                : data['created_at'])
            : Timestamp.now(),
        updatedAt: data['updated_at'] != null
            ? (data['updated_at'] is String
                ? Timestamp.fromDate(DateTime.parse(data['updated_at']))
                : data['updated_at'])
            : Timestamp.now(),
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
      'local_path': localPath,
      'image': fotoPatokan,
      'koordinat': coordinates,
    };
  }

  factory PatokanModel.fromJson(Map<String, dynamic> json) {
    return PatokanModel(
      localPath: json['local_path'] ?? '',
      fotoPatokan: json['image'] ?? '',
      coordinates: json['koordinat'] ?? '',
    );
  }
}

class VerifikasiModel {
  String comentar;
  int statusverifikasi;
  int progress;
  Timestamp verifiedAt;

  VerifikasiModel({
    this.comentar = '',
    this.statusverifikasi = 0, // Default value
    this.progress = 0, // Default value
    // required this.verifiedAt
    Timestamp? verifiedAt,
  }) : verifiedAt = verifiedAt ?? Timestamp.now();

  ///Convert model to JSON structure for storing data in Firestore
  Map<String, dynamic> toJson() {
    return {
      'komentar': comentar,
      'status': statusverifikasi,
      'progress': progress,
      'updated_at': verifiedAt
    };
  }

  String formatTimestamp(Timestamp timestamp) {
    // Convert the Firestore Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();
    // Convert DateTime to UTC time
    DateTime utcDateTime = dateTime.toUtc();
    // Format the UTC DateTime as an ISO 8601 string
    return utcDateTime.toIso8601String();
  }

  Map<String, dynamic> toJsonPostgres() {
    // Convert Firestore Timestamp to ISO 8601 string
    String verifiedAtIso8601 = formatTimestamp(verifiedAt);

    // Create a map with the appropriate data types and formats
    return {
      'komentar': comentar,
      'status': statusverifikasi,
      'progress': progress,
      'updated_at': verifiedAtIso8601,
    };
  }

  factory VerifikasiModel.fromJson(Map<String, dynamic> json) {
    return VerifikasiModel(
      comentar: json['komentar'] ?? '',
      statusverifikasi: json['status'] ?? '',
      progress: json['progress'] ?? 0,
      verifiedAt: json['updated_at'] != null
          ? (json['updated_at'] is String
              ? Timestamp.fromDate(DateTime.parse(json['updated_at']))
              : json['updated_at'])
          : Timestamp.now(),
    );
  }
}
