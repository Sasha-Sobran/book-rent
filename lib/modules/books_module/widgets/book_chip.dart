import 'package:flutter/material.dart';
import 'package:library_kursach/core/theme/theme.dart';

class BookChip extends StatelessWidget {
  final String label;
  final Color color;

  const BookChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }
}

