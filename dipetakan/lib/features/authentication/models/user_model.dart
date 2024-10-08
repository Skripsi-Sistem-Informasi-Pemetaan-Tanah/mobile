import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dipetakan/util/formatters/formatter.dart';

class UserModel {
  final String id;
  String fullName;
  String username;
  String email;
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
      'user_id': id,
      'nama_lengkap': fullName,
      'username': username,
      'email': email,
      'NoTelepon': phoneNo,
      'FotoProfil': profilePicture,
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        fullName: data['nama_lengkap'] ?? '',
        username: data['username'] ?? '',
        email: data['email'] ?? '',
        phoneNo: data['NoTelepon'] ?? '',
        profilePicture: data['FotoProfil'] ?? '',
      );
    } else {
      return UserModel.empty();
    }
  }
}
