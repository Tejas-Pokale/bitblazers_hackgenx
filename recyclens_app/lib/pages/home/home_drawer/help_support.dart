
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Help & Support"),
        centerTitle: true,
        backgroundColor: Colors.green.shade300,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSupportCard(
            title: "How to Report E-waste?",
            icon: LucideIcons.alertTriangle,
            content:
                "Navigate to the 'Report' section and fill in the required details. You can optionally upload images and use GPS to autofill your location.",
          ),
          const SizedBox(height: 16),
          _buildSupportCard(
            title: "Request a Pickup",
            icon: LucideIcons.truck,
            content:
                "Go to the 'Pickup' section to schedule a pickup. Make sure your address and category are correct before submitting.",
          ),
          const SizedBox(height: 16),
          _buildSupportCard(
            title: "Track My Pickup",
            icon: LucideIcons.mapPin,
            content:
                "You can track your pickup status under the 'Tracking' page. Each step from request to completion is shown in a stepper view.",
          ),
          const SizedBox(height: 16),
          _buildSupportCard(
            title: "Educational Insights",
            icon: LucideIcons.bookOpen,
            content:
                "Visit the 'Insights' section to watch curated videos and articles to learn more about e-waste management and sustainability.",
          ),
          const SizedBox(height: 16),
          _buildSupportCard(
            title: "Need More Help?",
            icon: LucideIcons.helpCircle,
            content:
                "If you’re facing issues or need help, feel free to reach out:\n\n📧 support@recyclens.app\n📞 +91 12345 67890",
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              "We're here to help you recycle better ♻️",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSupportCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: Colors.green.shade400),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )),
                  const SizedBox(height: 6),
                  Text(content,
                      style: TextStyle(fontSize: 14, color: Colors.grey[800])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
