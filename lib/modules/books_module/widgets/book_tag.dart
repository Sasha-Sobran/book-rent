import 'package:flutter/material.dart';
import 'package:library_kursach/core/theme/theme.dart';

class BookTag extends StatelessWidget {
  final String label;

  const BookTag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Text(label, style: AppTextStyles.caption),
    );
  }
}

