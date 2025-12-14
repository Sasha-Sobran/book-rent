import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/utils/image_utils.dart';
import 'package:library_kursach/models/book.dart';
import 'package:library_kursach/modules/books_module/cubit.dart';
import 'package:library_kursach/modules/books_module/widgets/book_detail_dialog.dart';

class BookRow extends StatelessWidget {
  final Book book;

  const BookRow({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder:
              (_) => BlocProvider.value(
                value: context.read<BooksCubit>(),
                child: BookDetailDialog(book: book),
              ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBookImage(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    book.author,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildAvailability(),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '${book.price.toStringAsFixed(0)} ₴',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailability() {
    if (book.quantity == 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'Немає в наявності',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'К-сть: ${book.quantity}',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildBookImage() {
    final imageUrl = ImageUtils.buildImageUrl(book.imageUrl);

    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: imageUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => const Center(
                        child: Icon(
                          Icons.menu_book,
                          color: AppColors.primary,
                          size: 36,
                        ),
                      ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                ),
              )
              : const Center(
                child: Icon(
                  Icons.menu_book,
                  color: AppColors.primary,
                  size: 36,
                ),
              ),
    );
  }
}
