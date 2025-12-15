import 'dart:ui';

import 'package:flutter/material.dart';

import '../../config/theme.dart';

class NeoBottomNavContainer extends StatelessWidget {
  final Widget child;

  const NeoBottomNavContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundDark.withOpacity(0.88),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.06)),
            ),
          ),
          padding: const EdgeInsets.only(bottom: 14, top: 6),
          child: child,
        ),
      ),
    );
  }
}
