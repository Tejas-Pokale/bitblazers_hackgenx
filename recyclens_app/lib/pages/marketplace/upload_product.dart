import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recyclens_app/utils/dialog_utils.dart';
import 'package:uuid/uuid.dart';
import '../../models/product.dart';
import '../../utils/image_utils.dart';

class UploadProductPage extends StatefulWidget {
  const UploadProductPage({super.key});

  @override
  State<UploadProductPage> createState() => _UploadProductPageState();
}

class _UploadProductPageState extends State<UploadProductPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _contact = TextEditingController();

  String _category = 'Laptops';
  String _condition = 'Used - Good';
  bool _isSold = false;
  bool _negotiable = false;
  bool _chatEnabled = true;

  List<String> _deliveryOptions = ['Pickup'];
  List<File> _selectedImages = [];

  bool _isUploading = false;

  final user = FirebaseAuth.instance.currentUser;

  // Pick images from gallery
  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final List<XFile> picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(picked.map((x) => File(x.path)));
      });
    }
  }

  // Upload images to Firebase Storage and return download URLs
  Future<List<String>> _uploadImages() async {
    List<String> urls = [];
    for (File image in _selectedImages) {
      final compressed = await ImageUtils.compressImage(image);
      final id = const Uuid().v4();
      final ref = FirebaseStorage.instance.ref().child('products/$id.jpg');
      final upload = await ref.putFile(File(compressed?.path ?? image.path));
      final url = await upload.ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  // Upload the product data to Firestore
  Future<void> _uploadProduct() async {
    try {
      if (!_formKey.currentState!.validate()) return;
      //setState(() => _isUploading = true);

      EasyLoading.show(status: 'Uploading your product...');

      // Upload images and get URLs
      //final imageUrls = await _uploadImages();

      // Create product model instance
      final product = ProductModel(
        id: const Uuid().v4(),
        title: _title.text.trim(),
        description: _desc.text.trim(),
        price: double.parse(_price.text.trim()),
        category: _category,
        condition: _condition,
        images: [],
        postedBy: user!.uid,
        timestamp: Timestamp.now(),
        location: _location.text.trim(),
        isSold: _isSold,
        negotiable: _negotiable,
        chatEnabled: _chatEnabled,
        sellerName: user!.displayName ?? 'Seller',
        sellerProfileImage: user!.photoURL ?? '',
        contactNumber: _contact.text.trim(),
        deliveryOptions: _deliveryOptions,
      );

      // Save product data to Firestore
      await FirebaseFirestore.instance
          .collection('marketplace_products')
          .doc(product.id)
          .set(product.toMap());

      // Reset UI and show success message
      setState(() {
        _isUploading = false;
        _selectedImages.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product uploaded successfully!')),
      );

      EasyLoading.dismiss();
      AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.success,
        body:  Center(
          child: Text(
            'Yeah , product uploaded successfully',
            style: TextStyle(fontStyle: FontStyle.italic,color: Theme.of(context).colorScheme.onPrimaryContainer,),
            textAlign: TextAlign.center,
          ),
        ),
        title: 'This is Ignored',
        desc: 'This is also Ignored',
        btnOkOnPress: () {
          Navigator.pop(context); // Go back to the previous screen
        },
      ).show();
      
     
    } catch (e) {
      EasyLoading.dismiss();
      DialogUtils.showAwesomeError('Opps...', e.toString(), context);
    }
  }

  // Decoration for text fields
  InputDecoration _inputDecoration(String hint) => InputDecoration(
    labelText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    filled: true,
    fillColor: Colors.white,
  );

  // Section card for form fields
  Widget _sectionCard({required Widget child, String? title}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF006D5B),
              ),
            ),
            const SizedBox(height: 10),
          ],
          child,
        ],
      ),
    );
  }

  // Image preview grid
  Widget _imagePreviewGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ..._selectedImages.map(
          (img) => Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  img,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => setState(() => _selectedImages.remove(img)),
                  child: const CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.redAccent,
                    child: Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: _pickImages,
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(
                Icons.add_a_photo,
                size: 30,
                color: Color(0xFF006D5B),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Switch to enable/disable chat or negotiable price
  Widget _buildSwitch(String title, bool value, void Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF006D5B),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('Upload Product'),
        backgroundColor: const Color(0xFF006D5B),
        elevation: 0,
      ),
      body:
          _isUploading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _sectionCard(
                        title: "Basic Info",
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _title,
                              decoration: _inputDecoration("Product Title"),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _desc,
                              maxLines: 3,
                              decoration: _inputDecoration("Description"),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                      _sectionCard(
                        title: "Price & Category",
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _price,
                                    keyboardType: TextInputType.number,
                                    decoration: _inputDecoration("Price (INR)"),
                                    validator:
                                        (v) => v!.isEmpty ? 'Required' : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: _category,
                                    decoration: _inputDecoration("Category"),
                                    items:
                                        ['Laptops', 'Phones', 'Accessories']
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e,
                                                child: Text(e),
                                              ),
                                            )
                                            .toList(),
                                    onChanged:
                                        (v) => setState(() => _category = v!),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              value: _condition,
                              decoration: _inputDecoration("Condition"),
                              items:
                                  [
                                        'Brand New',
                                        'Used - Like New',
                                        'Used - Good',
                                        'Used - Fair',
                                      ]
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (v) => setState(() => _condition = v!),
                            ),
                          ],
                        ),
                      ),
                      _sectionCard(
                        title: "Location & Contact",
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _location,
                              decoration: _inputDecoration("Location"),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _contact,
                              keyboardType: TextInputType.phone,
                              decoration: _inputDecoration("Phone Number"),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                      _sectionCard(
                        title: "Product Images",
                        child: _imagePreviewGrid(),
                      ),
                      _sectionCard(
                        title: "Extra Options",
                        child: Column(
                          children: [
                            _buildSwitch(
                              "Negotiable Price",
                              _negotiable,
                              (v) => setState(() => _negotiable = v),
                            ),
                            _buildSwitch(
                              "Enable Chat",
                              _chatEnabled,
                              (v) => setState(() => _chatEnabled = v),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _uploadProduct,
                        icon: const Icon(Icons.cloud_upload_outlined),
                        label: const Text('Post Product'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006D5B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
    );
  }
}
