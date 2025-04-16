import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recyclens/pages/disposing_centers.dart';
import 'package:recyclens/pages/image_scanner.dart';
import 'package:recyclens/pages/insights.dart';
import 'package:recyclens/pages/recycling_centers.dart';
import 'package:recyclens/pages/report_ewaste.dart';
import 'package:recyclens/pages/rewards.dart';
import 'package:recyclens/pages/statistics.dart';
import 'package:recyclens/pages/tracking.dart';

class HomeScreenOptions extends StatelessWidget {
  final List<_Option> options = [
    _Option('Scan E-Waste', Icons.camera_alt, Colors.orangeAccent,
        (context) => Get.to(() => ImageScanPage(), transition: Transition.cupertinoDialog)),
    _Option('Nearby Recycling Centre', Icons.recycling, Colors.greenAccent,
        (context) => Get.to(() => RecyclingCentersPage(), transition: Transition.cupertinoDialog)),
    _Option('Nearby Disposing Centre', Icons.delete_forever, Colors.redAccent,
        (context) => Get.to(() => DisposingCentersPage(), transition: Transition.cupertinoDialog)),
    _Option('Tracking', Icons.route, Colors.cyanAccent,
        (context) => Get.to(() => TrackingPage(), transition: Transition.cupertinoDialog)),
    _Option('Rewards Earned', Icons.card_giftcard, Colors.amberAccent,
        (context) => Get.to(() => RewardsPage(), transition: Transition.cupertinoDialog)),
    _Option('Report E-Waste in Public', Icons.report, Colors.pinkAccent,
        (context) => Get.to(() => ReportEwastePage(), transition: Transition.cupertinoDialog)),
    _Option('Overall Statistics', Icons.bar_chart, Colors.purpleAccent,
        (context) => Get.to(() => StatisticsPage(), transition: Transition.cupertinoDialog)),
    _Option('Insights on E-Waste', Icons.menu_book, Colors.lightBlueAccent,
        (context) => Get.to(() => InsightsPage(), transition: Transition.cupertinoDialog)),
  ];

  HomeScreenOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final double tileWidth = MediaQuery.of(context).size.width / 2 - 30;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: options
            .map((opt) => SizedBox(width: tileWidth, child: _OptionTile(option: opt)))
            .toList(),
      ),
    );
  }
}

class _Option {
  final String title;
  final IconData icon;
  final Color color;
  final void Function(BuildContext) onTap;

  const _Option(this.title, this.icon, this.color, this.onTap);
}

class _OptionTile extends StatefulWidget {
  final _Option option;

  const _OptionTile({super.key, required this.option});

  @override
  State<_OptionTile> createState() => _OptionTileState();
}

class _OptionTileState extends State<_OptionTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.option.onTap(context),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = 1 + (_controller.value * 0.015);
          return Transform.scale(
            scale: scale,
            child: Container(
              height: 160,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.35),
                    Colors.white.withOpacity(0.07),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: widget.option.color.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(color: widget.option.color.withOpacity(0.2)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          widget.option.color.withOpacity(0.5),
                          Colors.transparent
                        ],
                      ),
                    ),
                    child: Icon(widget.option.icon, color: widget.option.color, size: 32),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.option.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.95),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
