import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recyclens_app/controllers/home_bottombar_controller.dart';
import 'package:recyclens_app/controllers/marketplace_drawer_controller.dart';
import 'package:recyclens_app/models/product.dart';
import 'package:recyclens_app/pages/marketplace/product_details.dart';
import 'package:recyclens_app/pages/marketplace/upload_product.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class ProductsFeedPage extends StatefulWidget {
  const ProductsFeedPage({super.key});

  @override
  State<ProductsFeedPage> createState() => _ProductsFeedPageState();
}

class _ProductsFeedPageState extends State<ProductsFeedPage> {
  final marketplaceDrawer = Get.find<MarketplaceDrawerController>();
  final HomeBottombarController _homeBottombarController = Get.find<HomeBottombarController>();
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _homeBottombarController.bottom_bar_scroll_controller,
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: const Text('Buy or Sell'),
            elevation: 2,
            forceElevated: true,
            shadowColor: Theme.of(context).primaryColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  marketplaceDrawer.zoomDrawerController.open!();
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('marketplace_products')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: Text('No products found')),
                  );
                }

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final product = ProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);

                    return _buildProductCard(product);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ScrollToHide(
        hideDirection: Axis.horizontal,
        scrollController: _homeBottombarController.bottom_bar_scroll_controller,
        height: 50,
        duration: const Duration(milliseconds: 300),
        child: FloatingActionButton(
          onPressed: () {
            Get.to(const UploadProductPage());
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    final isLiked = product.likes.contains(currentUserId);
    final timeAgo = timeago.format(product.timestamp.toDate());

    return InkWell(
      onTap: () {
        Get.to(ProductDetailsPage(product: product));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 12),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: SizedBox(
                height: 220,
                child: PageView.builder(
                  itemCount: product.images.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      product.images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  },
                ),
              ),
            ),
      
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '₹${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
      
                  // Location, negotiable, posted time
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          product.location,
                          style: const TextStyle(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (product.negotiable)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Negotiable',
                            style: TextStyle(color: Colors.orange, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
      
                  const SizedBox(height: 6),
                  Text("Posted $timeAgo", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const Divider(height: 20),
      
                  // Seller Info
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: product.sellerProfileImage.isNotEmpty
                            ? NetworkImage(product.sellerProfileImage)
                            : null,
                        radius: 22,
                        backgroundColor: Colors.grey[300],
                        child: product.sellerProfileImage.isEmpty
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.sellerName,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              product.contactNumber,
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.grey,
                        ),
                        onPressed: () => _toggleLike(product),
                      ),
                    ],
                  ),
      
                  const SizedBox(height: 10),
      
                  // Call / Message Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _launchCall(product.contactNumber),
                          icon: const Icon(Icons.call),
                          label: const Text("Call"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _launchSMS(product.contactNumber),
                          icon: const Icon(Icons.message),
                          label: const Text("Message"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _toggleLike(ProductModel product) async {
    final docRef = FirebaseFirestore.instance.collection('marketplace_products').doc(product.id);
    final isLiked = product.likes.contains(currentUserId);

    try {
      if (isLiked) {
        await docRef.update({'likes': FieldValue.arrayRemove([currentUserId])});
      } else {
        await docRef.update({'likes': FieldValue.arrayUnion([currentUserId])});
      }
    } catch (e) {
      debugPrint('Error toggling like: $e');
    }
  }

  void _launchCall(String phoneNumber) async {
  final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
  try {
    if (!await launchUrl(uri)) {
      Get.snackbar('Error', 'Dialer not available on this device');
    }
  } catch (e) {
    Get.snackbar('Error', 'Something went wrong: $e');
  }
}


  void _launchSMS(String phoneNumber) async {
  final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);

  try {
    if (!await launchUrl(smsUri)) {
      Get.snackbar('Error', 'SMS app not available on this device');
    }
  } catch (e) {
    Get.snackbar('Error', 'Something went wrong: $e');
  }
}

}
