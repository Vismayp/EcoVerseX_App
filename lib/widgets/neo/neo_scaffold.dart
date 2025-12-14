import 'dart:ui';

import 'package:flutter/material.dart';

import '../../config/theme.dart';

class NeoScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool extendBody;

  const NeoScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.extendBody = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: extendBody,
      backgroundColor: AppColors.backgroundDark,
      appBar: appBar,
      body: Stack(
        children: [
          const _AmbientGlowBackground(),
          SafeArea(child: body),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

class _AmbientGlowBackground extends StatelessWidget {
  const _AmbientGlowBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -120,
            left: -120,
            child: Container(
              width: 320,
              height: 220,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.18),
                borderRadius: BorderRadius.circular(220),
              ),
            ),
          ),
          Positioned(
            bottom: -140,
            right: -140,
            child: Container(
              width: 320,
              height: 240,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(240),
              ),
            ),
          ),
          const _BlurLayer(),
        ],
      ),
    );
  }
}

class _BlurLayer extends StatelessWidget {
  const _BlurLayer();

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 48, sigmaY: 48),
      child: const SizedBox.expand(),
    );
  }
}
