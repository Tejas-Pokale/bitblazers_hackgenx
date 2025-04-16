import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  final List<Map<String, dynamic>> pickups = [
    {
      'pickupId': 'PICKUP123',
      'title': 'Home Pickup - Mobile Devices',
      'steps': [
        {
          'title': 'Pickup Requested',
          'subtitle': 'We received your request.',
          'timestamp': 'Apr 16, 09:00 AM',
          'status': 'completed',
          'icon': LucideIcons.filePlus
        },
        {
          'title': 'Agent Assigned',
          'subtitle': 'John is assigned for pickup.',
          'timestamp': 'Apr 16, 09:30 AM',
          'status': 'completed',
          'icon': LucideIcons.user
        },
        {
          'title': 'Out for Pickup',
          'subtitle': 'John is on the way.',
          'timestamp': 'Apr 16, 10:00 AM',
          'status': 'current',
          'icon': LucideIcons.truck
        },
        {
          'title': 'Pickup Completed',
          'subtitle': 'Awaiting agent confirmation.',
          'timestamp': '',
          'status': 'pending',
          'icon': LucideIcons.checkCircle
        },
      ]
    },
    {
      'pickupId': 'PICKUP456',
      'title': 'Office Pickup - Old Laptop',
      'steps': [
        {
          'title': 'Pickup Requested',
          'subtitle': 'Request submitted successfully.',
          'timestamp': 'Apr 15, 04:00 PM',
          'status': 'completed',
          'icon': LucideIcons.filePlus
        },
        {
          'title': 'Agent Assigned',
          'subtitle': 'Priya is your agent.',
          'timestamp': 'Apr 15, 04:30 PM',
          'status': 'completed',
          'icon': LucideIcons.user
        },
        {
          'title': 'Out for Pickup',
          'subtitle': 'Agent is on route.',
          'timestamp': 'Apr 15, 05:00 PM',
          'status': 'completed',
          'icon': LucideIcons.truck
        },
        {
          'title': 'Pickup Completed',
          'subtitle': 'E-waste collected successfully.',
          'timestamp': 'Apr 15, 06:00 PM',
          'status': 'completed',
          'icon': LucideIcons.checkCircle
        },
      ]
    }
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green.shade300;
      case 'current':
        return Colors.black;
      case 'pending':
      default:
        return Colors.grey.shade400;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'completed':
        return Icons.check_circle;
      case 'current':
        return Icons.radio_button_checked;
      case 'pending':
      default:
        return Icons.radio_button_unchecked;
    }
  }

  Widget buildStepItem(Map<String, dynamic> step, bool isLast) {
    return Stack(
      children: [
        if (!isLast)
          Positioned(
            left: 26,
            top: 0,
            bottom: 0,
            child: Container(
              width: 2,
              color: Colors.grey.shade300,
            ),
          ),
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicator
              Container(
                width: 52,
                alignment: Alignment.center,
                child: Icon(
                  getStatusIcon(step['status']),
                  color: getStatusColor(step['status']),
                  size: 28,
                ),
              ),
              // Content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            step['icon'],
                            color: Colors.green.shade300,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            step['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        step['subtitle'],
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                      if (step['timestamp'].isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            step['timestamp'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade300,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickup Tracking'),
        backgroundColor: Colors.green.shade300,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 1,
      ),
      backgroundColor: Colors.grey.shade100,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pickups.length,
        itemBuilder: (context, index) {
          final pickup = pickups[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_shipping_rounded,
                          color: Colors.black87),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          pickup['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Text(
                        pickup['pickupId'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(
                    pickup['steps'].length,
                    (i) => buildStepItem(
                      pickup['steps'][i],
                      i == pickup['steps'].length - 1,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
