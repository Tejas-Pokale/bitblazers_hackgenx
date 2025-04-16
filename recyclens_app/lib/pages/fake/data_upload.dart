import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recyclens_app/models/disposal_center.dart';
import 'package:recyclens_app/models/recycling_center.dart';

class UploadDisposalCenters extends StatelessWidget {
  const UploadDisposalCenters({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Disposal Centers")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final collection = FirebaseFirestore.instance.collection('recycling_centers');
            final now = Timestamp.now();

            List<RecyclingCenterModel> dummyRecyclingCenters = [
  RecyclingCenterModel(
    id: 'RC001',
    name: 'EcoPoint Amravati',
    description: 'Your local hub for responsible recycling in Amravati.',
    location: 'Near Vidya Bharati College, Amravati',
    coordinates: const GeoPoint(20.9374, 77.7503), // Approximate Amravati coordinate
    contactNumber: '+91 9876543210',
    email: 'ecopoint.amt@gmail.com',
    services: ['Plastic', 'Paper', 'Cardboard'],
    acceptedMaterials: ['PET bottles', 'Newspapers', 'Cardboard boxes'],
    operatingHours: 'Mon-Sat: 10 AM - 6 PM',
    isActive: true,
    imageUrl: 'https://via.placeholder.com/150/8FBC8F/FFFFFF?Text=EcoPoint',
    websiteUrl: 'https://www.ecopointamravati.com',
    createdAt: Timestamp.fromDate(DateTime(2024, 1, 20)),
    updatedAt: Timestamp.now(),
    ratings: [4, 5, 4],
    averageRating: 4.33,
  ),
  RecyclingCenterModel(
    id: 'RC002',
    name: 'Green Solutions Center',
    description: 'Dedicated to creating a greener Amravati through recycling.',
    location: 'MIDC Area, Amravati',
    coordinates: const GeoPoint(20.9258, 77.7782), // Approximate Amravati coordinate
    contactNumber: '+91 8765432109',
    email: 'greensolutions.amt@yahoo.com',
    services: ['E-waste', 'Metal', 'Glass'],
    acceptedMaterials: ['Computers', 'Aluminum cans', 'Glass bottles'],
    operatingHours: 'Tue-Sun: 11 AM - 7 PM',
    isActive: true,
    imageUrl: 'https://via.placeholder.com/150/008000/FFFFFF?Text=GreenSol',
    websiteUrl: 'https://www.greensolutionsamravati.in',
    createdAt: Timestamp.fromDate(DateTime(2023, 11, 10)),
    updatedAt: Timestamp.now(),
    ratings: [3, 4, 3, 5],
    averageRating: 3.75,
  ),
  RecyclingCenterModel(
    id: 'RC003',
    name: 'Amravati Recycle Hub',
    description: 'Your trusted partner for all your recycling needs.',
    location: 'Near Railway Station, Amravati',
    coordinates: const GeoPoint(20.9328, 77.7709), // Approximate Amravati coordinate
    contactNumber: '+91 7654321098',
    email: 'amravaticycle@rediffmail.com',
    services: ['Paper', 'Plastic'],
    acceptedMaterials: ['Magazines', 'Plastic bags', 'PET bottles'],
    operatingHours: 'Mon-Fri: 9:30 AM - 5:30 PM',
    isActive: true,
    imageUrl: 'https://via.placeholder.com/150/4682B4/FFFFFF?Text=AmravatiHub',
    websiteUrl: 'google.com',
    createdAt: Timestamp.fromDate(DateTime(2024, 3, 1)),
    updatedAt: Timestamp.now(),
    ratings: [4, 4, 5, 4, 5],
    averageRating: 4.4,
  ),
  RecyclingCenterModel(
    id: 'RC004',
    name: 'Sustainable Amravati',
    description: 'Working towards a sustainable future for Amravati.',
    location: 'Opposite District Collector Office, Amravati',
    coordinates: const GeoPoint(20.9350, 77.7750), // Approximate Amravati coordinate
    contactNumber: '+91 6543210987',
    email: 'sustainable.amt@outlook.com',
    services: ['E-waste', 'Battery Recycling'],
    acceptedMaterials: ['Mobile phones', 'Laptops', 'Car batteries', 'AA batteries'],
    operatingHours: 'Wed-Sun: 10 AM - 7 PM',
    isActive: true,
    imageUrl: 'https://via.placeholder.com/150/3CB371/FFFFFF?Text=SustainAMT',
    websiteUrl: 'https://www.sustainableamravati.org',
    createdAt: Timestamp.fromDate(DateTime(2023, 12, 15)),
    updatedAt: Timestamp.now(),
    ratings: [5, 4, 5, 5],
    averageRating: 4.75,
  ),
  RecyclingCenterModel(
    id: 'RC005',
    name: 'City Recycling Center',
    description: 'Serving the recycling needs of the entire Amravati city.',
    location: 'Near Bus Stand, Amravati',
    coordinates: const GeoPoint(20.9280, 77.7650), // Approximate Amravati coordinate
    contactNumber: '+91 5432109876',
    email: 'cityrecycle.amt@gmail.com',
    services: ['Plastic', 'Metal'],
    acceptedMaterials: ['HDPE containers', 'Copper wires', 'Aluminum foil'],
    operatingHours: 'Mon-Sat: 11 AM - 6 PM',
    isActive: true,
    imageUrl: 'https://via.placeholder.com/150/6495ED/FFFFFF?Text=CityRecycle',
     websiteUrl: 'google.com',
    createdAt: Timestamp.fromDate(DateTime(2024, 2, 10)),
    updatedAt: Timestamp.now(),
    ratings: [3, 3, 4, 3],
    averageRating: 3.25,
  ),
  RecyclingCenterModel(
    id: 'RC006',
    name: 'Janseva Recycling Kendra',
    description: 'A community-driven initiative for a cleaner Amravati.',
    location: 'Gandhi Chowk, Amravati',
    coordinates: const GeoPoint(20.9345, 77.7720), // Approximate Amravati coordinate
    contactNumber: '+91 9988776655',
    email: 'jansevarecycle@gmail.com',
    services: ['Paper', 'Cardboard', 'Glass'],
    acceptedMaterials: ['Old books', 'Corrugated boxes', 'Clear glass jars'],
    operatingHours: 'Tue-Sun: 9 AM - 5 PM',
    isActive: true,
    imageUrl: 'https://via.placeholder.com/150/D2691E/FFFFFF?Text=Janseva',
     websiteUrl: 'google.com',
    createdAt: Timestamp.fromDate(DateTime(2023, 10, 25)),
    updatedAt: Timestamp.now(),
    ratings: [4, 5, 5, 4, 4],
    averageRating: 4.4,
  ),
  RecyclingCenterModel(
    id: 'RC007',
    name: 'Hariom Recycling Point',
    description: 'Efficient and reliable recycling services in Amravati.',
    location: 'Shastri Nagar, Amravati',
    coordinates: const GeoPoint(20.9400, 77.7680), // Approximate Amravati coordinate
    contactNumber: '+91 8899776655',
    email: 'hariomrecycle@yahoo.co.in',
    services: ['Metal', 'Plastic', 'E-waste'],
    acceptedMaterials: ['Iron scraps', 'PVC pipes', 'Mobile chargers'],
    operatingHours: 'Mon-Sat: 10:30 AM - 6:30 PM',
    isActive: true,
    imageUrl: 'https://via.placeholder.com/150/BDB76B/FFFFFF?Text=Hariom',
     websiteUrl: 'google.com',
    createdAt: Timestamp.fromDate(DateTime(2024, 4, 1)),
    updatedAt: Timestamp.now(),
    ratings: [3, 4, 3],
    averageRating: 3.33,
  ),
  RecyclingCenterModel(
    id: 'RC008',
    name: 'Nisarg Mitra Kendra',
    description: 'Working hand-in-hand with nature for a better tomorrow.',
    location: 'Walgaon Road, Amravati',
    coordinates: const GeoPoint(20.9500, 77.7400), // Approximate Amravati coordinate
    contactNumber: '+91 7788996655',
    email: 'nisargmitra@gmail.com',
    services: ['Paper', 'Cardboard'],
    acceptedMaterials: ['Notebooks', 'Packing boxes'],
    operatingHours: 'Wed-Mon: 11 AM - 5 PM',
    isActive: true,
    imageUrl: 'https://via.placeholder.com/150/90EE90/FFFFFF?Text=Nisarg',
    websiteUrl: 'https://www.nisargmitraamravati.org',
    createdAt: Timestamp.fromDate(DateTime(2023, 9, 18)),
    updatedAt: Timestamp.now(),
    ratings: [5, 5, 4, 5],
    averageRating: 4.75,
  ),
  RecyclingCenterModel(
    id: 'RC009',
    name: 'Shree Ganesh Recycling',
    description: 'Your reliable local recycling service provider.',
    location: 'Badnera Road, Amravati',
    coordinates: const GeoPoint(20.9150, 77.7850), // Approximate Amravati coordinate
    contactNumber: '+91 6677889955',
    email: 'shreeganeshrecycle@rediffmail.com',
    services: ['Plastic', 'Glass'],
    acceptedMaterials: ['Water bottles', 'Wine bottles'],
    operatingHours: 'Mon-Sat: 9 AM - 7 PM',
    isActive: true,
    imageUrl: 'https://via.placeholder.com/150/F08080/FFFFFF?Text=GaneshRec',
     websiteUrl: 'google.com',
    createdAt: Timestamp.fromDate(DateTime(2024, 2, 28)),
    updatedAt: Timestamp.now(),
    ratings: [4, 3, 4, 4],
    averageRating: 3.75,
  ),
  RecyclingCenterModel(
    id: 'RC010',
    name: 'Om Sai Recycling Center',
    description: 'Committed to a cleaner and greener Amravati.',
    location: 'Rukmini Nagar, Amravati',
    coordinates: const GeoPoint(20.9450, 77.7550), // Approximate Amravati coordinate
    contactNumber: '+91 5566778899',
    email: 'omsairecycle@outlook.com',
    services: ['E-waste', 'Metal'],
    acceptedMaterials: ['Keyboards', 'Cables', 'Steel containers'],
    operatingHours: 'Tue-Sun: 10:30 AM - 5:30 PM',
    isActive: true,
    imageUrl: 'https://via.placeholder.com/150/DDA0DD/FFFFFF?Text=OmSai',
    websiteUrl: 'https://www.omsairecyclingamravati.com',
    createdAt: Timestamp.fromDate(DateTime(2023, 11, 5)),
    updatedAt: Timestamp.now(),
    ratings: [5, 4, 5],
    averageRating: 4.67,
  ),
];
            for (var center in dummyRecyclingCenters) {
              final docRef = collection.doc();
              await docRef.set(center.toMap());
            }

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Disposal centers uploaded successfully!")),
            );
          },
          child: const Text("Upload 10 Disposal Centers"),
        ),
      ),
    );
  }
}