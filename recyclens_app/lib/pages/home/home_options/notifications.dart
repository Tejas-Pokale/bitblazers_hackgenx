import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<Map<String, dynamic>> _notifications = [
    {
      "title": "Pickup Scheduled",
      "message": "Your e-waste pickup is scheduled for tomorrow at 10:00 AM.",
      "icon": LucideIcons.truck,
      "time": "2 hrs ago",
    },
    {
      "title": "Report Received",
      "message":
          "Thanks! We have received your e-waste report and it’s under review.",
      "icon": LucideIcons.fileCheck2,
      "time": "1 day ago",
    },
    {
      "title": "Recycling Tip",
      "message":
          "Did you know? Recycling one laptop saves enough energy to power 3,500 homes for an hour!",
      "icon": LucideIcons.lightbulb,
      "time": "2 days ago",
    },
    {
      "title": "Pickup Completed",
      "message": "Your e-waste was successfully picked up. Thanks for recycling!",
      "icon": LucideIcons.checkCircle2,
      "time": "3 days ago",
    },
    {
      "title": "New Insight Available",
      "message":
          "Watch: 'What happens to your e-waste?' — Learn how recycling works.",
      "icon": LucideIcons.playCircle,
      "time": "4 days ago",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
        backgroundColor: Colors.green.shade300,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: _notifications.isEmpty
          ? const Center(
              child: Text(
                "No new notifications",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _notifications[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade100,
                      child: Icon(item['icon'], color: Colors.green.shade700),
                    ),
                    title: Text(
                      item['title'],
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    subtitle: Text(
                      item['message'],
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: Text(
                      item['time'],
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
