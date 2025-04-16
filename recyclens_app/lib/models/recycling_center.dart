import 'package:cloud_firestore/cloud_firestore.dart';

class RecyclingCenterModel {
  final String id; // Unique ID for the recycling center
  final String name; // Name of the recycling center
  final String description; // A short description of the center
  final String location; // Physical address or general location
  final GeoPoint coordinates; // Geographical coordinates (latitude & longitude)
  final String contactNumber; // Contact number for the center
  final String email; // Email address for the center
  final List<String> services; // List of services offered (e.g., e-waste, paper, plastic)
  final List<String> acceptedMaterials; // Types of materials accepted (e.g., glass, metal)
  final String operatingHours; // Operating hours (e.g., "Mon-Fri: 9AM - 6PM")
  final bool isActive; // Whether the center is active or not
  final String imageUrl; // Image or logo URL for the center
  final String websiteUrl; // Optional URL to the website of the recycling center
  final Timestamp createdAt; // Date when the center was added
  final Timestamp updatedAt; // Date when the center information was last updated
  final List<int> ratings; // List of ratings (e.g., 1-5 stars)
  final double averageRating; // Calculated average rating from the list of ratings

  RecyclingCenterModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.coordinates,
    required this.contactNumber,
    required this.email,
    required this.services,
    required this.acceptedMaterials,
    required this.operatingHours,
    this.isActive = true,
    required this.imageUrl,
    required this.websiteUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.ratings,
    required this.averageRating,
  });

  factory RecyclingCenterModel.fromMap(Map<String, dynamic> map, String docId) {
    // Calculate average rating if ratings list is not empty
    double avgRating = map['ratings'] != null && map['ratings'].isNotEmpty
        ? map['ratings'].reduce((a, b) => a + b) / map['ratings'].length
        : 0;

    return RecyclingCenterModel(
      id: docId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      coordinates: map['coordinates'] ?? GeoPoint(0, 0),
      contactNumber: map['contactNumber'] ?? '',
      email: map['email'] ?? '',
      services: List<String>.from(map['services'] ?? []),
      acceptedMaterials: List<String>.from(map['acceptedMaterials'] ?? []),
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
      'services': services,
      'acceptedMaterials': acceptedMaterials,
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
