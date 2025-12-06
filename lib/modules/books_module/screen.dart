import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules/books_module/cubit.dart';
import 'package:library_kursach/modules/books_module/widgets/book_row.dart';

class BooksScreen extends StatelessWidget {
  static const path = '/books';

  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BooksCubit()..init(),
      child: Container(
        decoration: AppDecorations.backgroundGradient,
        child: BlocBuilder<BooksCubit, BookState>(
          builder: (context, state) => Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
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
                        child: const Icon(Icons.menu_book, color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Каталог книг', style: AppTextStyles.h3),
                            Text('${state.books.length} книг у каталозі', style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => context.read<BooksCubit>().addBook(),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Додати книгу'),
                        style: AppButtons.primary(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Divider(color: AppColors.border, height: 1),
                  const SizedBox(height: 16),
                  Expanded(
                    child: state.books.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.menu_book_outlined, size: 64, color: AppColors.textMuted),
                                const SizedBox(height: 16),
                                Text('Книг ще немає', style: AppTextStyles.h4.copyWith(color: AppColors.textMuted)),
                                const SizedBox(height: 8),
                                Text('Додайте першу книгу до каталогу', style: AppTextStyles.bodySmall),
                              ],
                            ),
                          )
                        : ListView.separated(
                            itemCount: state.books.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, index) => BookRow(book: state.books[index]),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
