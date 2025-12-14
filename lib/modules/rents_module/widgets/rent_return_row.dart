import 'package:flutter/material.dart';
import 'package:library_kursach/core/theme/theme.dart';

class RentReturnRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isEmph;

  const RentReturnRow({
    super.key,
    required this.title,
    required this.value,
    this.isEmph = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppTextStyles.bodySmall)),
          Text(
            value,
            style: isEmph ? AppTextStyles.h4.copyWith(color: AppColors.primary) : AppTextStyles.bodySmall,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}

