import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/models/book.dart';
import 'package:library_kursach/modules/books_module/cubit.dart';

class BookRow extends StatelessWidget {
  final Book book;

  const BookRow({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.menu_book, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book.title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(book.author, style: AppTextStyles.caption),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () => context.read<BooksCubit>().editBook(book),
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.edit_outlined, color: AppColors.secondary, size: 20)),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () => context.read<BooksCubit>().deleteBook(book),
                  borderRadius: BorderRadius.circular(8),
                  child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.delete_outline, color: AppColors.error, size: 20)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
