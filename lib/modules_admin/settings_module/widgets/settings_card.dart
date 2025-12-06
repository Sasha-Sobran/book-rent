import 'package:flutter/material.dart';
import 'package:library_kursach/core/theme/theme.dart';

class SettingsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? subtitle;
  final VoidCallback onAdd;
  final Widget child;

  const SettingsCard({
    super.key,
    required this.title,
    required this.icon,
    this.subtitle,
    required this.onAdd,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppDecorations.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.h4),
                    if (subtitle != null) Text(subtitle!, style: AppTextStyles.caption),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Додати'),
                style: AppButtons.primary(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

