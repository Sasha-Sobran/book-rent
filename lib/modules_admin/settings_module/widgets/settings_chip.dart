import 'package:flutter/material.dart';
import 'package:library_kursach/core/theme/theme.dart';

class SettingsChip extends StatelessWidget {
  final String label;
  final Color? color;
  final VoidCallback onDelete;

  const SettingsChip({super.key, required this.label, this.color, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(color: chipColor, fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          InkWell(
            onTap: onDelete,
            child: Icon(Icons.close, size: 16, color: chipColor),
          ),
        ],
      ),
    );
  }
}

