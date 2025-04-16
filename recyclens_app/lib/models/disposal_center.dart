import 'package:cloud_firestore/cloud_firestore.dart';

class DisposalCenterModel {
  final String id;
  final String name;
  final String description;
  final String location;
  final GeoPoint coordinates;
  final String contactNumber;
  final String email;
  final List<String> disposalMethods; // e.g., incineration, composting
  final List<String> acceptedWasteTypes; // e.g., organic, hazardous, plastic
  final String operatingHours;
  final bool isActive;
  final String imageUrl;
  final String websiteUrl;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final List<int> ratings;
  final double averageRating;

  DisposalCenterModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.coordinates,
    required this.contactNumber,
    required this.email,
    required this.disposalMethods,
    required this.acceptedWasteTypes,
    required this.operatingHours,
    this.isActive = true,
    required this.imageUrl,
    required this.websiteUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.ratings,
    required this.averageRating,
  });

  factory DisposalCenterModel.fromMap(Map<String, dynamic> map, String docId) {
    double avgRating = map['ratings'] != null && map['ratings'].isNotEmpty
        ? map['ratings'].reduce((a, b) => a + b) / map['ratings'].length
        : 0;

    return DisposalCenterModel(
      id: docId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      coordinates: map['coordinates'] ?? GeoPoint(0, 0),
      contactNumber: map['contactNumber'] ?? '',
      email: map['email'] ?? '',
      disposalMethods: List<String>.from(map['disposalMethods'] ?? []),
      acceptedWasteTypes: List<String>.from(map['acceptedWasteTypes'] ?? []),
      operatingHours: map['operatingHours'] ?? '',
      isActive: map['isActive'] ?? true,
      imageUrl: map['imageUrl'] ?? '',
      websiteUrl: map['websiteUrl'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
      updatedAt: map['updatedAt'] ?? Timestamp.now(),
      ratings: List<int>.from(map['ratings'] ?? []),
      averageRating: avgRating,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'location': location,
      'coordinates': coordinates,
      'contactNumber': contactNumber,
      'email': email,
      'disposalMethods': disposalMethods,
      'acceptedWasteTypes': acceptedWasteTypes,
      'operatingHours': operatingHours,
      'isActive': isActive,
      'imageUrl': imageUrl,
      'websiteUrl': websiteUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'ratings': ratings,
      'averageRating': averageRating,
    };
  }
}
