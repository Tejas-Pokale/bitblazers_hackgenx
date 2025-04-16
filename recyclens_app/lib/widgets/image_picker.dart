import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerWidget extends StatefulWidget {
  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _image;

  Future<void> _getImage(ImageSource source) async {
    final pickedFile =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform.getImageFromSource(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        CircleAvatar(
          radius: 55.0,
          backgroundColor:
              Theme.of(context).colorScheme.background.withOpacity(0.8),
          child: _image != null
              ? ClipOval(
                  child: Image.file(
                    _image!,
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                )
              : Icon(
                  Icons.person,
                  size: 60.0,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
        ),
        Positioned(
          right: -15,
          bottom: 0,
          child: IconButton(
              onPressed: () {
                getSourceType();
              },
              icon: Icon(
                Icons.camera_alt,
                color: Theme.of(context).colorScheme.inversePrimary,
                size: 30,
              )),
        )
      ],
    );
  }

  void getSourceType() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            'Select Image Source',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                // Handle camera option
                Navigator.of(context).pop();
                _getImage(ImageSource.camera);
                
              },
              child: const ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                // Handle gallery option
                Navigator.of(context).pop();
                _getImage(ImageSource.gallery);
              },
              child: const ListTile(
                leading: Icon(Icons.photo),
                title: Text('Gallery'),
              ),
            ),
          ],
        );
      },
    );
  }
}
