import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:recyclens_app/models/disposal_center.dart';
import 'package:recyclens_app/utils/url_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class DisposingCentersPage extends StatefulWidget {
  const DisposingCentersPage({super.key});

  @override
  State<DisposingCentersPage> createState() => _DisposingCentersPageState();
}

class _DisposingCentersPageState extends State<DisposingCentersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disposal Centers'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('disposal_centers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No disposal centers found.'));
          }

          final disposalCenters = snapshot.data!.docs
              .map((doc) => DisposalCenterModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
              .toList();

          return ListView.builder(
            itemCount: disposalCenters.length,
            itemBuilder: (context, index) {
              final center = disposalCenters[index];
              return DisposalCenterCard(center: center);
            },
          );
        },
      ),
    );
  }
}

class DisposalCenterCard extends StatefulWidget {
  final DisposalCenterModel center;

  const DisposalCenterCard({required this.center, super.key});

  @override
  State<DisposalCenterCard> createState() => _DisposalCenterCardState();
}

class _DisposalCenterCardState extends State<DisposalCenterCard> {
  final Set<Marker> _markers = {};
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _markers.add(
      Marker(
        markerId: MarkerId(widget.center.id),
        position: LatLng(widget.center.coordinates.latitude, widget.center.coordinates.longitude),
        infoWindow: InfoWindow(title: widget.center.name),
        onTap: () => _openGoogleMaps(), // Added onTap
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _openGoogleMaps() async {
    final latitude = widget.center.coordinates.latitude;
    final longitude = widget.center.coordinates.longitude;
    final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.center.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const Icon(Icons.location_on, color: Colors.blue),
                Text(widget.center.averageRating.toStringAsFixed(1),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Icon(Icons.star, color: Colors.amber),
              ],
            ),
            const SizedBox(height: 8),
            Text(widget.center.description, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text('Location: ${widget.center.location}', style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text('Hours: ${widget.center.operatingHours}', style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4.0,
              children: widget.center.acceptedWasteTypes
                  .map((type) => Chip(label: Text(type), backgroundColor: Colors.green[100]))
                  .toList(),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () => UrlUtils.launchURL(widget.center.websiteUrl),
                  icon: const Icon(Icons.web),
                  label: const Text('Website'),
                ),
                ElevatedButton.icon(
                  onPressed: () => UrlUtils.call(widget.center.contactNumber),
                  icon: const Icon(Icons.phone),
                  label: const Text('Call'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.center.coordinates.latitude, widget.center.coordinates.longitude),
                  zoom: 15,
                ),
                markers: _markers,
              ),
            ),
          ],
        ),
      ),
    );
  }




}