import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/utils/permission_utils.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules/books_module/cubit.dart';
import 'package:library_kursach/modules/books_module/widgets/book_form_dialog.dart';
import 'package:library_kursach/modules/books_module/widgets/book_row.dart';
import 'package:library_kursach/modules/books_module/widgets/filters.dart';

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
          builder: (context, state) {
            final appCubit = GetItService().instance<AppCubit>();
            final user = appCubit.state.user;
            final canManage = PermissionUtils.canManageBooks(user);
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
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
                          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
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
                        ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 200, maxWidth: 400),
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Builder(
                                builder: (_) {
                                  final hasMatch = state.selectedLibrary != null &&
                                      state.libraries.any((l) => l.id == state.selectedLibrary!.id);
                                  final dropdownValue = hasMatch ? state.selectedLibrary!.id : null;
                                  final items = <DropdownMenuItem<int?>>[];
                                  if (state.libraries.isEmpty) {
                                    items.add(
                                      const DropdownMenuItem<int?>(
                                        value: null,
                                        enabled: false,
                                        child: Text('Бібліотек немає'),
                                      ),
                                    );
                                  } else {
                                    items.add(
                                      const DropdownMenuItem<int?>(
                                        value: null,
                                        child: Text('Усі бібліотеки'),
                                      ),
                                    );
                                    items.addAll(
                                      state.libraries.map(
                                        (l) {
                                          final isMine = l.id == state.myLibraryId;
                                          final label = '${l.name}${l.cityName != null ? ' • ${l.cityName}' : ''}';
                                          return DropdownMenuItem<int?>(
                                            value: l.id,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    label,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                if (isMine)
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 6),
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primary.withValues(alpha: 0.1),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Text(
                                                      'Моя',
                                                      style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }

                                  return DropdownButtonFormField<int?>(
                                    value: dropdownValue,
                                    decoration: AppDecorations.inputWithIcon(Icons.location_city_outlined, 'Бібліотека'),
                                    items: items,
                                    onChanged: state.libraries.isEmpty
                                        ? null
                                        : (id) {
                                            if (id == null) {
                                              context.read<BooksCubit>().selectLibrary(null);
                                            } else {
                                              final selected = state.libraries.firstWhere((l) => l.id == id);
                                              context.read<BooksCubit>().selectLibrary(selected);
                                            }
                                          },
                                  );
                                },
                              ),
                              if (state.isLoadingLibraries)
                                const Positioned(
                                  right: 8,
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (canManage)
                          ElevatedButton.icon(
                            onPressed: () => showDialog(
                              context: context,
                              builder: (_) => BlocProvider.value(
                                value: context.read<BooksCubit>(),
                                child: const BookFormDialog(),
                              ),
                            ),
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Додати книгу'),
                            style: AppButtons.primary(),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    BooksFilters(state: state),
                    const SizedBox(height: 8),
                    Divider(color: AppColors.border, height: 1),
                    const SizedBox(height: 16),
                    Expanded(
                      child: state.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : state.books.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.menu_book_outlined, size: 64, color: AppColors.textMuted),
                                      const SizedBox(height: 16),
                                      Text('Книг ще немає', style: AppTextStyles.h4.copyWith(color: AppColors.textMuted)),
                                      const SizedBox(height: 8),
                                      if (canManage)
                                        Text('Додайте першу книгу до каталогу', style: AppTextStyles.bodySmall),
                                    ],
                                  ),
                                )
                              : LayoutBuilder(
                                  builder: (context, constraints) {
                                    int cross = 1;
                                    if (constraints.maxWidth >= 1200) {
                                      cross = 6;
                                    } else if (constraints.maxWidth >= 900) {
                                      cross = 5;
                                    } else if (constraints.maxWidth >= 600) {
                                      cross = 4;
                                    }
                                    return GridView.builder(
                                      padding: EdgeInsets.zero,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: cross,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                        childAspectRatio: .85,
                                      ),
                                      itemCount: state.books.length,
                                      itemBuilder: (context, index) => BookRow(book: state.books[index]),
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
