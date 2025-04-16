import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:recyclens_app/models/recycling_center.dart';
import 'package:recyclens_app/utils/url_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class RecyclingCentersPage extends StatefulWidget {
  const RecyclingCentersPage({super.key});

  @override
  State<RecyclingCentersPage> createState() => _RecyclingCentersPageState();
}

class _RecyclingCentersPageState extends State<RecyclingCentersPage> {
  List<RecyclingCenterModel> _centers = [];
  bool _isLoading = true;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _loadCenters();
  }

  Future<void> _loadCenters() async {
    setState(() => _isLoading = true);
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('recycling_centers').get();

      _centers = snapshot.docs
          .map((doc) => RecyclingCenterModel.fromMap(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      setState(() => _isLoading = false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load data: $e")),
      );
      setState(() => _isLoading = false);
    }
  }

  Widget _buildRatingStars(double averageRating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < averageRating.round() ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }

  void _openGoogleMaps(double latitude, double longitude, String name) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude&query_place_id=$name';
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Recycling Centers'),
        centerTitle: true,
        elevation: 6,
        shadowColor: Colors.black26,
      ),
      body: RefreshIndicator(
        onRefresh: _loadCenters,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _centers.length,
                itemBuilder: (context, index) {
                  final center = _centers[index];
                  return _buildRecyclingCenterCard(center);
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement navigation to a map view or a filter/search page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Map view/Filters coming soon!')),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.map_outlined, color: Colors.white),
      ),
    );
  }

  Widget _buildRecyclingCenterCard(RecyclingCenterModel center) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Section
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Hero(
                  tag: 'centerImage-${center.id}',
                  child: Image.network(
                    center.imageUrl,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, _, __) => Container(
                      height: 180,
                      color: Colors.grey[200],
                      alignment: Alignment.center,
                      child: const Icon(Icons.image, size: 40),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Chip(
                  label: Text(center.isActive ? 'Open' : 'Closed',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  backgroundColor: center.isActive ? Colors.green[400] : Colors.red[400],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        center.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildRatingStars(center.averageRating),
                  ],
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  center.description,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 12),

                // Location
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 20),
                    const SizedBox(width: 6),
                    Expanded(child: Text(center.location)),
                  ],
                ),
                const SizedBox(height: 8),

                // Services
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: center.services.map((service) => Chip(
                        label: Text(service),
                        backgroundColor: Colors.green.shade100,
                      )).toList(),
                ),
                const SizedBox(height: 8),

                // Accepted Materials (Concise)
                Text(
                  "Accepts: ${center.acceptedMaterials.take(3).join(', ')}${center.acceptedMaterials.length > 3 ? '...' : ''}",
                  style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                ),
                const SizedBox(height: 12),

                // Contact and Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.call, color: Colors.green),
                          onPressed: () => UrlUtils.call(center.contactNumber),
                        ),
                        IconButton(
                          icon: const Icon(Icons.web, color: Colors.blue),
                          onPressed: () => UrlUtils.launchURL(center.websiteUrl),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.directions, color: Colors.blue),
                      onPressed: () => _openGoogleMaps(
                        center.coordinates.latitude,
                        center.coordinates.longitude,
                        center.name,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}