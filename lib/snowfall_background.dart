import 'package:flutter/material.dart';
import 'package:snow_fall_animation/snow_fall_animation.dart';

class SnowfallBackground extends StatelessWidget {
  final Widget child;
  const SnowfallBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[900]!, Colors.blue[700]!],
              ),
            ),
          ),

          SnowFallAnimation(
            config: SnowfallConfig(
              numberOfSnowflakes: 200,
              speed: 1.0,
              useEmoji: true,
              enableRandomOpacity: true,
              customEmojis: ['❄️', '❅', '❆'],
            ),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}
