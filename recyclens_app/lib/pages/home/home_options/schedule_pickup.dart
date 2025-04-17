import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class SchedulePickupPage extends StatefulWidget {
  const SchedulePickupPage({super.key});

  @override
  State<SchedulePickupPage> createState() => _SchedulePickupPageState();
}

class _SchedulePickupPageState extends State<SchedulePickupPage> {
  final _formKey = GlobalKey<FormState>();

  String? _pickupType;
  String? _agency;
  String? _deviceType;
  String? _location;
  String? _contact;

  final List<String> _pickupTypes = ['Recycle', 'Dispose'];
  final List<String> _agencies = ['GreenBin Co.', 'EcoDrop Pvt. Ltd.', 'Recykal Partners'];
  final List<String> _deviceTypes = ['Mobile Phone', 'Laptop', 'Tablet', 'Television', 'Fridge', 'Other'];

  final TextEditingController _locationController = TextEditingController();

  Future<void> _fetchLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Location Error', 'Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        Get.snackbar('Permission Denied', 'Location permission is denied.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _locationController.text = "${position.latitude}, ${position.longitude}";
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location');
    }
  }

  void _submitRequest() {
    if (_formKey.currentState?.validate() ?? false) {
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 64),
                const SizedBox(height: 16),
                const Text(
                  "Pickup Request Registered!",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Your pickup request has been registered successfully.\n\nYou’ll be able to track it once accepted by the agency.",
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.4),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    Get.back(); // Close dialog
                    Get.back(); // Go back to previous screen
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  ),
                  child: const Text("Okay", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        title: const Text('Schedule Pickup'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildDropdown("Pickup Type", _pickupTypes, _pickupType, (val) => setState(() => _pickupType = val)),
                const SizedBox(height: 16),
                _buildDropdown("Agency", _agencies, _agency, (val) => setState(() => _agency = val)),
                const SizedBox(height: 16),
                _buildDropdown("Device Type", _deviceTypes, _deviceType, (val) => setState(() => _deviceType = val)),
                const SizedBox(height: 16),
                _buildLocationInput(),
                const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration('Contact Number'),
                  validator: (value) => value == null || value.isEmpty ? 'Enter contact number' : null,
                  onChanged: (val) => _contact = val,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.send),
                    label: const Text('Submit Request'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: _submitRequest,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedValue, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      isExpanded: true,
      decoration: _inputDecoration(label),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      validator: (val) => val == null ? 'Please select $label' : null,
      onChanged: onChanged,
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    );
  }

  Widget _buildLocationInput() {
    return TextFormField(
      controller: _locationController,
      decoration: InputDecoration(
        labelText: 'Location',
        suffixIcon: IconButton(
          icon: const Icon(Icons.my_location_rounded),
          onPressed: _fetchLocation,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
      validator: (val) => val == null || val.isEmpty ? 'Location required' : null,
      onChanged: (val) => _location = val,
    );
  }
}
