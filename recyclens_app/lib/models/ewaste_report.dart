import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';


// Model class for E-waste Report
class EWasteReportModel {
  String? id;
  String? userId; // ID of the user submitting the report
  String? category; // Category of e-waste (e.g., consumer electronics, appliances)
  String? description; // Detailed description of the e-waste
  String? location; //  Address of the e-waste location
  GeoPoint? coordinates; // Geographical coordinates (latitude & longitude)
  List<String>? imageUrls; // URLs of images of the e-waste
  Timestamp? createdAt; // Timestamp when the report was created
  String? status; // Status of the report (e.g., pending, collected, cancelled)

  EWasteReportModel({
    this.id,
    this.userId,
    this.category,
    this.description,
    this.location,
    this.coordinates,
    this.imageUrls,
    this.createdAt,
    this.status = 'pending', // Default status
  });

  // Factory constructor to create an EWasteReportModel from a map (for reading from Firestore)
  factory EWasteReportModel.fromMap(Map<String, dynamic> map, String? documentId) {
    return EWasteReportModel(
      id: documentId, // Use the provided documentId
      userId: map['userId'],
      category: map['category'],
      description: map['description'],
      location: map['location'],
      coordinates: map['coordinates'] != null
          ? map['coordinates'] as GeoPoint
          : null, // Handle null case
      imageUrls: map['imageUrls'] != null
          ? List<String>.from(map['imageUrls'])
          : [], // Handle null case
      createdAt: map['createdAt'] != null
          ? map['createdAt'] as Timestamp
          : null, // Handle null case
      status: map['status'] ??
          'pending', //Provide a default value if status is null
    );
  }

  // Convert the EWasteReportModel to a map (for writing to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'category': category,
      'description': description,
      'location': location,
      'coordinates': coordinates,
      'imageUrls': imageUrls,
      'createdAt': createdAt,
      'status': status,
    };
  }
}