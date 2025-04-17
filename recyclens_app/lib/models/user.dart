import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id; 
  final String name;
  final String phone;
  final String location;
  final String age;
  final String gender;
  final String userType;
  final String? imageUrl;

  UserModel({
    this.id = '',
    required this.name,
    required this.phone,
    required this.location,
    required this.age,
    required this.gender,
    required this.userType,
    this.imageUrl,
  });

  /// Convert object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'location': location,
      'age': age,
      'gender': gender,
      'userType': userType,
      'imageUrl': imageUrl,
    };
  }

  /// Convert Firestore snapshot to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map, {String id = ''}) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      location: map['location'] ?? '',
      age: map['age'] ?? '',
      gender: map['gender'] ?? '',
      userType: map['userType'] ?? '',
      imageUrl: map['imageUrl'],
    );
  }

  /// Firestore converter (optional but recommended for strong typing)
  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return UserModel.fromMap(data, id: snapshot.id);
  }

  Map<String, dynamic> toFirestore() => toMap();
}
