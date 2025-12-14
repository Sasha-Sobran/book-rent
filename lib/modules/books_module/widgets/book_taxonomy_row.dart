import 'package:flutter/material.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules/books_module/widgets/book_tag.dart';

class BookTaxonomyRow extends StatelessWidget {
  final String title;
  final List<String> items;

  const BookTaxonomyRow({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final display = items.take(4).toList();
    final remaining = items.length - display.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        items.isEmpty
            ? Text('—', style: AppTextStyles.caption.copyWith(color: AppColors.textMuted))
            : Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  ...display.map((e) => BookTag(label: e)),
                  if (remaining > 0) BookTag(label: '+$remaining'),
                ],
              ),
      ],
    );
  }
}

