import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String condition;
  final List<String> images;
  final String postedBy;
  final Timestamp timestamp;
  final String location;
  final bool isSold;
  final bool negotiable;
  final List<String> likes;
  final int views;
  final bool chatEnabled;
  final String sellerName;
  final String sellerProfileImage;
  final String contactNumber;
  final List<String> deliveryOptions;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.condition,
    required this.images,
    required this.postedBy,
    required this.timestamp,
    required this.location,
    this.isSold = false,
    this.negotiable = false,
    this.likes = const [],
    this.views = 0,
    this.chatEnabled = true,
    this.sellerName = '',
    this.sellerProfileImage = '',
    this.contactNumber = '',
    this.deliveryOptions = const ['Pickup'],
  });

  factory ProductModel.fromMap(Map<String, dynamic> map, String docId) {
    return ProductModel(
      id: docId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      category: map['category'] ?? '',
      condition: map['condition'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      postedBy: map['postedBy'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
      location: map['location'] ?? '',
      isSold: map['isSold'] ?? false,
      negotiable: map['negotiable'] ?? false,
      likes: List<String>.from(map['likes'] ?? []),
      views: map['views'] ?? 0,
      chatEnabled: map['chatEnabled'] ?? true,
      sellerName: map['sellerName'] ?? '',
      sellerProfileImage: map['sellerProfileImage'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      deliveryOptions: List<String>.from(map['deliveryOptions'] ?? ['Pickup']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'condition': condition,
      'images': images,
      'postedBy': postedBy,
      'timestamp': timestamp,
      'location': location,
      'isSold': isSold,
      'negotiable': negotiable,
      'likes': likes,
      'views': views,
      'chatEnabled': chatEnabled,
      'sellerName': sellerName,
      'sellerProfileImage': sellerProfileImage,
      'contactNumber': contactNumber,
      'deliveryOptions': deliveryOptions,
    };
  }
}
