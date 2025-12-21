import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules/main_module/cubit.dart';
import 'package:library_kursach/modules/my_rents_module/screen.dart';
import 'package:library_kursach/modules/rents_module/screen.dart';
import 'package:library_kursach/modules/books_module/screen.dart';
import 'package:library_kursach/utils/permission_utils.dart';
import 'package:library_kursach/utils/date_utils.dart' as app_date;
import 'package:library_kursach/modules/rents_module/utils/rent_calculations.dart';
import 'package:library_kursach/modules/books_module/widgets/book_row.dart';
import 'package:library_kursach/modules/books_module/cubit.dart';

class MainScreen extends StatelessWidget {
  static const path = '/main';

  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit()..init(context),
      child: Container(
        decoration: AppDecorations.backgroundGradient,
        child: BlocBuilder<MainCubit, MainState>(
          builder: (context, state) {
            final appCubit = GetItService().instance<AppCubit>();
            final user = appCubit.state.user;
            final isLibrarian = PermissionUtils.canManageRents(user);

            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isLibrarian) _LibrarianDashboard(state: state) else _ReaderDashboard(state: state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ReaderDashboard extends StatelessWidget {
  final MainState state;

  const _ReaderDashboard({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Головна', style: AppTextStyles.h3),
        const SizedBox(height: 24),
        if (state.popularBooks.isNotEmpty) ...[
          _SectionCard(
            title: 'Популярні книги',
            icon: Icons.trending_up_outlined,
            color: AppColors.success,
            onViewAll: () => context.go(BooksScreen.path),
            childPadding: const EdgeInsets.symmetric(horizontal: -20),
            child: _PopularBooksList(books: state.popularBooks),
          ),
          const SizedBox(height: 16),
        ],
        if (state.activeRents.isNotEmpty) ...[
          _SectionCard(
            title: 'Мої активні ренти',
            count: state.activeRents.length,
            icon: Icons.assignment_outlined,
            color: AppColors.primary,
            onViewAll: () => context.go(MyRentsScreen.path),
            child: _RentsList(rents: state.activeRents.take(3).toList()),
          ),
          const SizedBox(height: 16),
        ],
        if (state.overdueRents.isNotEmpty) ...[
          _SectionCard(
            title: 'Прострочені ренти',
            count: state.overdueRents.length,
            icon: Icons.warning_amber_rounded,
            color: AppColors.error,
            onViewAll: () => context.go(MyRentsScreen.path),
            child: _RentsList(rents: state.overdueRents.take(3).toList(), isOverdue: true),
          ),
          const SizedBox(height: 16),
        ],
        if (state.recentRents.isNotEmpty) ...[
          _SectionCard(
            title: 'Останні орендовані книги',
            icon: Icons.history_outlined,
            color: AppColors.secondary,
            child: _RecentRentsList(rents: state.recentRents),
          ),
        ],
      ],
    );
  }
}

class _LibrarianDashboard extends StatelessWidget {
  final MainState state;

  const _LibrarianDashboard({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Головна', style: AppTextStyles.h3),
        const SizedBox(height: 16),
        const SizedBox(height: 24),
        if (state.activeRents.isNotEmpty) ...[
          _SectionCard(
            title: 'Активні ренти',
            count: state.activeRents.length,
            icon: Icons.assignment_outlined,
            color: AppColors.primary,
            onViewAll: () => context.go(RentsScreen.path),
            child: _RentsList(rents: state.activeRents.take(5).toList()),
          ),
          const SizedBox(height: 16),
        ],
        if (state.overdueRents.isNotEmpty) ...[
          _SectionCard(
            title: 'Прострочені ренти',
            count: state.overdueRents.length,
            icon: Icons.warning_amber_rounded,
            color: AppColors.error,
            onViewAll: () => context.go(RentsScreen.path),
            child: _RentsList(rents: state.overdueRents.take(5).toList(), isOverdue: true),
          ),
          const SizedBox(height: 16),
        ],
        if (state.recentRents.isNotEmpty) ...[
          _SectionCard(
            title: 'Останні дії',
            icon: Icons.history_outlined,
            color: AppColors.secondary,
            child: _RentsList(rents: state.recentRents),
          ),
        ],
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final int? count;
  final IconData icon;
  final Color color;
  final Widget child;
  final VoidCallback? onViewAll;
  final EdgeInsets? childPadding;

  const _SectionCard({
    required this.title,
    this.count,
    required this.icon,
    required this.color,
    required this.child,
    this.onViewAll,
    this.childPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.h4,
                ),
              ),
              if (count != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$count',
                    style: AppTextStyles.bodySmall.copyWith(color: color, fontWeight: FontWeight.w600),
                  ),
                ),
              if (onViewAll != null) ...[
                const SizedBox(width: 12),
                TextButton(
                  onPressed: onViewAll,
                  child: const Text('Переглянути всі'),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          childPadding != null
              ? Transform.translate(
                  offset: Offset(childPadding!.horizontal / 2, 0),
                  child: child,
                )
              : child,
        ],
      ),
    );
  }
}

class _RentsList extends StatelessWidget {
  final List<dynamic> rents;
  final bool isOverdue;

  const _RentsList({required this.rents, this.isOverdue = false});

  @override
  Widget build(BuildContext context) {
    if (rents.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: rents.map((rent) {
        final bookTitle = rent.bookTitle;
        final expectedReturn = rent.expectedReturnDate;
        final readerName = rent.readerName;
        final calculation = RentCalculations.calculateRentAmounts(rent);
        final rentIsOverdue = calculation.isOverdue;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (isOverdue || rentIsOverdue)
                ? AppColors.error.withValues(alpha: 0.05)
                : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: (isOverdue || rentIsOverdue) 
                  ? AppColors.error.withValues(alpha: 0.3) 
                  : AppColors.border,
              width: (isOverdue || rentIsOverdue) ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(bookTitle, style: AppTextStyles.body),
                        ),
                        if (rentIsOverdue && !isOverdue)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Прострочено',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(readerName, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                    if (expectedReturn != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Повернути до: ${app_date.AppDateUtils.formatDate(expectedReturn)}',
                        style: AppTextStyles.caption.copyWith(
                          color: (isOverdue || rentIsOverdue) 
                              ? AppColors.error 
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _RecentRentsList extends StatelessWidget {
  final List<dynamic> rents;

  const _RecentRentsList({required this.rents});

  @override
  Widget build(BuildContext context) {
    if (rents.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: rents.map((rent) {
        final bookTitle = rent.bookTitle;
        final rentDate = rent.rentDate;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bookTitle, style: AppTextStyles.body),
                    if (rentDate != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        app_date.AppDateUtils.formatDate(rentDate),
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _PopularBooksList extends StatelessWidget {
  final List<dynamic> books;

  const _PopularBooksList({required this.books});

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const SizedBox.shrink();
    }

    return BlocProvider(
      create: (context) => BooksCubit()..init(),
      child: Container(
              padding: const EdgeInsets.only(left: 40),

        height: 280,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          itemCount: books.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final book = books[index];
            return SizedBox(
              width: 220,
              child: BookRow(book: book),
            );
          },
        ),
      ),
    );
  }
}