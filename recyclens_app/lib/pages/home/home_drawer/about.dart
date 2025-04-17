import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("About"),
        centerTitle: true,
        backgroundColor: Colors.green.shade300,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  const Icon(LucideIcons.recycle, size: 60, color: Colors.green),
                  const SizedBox(height: 10),
                  Text(
                    "Recyclens",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "E-Waste Management App",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildCard(
              title: "Our Mission",
              icon: LucideIcons.target,
              description:
                  "To promote responsible disposal of electronic waste and create awareness about the environmental impact of e-waste.",
            ),
            const SizedBox(height: 16),
            _buildCard(
              title: "What We Do",
              icon: LucideIcons.activity,
              description:
                  "Recyclens allows users to report e-waste, request pickups, and learn how to recycle better. We connect users to recyclers and help build a greener future.",
            ),
            const SizedBox(height: 16),
            _buildCard(
              title: "Why E-Waste?",
              icon: LucideIcons.info,
              description:
                  "E-waste contains harmful toxins that can pollute soil and water. Our platform helps reduce this pollution by facilitating safe and easy recycling.",
            ),
            const SizedBox(height: 16),
            _buildCard(
              title: "Version",
              icon: LucideIcons.box,
              description: "v1.0.0",
            ),
            const SizedBox(height: 16),
            _buildCard(
              title: "Contact Us",
              icon: LucideIcons.mail,
              description: "support@recyclens.app\n+91 12345 67890",
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                "© 2025 Recyclens. All rights reserved.",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.green.shade400),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
      ),
    );
  }
}
