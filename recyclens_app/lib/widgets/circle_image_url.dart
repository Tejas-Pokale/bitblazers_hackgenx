import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

// ignore: must_be_immutable
class CircleImageUrl extends StatelessWidget {
  final String? imageUrl;
  var radius;

  CircleImageUrl({super.key, this.imageUrl,required this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius, // Adjust the radius as needed
      backgroundColor: Colors.grey, // Background color of the CircleAvatar
      child: ClipOval(
        child: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage, // Placeholder image
          image: imageUrl!,
          fit: BoxFit.cover,
          width: double.infinity, // Adjust the width and height as needed
          height: double.infinity,
        ),
      ),
    );
  }
}
