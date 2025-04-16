import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recyclens_app/models/ewaste_report.dart';

// Define color constants
const lightGreen = Color(0xFFB2FF59);
const black = Colors.black;
const white = Colors.white;

class ReportEWasteScreen extends StatefulWidget {
  const ReportEWasteScreen({super.key});

  @override
  _ReportEWasteScreenState createState() => _ReportEWasteScreenState();
}

class _ReportEWasteScreenState extends State<ReportEWasteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  List<XFile> _pickedImages = [];
  Position? _currentPosition;
  String? _currentAddress;

  final List<String> _categories = [
    'Consumer Electronics',
    'Appliances',
    'IT Equipment',
    'Mobile Devices',
    'Batteries',
    'Other',
  ];

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are denied');
      }

      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude);

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          _currentAddress =
              '${place.street}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}, ${place.country}';
          _locationController.text = _currentAddress!;
        }
      } catch (e) {
        print("Geocoding error: $e");
        _currentAddress = "Could not determine address";
        _locationController.text = _currentAddress!;
      }
      setState(() {});
    } catch (e) {
      print("Error getting location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error getting location: $e'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _pickedImages = pickedFiles;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      _formKey.currentState!.save();

      List<String> imageUrls = [];
      if (_pickedImages.isNotEmpty) {
        for (var image in _pickedImages) {
          imageUrls.add(image.path); // Optional - storing path only
        }
      }

      try {
        String userId = 'user123'; // Replace with actual user ID

        final report = EWasteReportModel(
          userId: userId,
          category: _selectedCategory,
          description: _descriptionController.text,
          location: _locationController.text,
          coordinates: _currentPosition != null
              ? GeoPoint(
                  _currentPosition!.latitude, _currentPosition!.longitude)
              : null,
          imageUrls: imageUrls,
          createdAt: Timestamp.now(),
        );

        await FirebaseFirestore.instance
            .collection('reports')
            .add(report.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report submitted successfully!'),
            duration: Duration(seconds: 3),
          ),
        );

        _formKey.currentState!.reset();
        setState(() {
          _selectedCategory = null;
          _pickedImages.clear();
        });
        _descriptionController.clear();
        _locationController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit report: $e'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields.'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const Text('Report E-waste', style: TextStyle(color: black)),
        centerTitle: true,
        backgroundColor: lightGreen,
        iconTheme: const IconThemeData(color: black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  items: _categories
                      .map((value) =>
                          DropdownMenuItem(value: value, child: Text(value)))
                      .toList(),
                  decoration: InputDecoration(
                    labelText: 'Category of E-waste',
                    labelStyle: const TextStyle(color: black),
                    filled: true,
                    fillColor: white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please select a category' : null,
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Location of E-waste',
                    labelStyle: const TextStyle(color: black),
                    hintText: 'Enter address or use GPS',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.location_on, color: lightGreen),
                      onPressed: _getCurrentLocation,
                      tooltip: 'Get Current Location',
                    ),
                    filled: true,
                    fillColor: white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter location' : null,
                  readOnly: true,
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description of E-waste',
                    labelStyle: const TextStyle(color: black),
                    hintText: 'Describe the e-waste items',
                    filled: true,
                    fillColor: white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter description' : null,
                ),
                const SizedBox(height: 20),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: _pickImages,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lightGreen,
                        foregroundColor: black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Upload Images'),
                    ),
                    const SizedBox(height: 10),
                    if (_pickedImages.isNotEmpty)
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _pickedImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(_pickedImages[index].path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    else
                      const Text('No images selected',
                          style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightGreen,
                    foregroundColor: black,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Submit Report',
                      style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
