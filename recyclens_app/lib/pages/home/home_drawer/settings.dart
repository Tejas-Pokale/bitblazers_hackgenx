import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        backgroundColor: Colors.green.shade300,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle("Account"),
          _buildTile(
            icon: LucideIcons.user,
            title: "Profile",
            subtitle: "View or edit your profile",
            onTap: () {},
          ),
          _buildTile(
            icon: LucideIcons.keyRound,
            title: "Change Password",
            subtitle: "Update your password",
            onTap: () {},
          ),
          const SizedBox(height: 24),

          _buildSectionTitle("Notifications"),
          SwitchListTile(
            title: const Text("Enable Notifications"),
            subtitle: const Text("Get updates about pickups & tips"),
            value: notificationsEnabled,
            activeColor: Colors.green,
            onChanged: (value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),
          const SizedBox(height: 24),

          _buildSectionTitle("Appearance"),
          SwitchListTile(
            title: const Text("Dark Mode"),
            subtitle: const Text("Reduce screen brightness"),
            value: darkMode,
            activeColor: Colors.green,
            onChanged: (value) {
              setState(() {
                darkMode = value;
              });
            },
          ),
          const SizedBox(height: 24),

          _buildSectionTitle("App"),
          _buildTile(
            icon: LucideIcons.star,
            title: "Rate Us",
            subtitle: "Give feedback on the Play Store",
            onTap: () {},
          ),
          _buildTile(
            icon: LucideIcons.messageCircle,
            title: "Send Feedback",
            subtitle: "Share your thoughts with us",
            onTap: () {},
          ),
          _buildTile(
            icon: LucideIcons.info,
            title: "About",
            subtitle: "Learn about this app",
            onTap: () {},
          ),
          const SizedBox(height: 24),

          _buildSectionTitle("Danger Zone"),
          _buildTile(
            icon: LucideIcons.logOut,
            title: "Logout",
            subtitle: "Sign out of your account",
            onTap: () {
              // Add logout logic
            },
            iconColor: Colors.red,
            textColor: Colors.red.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          color: Colors.grey.shade700,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: iconColor ?? Colors.green.shade400),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor ?? Colors.black,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      ),
    );
  }
}
