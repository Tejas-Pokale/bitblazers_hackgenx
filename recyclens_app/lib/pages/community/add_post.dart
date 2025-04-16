import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recyclens_app/models/post.dart';
import 'package:recyclens_app/utils/dialog_utils.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _postController = TextEditingController();
  File? _postImage;
  bool isPostButtonEnabled = false;

  final ImagePicker _picker = ImagePicker();

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _postImage = File(image.path);
      });
    }
  }

  // Check content to enable/disable post button
  void _checkPostContent() {
    setState(() {
      isPostButtonEnabled = _postController.text.trim().isNotEmpty;
    });
  }

  // Submit the post
  void _submitPost() async {
  if (_postController.text.trim().isNotEmpty) {
    await uploadPost(
      username: 'User Name', // Replace with actual user
      email: 'user@example.com', // Replace with actual user
      content: _postController.text.trim(),
      imageFile: _postImage,
    );

    _postController.clear();
    setState(() {
      _postImage = null;
      isPostButtonEnabled = false;
    });
  }
}

Future<void> uploadPost({
  required String username,
  required String email,
  required String content,
  required File? imageFile,
}) async {
  try {

    EasyLoading.show(status: 'Saving the post...' , dismissOnTap: false);

    String imageUrl = '';

    // if (imageFile != null) {
    //   final compressedImage = await ImageUtils.compressImage(imageFile);

    //   final fileName = const Uuid().v4();
    //   final ref = FirebaseStorage.instance
    //       .ref()
    //       .child('community_post_images')
    //       .child('$fileName.jpg');

    //   await ref.putFile(File(compressedImage!.path));
    //   imageUrl = await ref.getDownloadURL();
    // }

    final post = PostModel(
      username: username,
      email: email,
      uid: '',
      post: content,
      imageUrl: imageUrl,
      timestamp: DateTime.now(),
      likes: 0,
      comments: [],
    );

    await FirebaseFirestore.instance
        .collection('community_post')
        .add(post.toJson());

    print("Post uploaded successfully.");

    EasyLoading.dismiss();
    DialogUtils.showAwesomeSuccess('Done :)', 'Post saved succesfully...', context);
  } catch (e) {
    EasyLoading.dismiss();
    print("Error uploading post: $e");
    DialogUtils.showAwesomeError('Opps :(', 'Failed to save post try again...', context);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          "Create a Post",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(
                    'https://www.example.com/profile.jpg',
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Name',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Now • Public',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Prompt Title
            Text(
              'What\'s on your mind?',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            // Post Content Input
            TextField(
              controller: _postController,
              onChanged: (_) => _checkPostContent(),
              maxLines: 6,
              maxLength: 280,
              decoration: InputDecoration(
                hintText: 'Start typing...',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.green.shade400, width: 2),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              style: TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 16),

            // Upload Image Fancy Button
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: 55,
                  width: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade300, Colors.green.shade500],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.shade100,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Upload Image',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Image Preview
            if (_postImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AnimatedOpacity(
                  opacity: 1.0,
                  duration: Duration(milliseconds: 500),
                  child: Image.file(
                    _postImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Post Button
            Center(
              child: ElevatedButton(
                onPressed: isPostButtonEnabled ? _submitPost : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPostButtonEnabled
                      ? Colors.green.shade500
                      : Colors.green.shade200,
                  disabledBackgroundColor: Colors.grey.shade300,
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: isPostButtonEnabled ? 6 : 0,
                ),
                child: Text(
                  'Post',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
