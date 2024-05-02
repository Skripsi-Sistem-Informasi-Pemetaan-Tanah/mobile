import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dipetakan/util/formatters/formatter.dart';

class UserModel {
  final String id;
  String fullName;
  final String username;
  final String email;
  String phoneNo;
  String profilePicture;

  UserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.phoneNo,
    required this.profilePicture,
  });

  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNo);

  static UserModel empty() => UserModel(
      id: '',
      fullName: '',
      username: '',
      email: '',
      phoneNo: '',
      profilePicture: '');

  ///Convert model to JSON structure for storing data in firebase
  Map<String, dynamic> toJson() {
    return {
      'NamaLengkap': fullName,
      'Username': username,
      'Email': email,
      'NoTelepon': phoneNo,
      'FotoProfil': profilePicture,
    };
  }

  ///Factory
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        fullName: data['NamaLengkap'] ?? '',
        username: data['Username'] ?? '',
        email: data['Email'] ?? '',
        phoneNo: data['NoTelepon'] ?? '',
        profilePicture: data['FotoProfil'] ?? '',
      );
    } else {
      // Handle the case where document.data() is null, maybe throw an exception or return null
      throw Exception('Document data is null');
    }
  }
}
