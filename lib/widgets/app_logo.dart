import 'package:flutter/material.dart';
import '../config/theme.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final Color? color;
  final bool withBackground;

  const AppLogo({
    super.key,
    this.size = 40,
    this.color,
    this.withBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!withBackground) {
      return Icon(
        Icons.eco_rounded,
        size: size,
        color: color ?? AppColors.primary,
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.25),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.eco_rounded,
          size: size * 0.6,
          color: Colors.white,
        ),
      ),
    );
  }
}
