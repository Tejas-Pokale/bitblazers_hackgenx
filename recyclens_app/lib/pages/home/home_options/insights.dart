import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  final List<Map<String, String>> insights = [
    {
      'title': 'What is E-Waste Pollution?',
      'description': 'Learn about electronic pollution and its impact on the environment.',
      'youtubeUrl': 'https://www.youtube.com/watch?v=MQLadfsvfLo',
      'website': 'https://www.ewaste1.com/what-is-ewaste',
    },
    {
      'title': 'Recycling E-Waste: Good for Business and the Environment',
      'description': 'Discover how recycling e-waste benefits both businesses and the planet.',
      'youtubeUrl': 'https://www.youtube.com/watch?v=eT34ypRodB0',
      'website': 'https://earth911.com',
    },
    {
      'title': 'How E-Waste is Harming Our World',
      'description': 'Explore the detrimental effects of e-waste on our environment.',
      'youtubeUrl': 'https://www.youtube.com/watch?v=-uyIzKIw0xY',
      'website': 'https://www.unep.org/resources/report/global-e-waste-monitor-2020',
    },
    {
      'title': 'Electronic Recycling: Protecting Your Data and the Environment',
      'description': 'Understand the importance of electronic recycling for data security and environmental protection.',
      'youtubeUrl': 'https://www.youtube.com/watch?v=r-diBr0-Ky8',
      'website': 'https://www.epa.gov/recycle/electronics-donation-and-recycling',
    },
    {
      'title': 'Recycling to Stop E-Waste | TEDxYouth@ElliotStreet',
      'description': 'Learn about innovative approaches to stop e-waste through recycling.',
      'youtubeUrl': 'https://www.youtube.com/watch?v=EDL4pJfdd9U',
      'website': 'https://www.ted.com/tedx',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights on E-Waste'),
        centerTitle: true,
        backgroundColor: Colors.lightGreen.shade700,
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: insights.length,
        itemBuilder: (context, index) {
          final item = insights[index];
          final videoId = YoutubePlayer.convertUrlToId(item['youtubeUrl']!)!;

          return Card(
            margin: const EdgeInsets.only(bottom: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.lightGreen.shade50,
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title']!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['description']!,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId: videoId,
                        flags: const YoutubePlayerFlags(autoPlay: false),
                      ),
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.lightGreen,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () async {
                      final url = Uri.parse(item['website']!);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                    icon: const Icon(Icons.link, color: Colors.lightGreen),
                    label: const Text(
                      'Visit Website',
                      style: TextStyle(color: Colors.lightGreen),
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
