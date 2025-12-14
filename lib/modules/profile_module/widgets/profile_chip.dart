import 'package:flutter/material.dart';
import 'package:library_kursach/core/theme/theme.dart';

class ProfileChip extends StatelessWidget {
  final String label;
  final Color color;

  const ProfileChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

