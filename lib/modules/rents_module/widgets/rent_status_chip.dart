import 'package:flutter/material.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/utils/rent_status_utils.dart';

class RentStatusChip extends StatelessWidget {
  final String status;

  const RentStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = RentStatusUtils.getColor(status);
    final label = RentStatusUtils.getLabel(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color == Colors.grey ? AppColors.textSecondary : color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

