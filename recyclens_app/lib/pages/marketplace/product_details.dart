import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:recyclens_app/models/product.dart';
import 'package:recyclens_app/utils/url_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProductDetailsPage extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsPage({super.key, required this.product});

 


 


  void _chatWithSeller(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Chat feature coming soon!")),
    );
  }

  void _buyNow(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Buy Now clicked!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = product.images.isNotEmpty
        ? product.images
        : [
            'https://via.placeholder.com/600x400?text=No+Image+Available'
          ];

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 280.0,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
              ),
              items: imageUrls.map((imageUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[100],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Center(
                            child: Icon(Icons.broken_image, size: 80, color: Colors.grey),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: product.sellerProfileImage.isNotEmpty
                            ? NetworkImage(product.sellerProfileImage)
                            : const NetworkImage('https://via.placeholder.com/150x150?text=No+User'),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.sellerName.isNotEmpty ? product.sellerName : 'Unknown Seller',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(product.location, style: const TextStyle(color: Colors.grey)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.green.shade700, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(timeago.format(product.timestamp.toDate()), style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  const Divider(height: 32),
                  Text('Description', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(product.description),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _infoChip('Condition', product.condition),
                      _infoChip('Category', product.category),
                      _infoChip('Delivery', product.deliveryOptions.join(', ')),
                      _infoChip('Negotiable', product.negotiable ? 'Yes' : 'No'),
                      _infoChip('Sold', product.isSold ? 'Yes' : 'No'),
                      _infoChip('Views', product.views.toString()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => UrlUtils.call(product.contactNumber),
                          icon: const Icon(Icons.call),
                          label: const Text('Call'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>UrlUtils.message(product.contactNumber),
                          icon: const Icon(Icons.message),
                          label: const Text('Message'),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 158, 229, 96)),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _chatWithSeller(context),
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: const Text('Chat'),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 200, 85, 198)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _buyNow(context),
                          icon: const Icon(Icons.shopping_cart_checkout),
                          label: const Text('Buy Now'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Chip(
      backgroundColor: Colors.grey[100],
      label: Text("$label: $value"),
    );
  }
}
