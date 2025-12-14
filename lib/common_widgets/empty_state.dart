import 'package:flutter/material.dart';
import 'package:library_kursach/core/theme/theme.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.textMuted),
          const SizedBox(height: 16),
          Text(title, style: AppTextStyles.h4.copyWith(color: AppColors.textMuted)),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle!, style: AppTextStyles.bodySmall),
          ],
          if (action != null) ...[
            const SizedBox(height: 16),
            action!,
          ],
        ],
      ),
    );
  }
}

