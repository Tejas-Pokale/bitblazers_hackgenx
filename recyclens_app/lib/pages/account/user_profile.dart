import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:recyclens_app/controllers/user_controller.dart';
import 'package:recyclens_app/models/user.dart';
import 'package:recyclens_app/pages/home/drawer.dart';
import 'package:recyclens_app/widgets/age_picker.dart';
import 'package:recyclens_app/widgets/gender_picker.dart';
import 'package:recyclens_app/widgets/image_picker.dart';
import 'package:recyclens_app/widgets/text_input.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final userController = Get.find<UserController>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final agePicker = AgePicker() ;
  final genderPicker = GenderPicker();

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
        key:  UniqueKey(),
      ),
    );
  }

  @override
  void initState() {
    final user = userController.currentUser.value! ;
    _nameController.text = user.name ;
    _phoneController.text = user.phone;
    _locationController.text = user.location;
    agePicker.date = user.age ;
    genderPicker.selectedGender = user.gender;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.teal;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Your Profile'),
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

                agePicker,
                const SizedBox(height: 20),

                 genderPicker,
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
                  label: const Text('save profile changes'),
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
    EasyLoading.show(status: 'Saving profile changes...');
  final name = _nameController.text.trim();
  final phone = _phoneController.text.trim();
  final location = _locationController.text.trim();
  final age = agePicker.date ?? '';
  final gender = genderPicker.selectedGender ?? '';

  // Basic validations
  if (name.isEmpty) {
    EasyLoading.dismiss();
    _showSnackbar('Please enter your name');
    return;
  }
  if (phone.isEmpty) {
     EasyLoading.dismiss();
    _showSnackbar('Please enter your phone number');
    return;
  }
  if (location.isEmpty) {
     EasyLoading.dismiss();
    _showSnackbar('Please fetch your location');
    return;
  }
  if (age.isEmpty || age == 'Not selected') {
     EasyLoading.dismiss();
    _showSnackbar('Please select your age');
    return;
  }
  if (gender.isEmpty || gender == 'Not selected') {
     EasyLoading.dismiss();
    _showSnackbar('Please select your gender');
    return;
  }

  // Get current Firebase Auth user
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    _showSnackbar('User not logged in');
    return;
  }

  // Create user model
  final userModel = UserModel(
    name: name,
    phone: phone,
    location: location,
    age: age,
    gender: gender,
    userType: _userType,
    imageUrl: 'https://th.bing.com/th/id/OIP.868vh_SDCQdcqSIRRKaUgAHaEK?w=317&h=180&c=7&r=0&o=5&pid=1.7' ?? '', // use your ImagePicker state
  );

  try {
    // Save to Firestore using UID as document ID
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update(userModel.toMap());

         EasyLoading.dismiss();

    _showSnackbar('Profile changes saved :)');

    userController.currentUser.value = userModel ;

    // Navigate to Drawer page
    //Navigator.of(context).pop();
  } catch (e) {
     EasyLoading.dismiss();
    _showSnackbar('Failed to save user: $e');
  }
}
}
