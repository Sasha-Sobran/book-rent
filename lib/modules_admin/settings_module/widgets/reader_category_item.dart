import 'package:flutter/material.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/models/settings.dart';

class ReaderCategoryItem extends StatelessWidget {
  final ReaderCategory category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ReaderCategoryItem({super.key, required this.category, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('Знижка: ${category.discountPercentage}%', style: AppTextStyles.caption),
              ],
            ),
          ),
          IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined, color: AppColors.secondary)),
          IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline, color: AppColors.error)),
        ],
      ),
    );
  }
}

