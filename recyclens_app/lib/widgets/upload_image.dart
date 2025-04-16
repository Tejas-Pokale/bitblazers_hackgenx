import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

class FancyUploadButton extends StatefulWidget {
  final VoidCallback onTap;
  final String heroTag;

  const FancyUploadButton({
    super.key,
    required this.onTap,
    this.heroTag = "uploadButtonHero",
  });

  @override
  State<FancyUploadButton> createState() => _FancyUploadButtonState();
}

class _FancyUploadButtonState extends State<FancyUploadButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (_, child) {
        double glow = 8 + (_glowController.value * 12); // Animate glow radius
        return Hero(
          tag: widget.heroTag,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onTap();
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glowing background
                Container(
                  width: 230,
                  height: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.greenAccent.withOpacity(0.5),
                        blurRadius: glow,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                // Glassmorphic + shimmer button
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Shimmer.fromColors(
                      baseColor: Colors.green.shade500,
                      highlightColor: Colors.tealAccent.shade100,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 35, vertical: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white.withOpacity(0.05)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.upload_rounded,
                                color: Colors.white, size: 26),
                            SizedBox(width: 12),
                            Text(
                              "Upload Image",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
