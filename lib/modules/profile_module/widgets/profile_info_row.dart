import 'package:flutter/material.dart';
import 'package:library_kursach/core/theme/theme.dart';

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 130, child: Text(label, style: AppTextStyles.caption)),
        const SizedBox(width: 12),
        Expanded(child: Text(value, style: AppTextStyles.body)),
      ],
    );
  }
}

