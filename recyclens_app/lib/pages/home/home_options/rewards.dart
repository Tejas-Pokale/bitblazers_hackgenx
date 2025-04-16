import 'package:flutter/material.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  // Mock data for rewards and badges (replace with your actual data)
  final List<Reward> rewards = [
    Reward(
      title: 'Eco Warrior Badge',
      description: 'Awarded for completing 5 e-waste pickups.',
      imageUrl: 'assets/eco_warrior_badge.png', // Replace with your image asset
      earned: true,
    ),
    Reward(
      title: 'Recycling Champion',
      description: 'Earn a 10% discount on your next pickup.',
      imageUrl: 'assets/recycling_champion.png', // Replace with your image asset
      earned: true,
    ),
    Reward(
      title: 'Green Innovator',
      description: 'Awarded for referring 3 friends.',
      imageUrl: 'assets/green_innovator.png', // Replace with your image asset
      earned: false,
    ),
    Reward(
      title: 'First Pickup Bonus',
      description: 'Earned for completing first pickup.',
      imageUrl: 'assets/first_pickup.png',
      earned: true,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Rewards'),
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Achievements',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[900],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: rewards.length,
                itemBuilder: (context, index) {
                  return RewardCard(reward: rewards[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Reward {
  final String title;
  final String description;
  final String imageUrl;
  final bool earned;

  Reward({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.earned,
  });
}

class RewardCard extends StatelessWidget {
  final Reward reward;

  const RewardCard({required this.reward, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(reward.imageUrl), // Ensure assets are declared in pubspec.yaml
                  fit: BoxFit.cover,
                  colorFilter: reward.earned
                      ? null
                      : const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.color,
                        ), // Grey out if not earned
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reward.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reward.description,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            if (reward.earned)
              const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }
}