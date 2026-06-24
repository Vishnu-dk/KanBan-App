import 'package:flutter/material.dart';
import 'package:frontend/main.dart';

class ProfileStatCard extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;
  final Color accentColor;

  const ProfileStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: accentColor, size: 30),
          ),

          AnimatedCounter(
            value: value,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: secondary,
            ),
          ),

          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: secondary.withValues(alpha:0.65),
            ),
          ),
        ],
      ),
    );
  }
}


class AnimatedCounter extends StatelessWidget {
  final int value;
  final TextStyle style;

  const AnimatedCounter({
    super.key,
    required this.value,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      builder: (_, val, __) {
        return Text(val.toString(), style: style);
      },
    );
  }
}