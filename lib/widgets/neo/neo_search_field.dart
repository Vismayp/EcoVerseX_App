import 'package:flutter/material.dart';

import '../../config/theme.dart';

class NeoSearchField extends StatelessWidget {
  const NeoSearchField({
    super.key,
    this.hintText,
    this.controller,
    this.onChanged,
    this.trailingIcon,
    this.onTrailingTap,
  });

  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceInput,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(Icons.search, color: AppColors.mutedOnDark),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.onDark),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.mutedOnDark),
                border: InputBorder.none,
              ),
            ),
          ),
          if (trailingIcon != null)
            IconButton(
              onPressed: onTrailingTap,
              icon: Icon(trailingIcon, color: AppColors.mutedOnDark),
            )
          else
            const SizedBox(width: 10),
        ],
      ),
    );
  }
}
