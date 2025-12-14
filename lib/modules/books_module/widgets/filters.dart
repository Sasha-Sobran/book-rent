import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/models/settings.dart';
import 'package:library_kursach/modules/books_module/cubit.dart';
import 'package:library_kursach/modules/books_module/widgets/multi_filter_selector.dart';

class BooksFilters extends StatelessWidget {
  const BooksFilters({super.key, required this.state});

  final BookState state;

  @override
  Widget build(BuildContext context) {
    final booksCubit = context.read<BooksCubit>();
    final hasFilters = state.searchQuery.isNotEmpty || state.selectedGenreIds.isNotEmpty || state.selectedCategoryIds.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.filter_list, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Text('Фільтри', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
            const Spacer(),
            if (hasFilters)
              TextButton.icon(
                onPressed: () => booksCubit.resetFilters(),
                icon: const Icon(Icons.clear, size: 16),
                label: const Text('Скинути'),
                style: AppButtons.text(color: AppColors.error),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              flex: 13,
              child: TextField(
                controller: booksCubit.searchController,
                onChanged: (v) => booksCubit.filterByQuery(v),
                decoration: AppDecorations.inputWithIcon(Icons.search, 'Пошук', hint: 'Назва або автор'),
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              flex: 2,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 120, maxWidth: 170),
                child: MultiFilterSelector<Genre>(
                  label: 'Жанри',
                  items: state.genres,
                  selectedIds: state.selectedGenreIds,
                  resetTick: state.resetTick,
                  display: (g) => g.name,
                  onSelect: (ids) => booksCubit.filterByGenres(ids),
                  emptyText: 'Немає жанрів',
                  showLabel: false,
                  placeholder: 'Жанри',
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: MultiFilterSelector<Category>(
                label: 'Категорії',
                items: state.categories,
                selectedIds: state.selectedCategoryIds,
                resetTick: state.resetTick,
                display: (c) => c.name,
                onSelect: (ids) => booksCubit.filterByCategories(ids),
                emptyText: 'Немає категорій',
                showLabel: false,
                placeholder: 'Категорії',
              ),
            ),
          ],
        ),
      ],
    );
  }
}


