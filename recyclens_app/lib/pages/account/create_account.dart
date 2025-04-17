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

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final agePicker = AgePicker();
  final genderPicker = GenderPicker();

  String _userType = 'Individual';
  bool _isFetchingLocation = false;
  bool _isLoading = true;

  final userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    checkIfUserExists();
  }

  Future<void> checkIfUserExists() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      if (doc.exists) {
        // Load user data into controller
        await userController.fetchUserData();
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DrawerPage()),
          );
        }
      } else {
        setState(() => _isLoading = false); // show the create account form
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackbar('Error checking user data: $e');
    }
  }

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

    if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
      _showSnackbar('Location permission denied');
      setState(() => _isFetchingLocation = false);
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _locationController.text = '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
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

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                TextInputWidget(
                  controller: _nameController,
                  hintText: 'Full Name',
                  icon: Icons.person_outline,
                  keyboardType: TextInputType.name,
                  enabled: true,
                  validator: (value) {},
                ),
                const SizedBox(height: 20),
                TextInputWidget(
                  controller: _phoneController,
                  hintText: 'Phone Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  enabled: true,
                  validator: (value) {},
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextInputWidget(
                        controller: _locationController,
                        hintText: 'Your Location',
                        icon: Icons.location_on_outlined,
                        enabled: false,
                        keyboardType: TextInputType.name,
                        validator: (value) {},
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
                                child: const Icon(Icons.my_location, color: Colors.white),
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
                DropdownButtonFormField<String>(
                  value: _userType,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.teal[50],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    labelText: 'Account Type',
                  ),
                  items: ['Individual', 'Organization'].map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
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
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 10,
                    shadowColor: themeColor.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveData() async {
    EasyLoading.show(status: 'Creating your account...');

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final location = _locationController.text.trim();
    final age = agePicker.date ?? '';
    final gender = genderPicker.selectedGender ?? '';

    if (name.isEmpty || phone.isEmpty || location.isEmpty || age.isEmpty || gender.isEmpty || age == 'Not selected' || gender == 'Not selected') {
      EasyLoading.dismiss();
      _showSnackbar('Please fill all fields');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnackbar('User not logged in');
      return;
    }

    final userModel = UserModel(
      name: name,
      phone: phone,
      location: location,
      age: age,
      gender: gender,
      userType: _userType,
      imageUrl: 'https://th.bing.com/th/id/OIP.868vh_SDCQdcqSIRRKaUgAHaEK?w=317&h=180&c=7&r=0&o=5&pid=1.7',
    );

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(userModel.toMap());
      await userController.fetchUserData(); // Refresh UserController
      EasyLoading.dismiss();
      _showSnackbar('Account created successfully');
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const DrawerPage()));
    } catch (e) {
      EasyLoading.dismiss();
      _showSnackbar('Failed to save user: $e');
    }
  }
}
