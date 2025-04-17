import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:recyclens_app/pages/home/drawer.dart';
import 'package:recyclens_app/widgets/age_picker.dart';
import 'package:recyclens_app/widgets/gender_picker.dart';
import 'package:recyclens_app/widgets/image_picker.dart';
import 'package:recyclens_app/widgets/text_input.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String _userType = 'Individual';
  bool _isFetchingLocation = false;

  Future<void> _fetchLocation() async {
    setState(() => _isFetchingLocation = true);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackbar('Please enable location services');
      setState(() => _isFetchingLocation = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      _showSnackbar('Location permission denied');
      setState(() => _isFetchingLocation = false);
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _locationController.text =
          '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
    } catch (e) {
      _showSnackbar('Failed to get location');
    }

    setState(() => _isFetchingLocation = false);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.teal.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.teal;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
        backgroundColor: themeColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.shade100,
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                 ImagePickerWidget(),
                const SizedBox(height: 25),

                // Full Name
                TextInputWidget(
                  controller: _nameController,
                  hintText: 'Full Name',
                  icon: Icons.person_outline,
                  keyboardType: TextInputType.name,
                  enabled: true,
                  
                    validator: (value) {
                      
                    },
                ),
                const SizedBox(height: 20),

                // Phone Number
                TextInputWidget(
                  controller: _phoneController,
                  hintText: 'Phone Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  enabled: true,
                   
                    validator: (value) {
                      
                    },
                ),
                const SizedBox(height: 20),

                // Location Picker
                Row(
                  children: [
                    Expanded(
                      child: TextInputWidget(
                        controller: _locationController,
                        hintText: 'Your Location',
                        icon: Icons.location_on_outlined,
                        enabled: false,
                      
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      
                    },
                      ),
                    ),
                    const SizedBox(width: 10),
                    _isFetchingLocation
                        ? const CircularProgressIndicator()
                        : Tooltip(
                            message: 'Fetch Location',
                            child: GestureDetector(
                              onTap: _fetchLocation,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: themeColor,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(10),
                                child: const Icon(Icons.my_location,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                  ],
                ),
                const SizedBox(height: 20),

                const AgePicker(),
                const SizedBox(height: 20),

                 GenderPicker(),
                const SizedBox(height: 20),

                // Account Type Dropdown
                DropdownButtonFormField<String>(
                  value: _userType,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.teal[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    labelText: 'Account Type',
                  ),
                  items: ['Individual', 'Organization'].map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _userType = val);
                    }
                  },
                ),
                const SizedBox(height: 30),

                ElevatedButton.icon(
                  onPressed: saveData,
                  icon: const Icon(Icons.save),
                  label: const Text('Create Account'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 20),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 10,
                    shadowColor: themeColor.withOpacity(0.3),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveData() async {
  final user = UserModel(
    name: _nameController.text.trim(),
    phone: _phoneController.text.trim(),
    location: _locationController.text.trim(),
    age: selectedAge ?? 'Not selected', // use your state for AgePicker
    gender: selectedGender ?? 'Not selected', // use your state for GenderPicker
    userType: _userType,
    imageUrl: pickedImagePath, // optional path from your ImagePicker
  );

  try {
    await FirebaseFirestore.instance
        .collection('users')
        .add(user.toMap());

    _showSnackbar('Account created successfully');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const DrawerPage()),
    );
  } catch (e) {
    _showSnackbar('Failed to save user: $e');
  }
}
}
