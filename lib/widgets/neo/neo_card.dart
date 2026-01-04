import 'dart:ui';

import 'package:flutter/material.dart';

import '../../config/theme.dart';

class NeoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final Color? color;
  final Color? borderColor;

  const NeoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.color,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppColors.cardDark;

    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: cardColor.withOpacity(0.92),
          borderRadius: borderRadius,
          border:
              Border.all(color: borderColor ?? Colors.white.withOpacity(0.06)),
        ),
        child: child,
      ),
    );
  }
}
