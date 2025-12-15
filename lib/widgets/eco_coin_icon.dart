import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../config/theme.dart';

class EcoCoinIcon extends StatelessWidget {
  const EcoCoinIcon({super.key, this.size = 16});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.primary.withOpacity(0.22)),
      ),
      padding: EdgeInsets.all(size * 0.18),
      child: Icon(
        Icons.eco,
        color: AppColors.primary,
        size: size * 0.7,
      ),
    );
  }
}

class EcoCoinAmount extends StatelessWidget {
  const EcoCoinAmount({
    super.key,
    required this.amount,
    this.textStyle,
    this.iconSize = 16,
    this.gap = 6,
  });

  final String amount;
  final TextStyle? textStyle;
  final double iconSize;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        EcoCoinIcon(size: iconSize),
        SizedBox(width: gap),
        Text(amount, style: textStyle),
      ],
    );
  }
}
