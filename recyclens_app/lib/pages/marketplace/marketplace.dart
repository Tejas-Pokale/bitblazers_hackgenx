import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:recyclens_app/controllers/marketplace_drawer_controller.dart';
import 'package:recyclens_app/pages/marketplace/products_feed.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {

   final drawerController = Get.find<MarketplaceDrawerController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketplaceDrawerController>(
      builder: (_) => ZoomDrawer(
      controller: drawerController.zoomDrawerController,
      borderRadius: 50,
      showShadow: true,
      openCurve: Curves.fastOutSlowIn,
      slideWidth: MediaQuery.of(context).size.width * 1,
      duration: const Duration(milliseconds: 500),
      menuScreenTapClose: true,
      // angle: 0.0,
      menuBackgroundColor: Colors.white,
      mainScreen: ProductsFeedPage(),
      moveMenuScreen: true,

      mainScreenOverlayColor: Colors.black12,
      menuScreenWidth: MediaQuery.of(context).size.width * .85,
      
      isRtl: true,
      clipMainScreen: false,
      menuScreen: Scaffold(
        backgroundColor: Colors.black12,
        body: MarketplaceDrawer(onNavigate: (p0) {
          
        },),
      ),
      style: DrawerStyle.style4,
    ),
    );
  }
}

class MarketplaceDrawer extends StatelessWidget {
  final Function(String) onNavigate;

  const MarketplaceDrawer({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF4F6F8),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _drawerItem('Dashboard', Icons.dashboard_outlined, 'dashboard'),
                  _drawerItem('Listed Products', Icons.inventory_2_outlined, 'listings'),
                  _drawerItem('Orders', Icons.shopping_cart_checkout_outlined, 'orders'),
                  _drawerItem('Favorites', Icons.favorite_border, 'favorites'),
                  _drawerItem('Chats', Icons.chat_outlined, 'chats'),
                  const Divider(height: 32, color: Colors.grey),
                  _drawerItem('Profile Settings', Icons.settings_outlined, 'settings'),
                  _drawerItem('Help & Support', Icons.help_outline, 'help'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () => onNavigate('logout'),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(String title, IconData icon, String route) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icon, color: const Color(0xFF006D5B)),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        onTap: () => onNavigate(route),
        splashColor: Colors.green.shade50,
      ),
    );
  }
}
