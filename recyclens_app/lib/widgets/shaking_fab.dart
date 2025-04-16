import 'package:flutter/material.dart';
import 'dart:math' as math;

class ShakingFAB extends StatefulWidget {
  final VoidCallback onPressed;

  const ShakingFAB({Key? key, required this.onPressed}) : super(key: key);

  @override
  _ShakingFABState createState() => _ShakingFABState();
}

class _ShakingFABState extends State<ShakingFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _animation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticIn),
    );

    // Trigger the shake repeatedly
    _startShakingLoop();
  }

  void _startShakingLoop() {
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 1));
      if (mounted) {
        _controller.forward().then((_) => _controller.reverse());
      }
      return true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: FloatingActionButton(
        onPressed: widget.onPressed,
        backgroundColor: Colors.green.shade600,
        child: Icon(Icons.chat_bubble, color: Colors.white),
      ),
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value * math.pi,
          child: child,
        );
      },
    );
  }
}
