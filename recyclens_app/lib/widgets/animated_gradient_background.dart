import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;

  const AnimatedGradientBackground({Key? key, required this.child})
      : super(key: key);

  @override
  _AnimatedGradientBackgroundState createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<AnimatedGradientBackground> {
  late List<List<Color>> gradientColors;
  int currentIndex = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    gradientColors = [
      [Colors.green.shade400, Colors.teal.shade200],
      [Colors.teal.shade300, Colors.lightGreen.shade300],
      [Colors.green.shade600, Colors.blue.shade300],
      [Colors.lightGreen.shade200, Colors.amber.shade200],
    ];

    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      setState(() {
        currentIndex = (currentIndex + 1) % gradientColors.length;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 5),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors[currentIndex],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: widget.child,
    );
  }
}
