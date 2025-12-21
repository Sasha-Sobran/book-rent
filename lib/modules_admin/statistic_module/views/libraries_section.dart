import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules_admin/statistic_module/cubit.dart';
import 'package:library_kursach/modules_admin/statistic_module/widgets/library_detail_dialog.dart';

class LibrariesSection extends StatelessWidget {
  const LibrariesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        if (state.isLoadingLibraries) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: AppDecorations.cardDecoration,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state.librariesStatistics.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: AppDecorations.cardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.library_books_outlined, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text('Статистика по бібліотеках', style: AppTextStyles.h4),
                ],
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  int cross = 1;
                  if (constraints.maxWidth >= 1200) {
                    cross = 4;
                  } else if (constraints.maxWidth >= 900) {
                    cross = 3;
                  } else if (constraints.maxWidth >= 600) {
                    cross = 2;
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cross,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.6,
                    ),
                    itemCount: state.librariesStatistics.length,
                    itemBuilder: (context, index) {
                      final lib = state.librariesStatistics[index];
                      return _LibraryCard(lib: lib);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LibraryCard extends StatelessWidget {
  final Map<String, dynamic> lib;

  const _LibraryCard({required this.lib});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => LibraryDetailDialog(library: lib),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.library_books_outlined, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        lib['library_name'] ?? '',
                        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  lib['city_name'] ?? '',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatRow(label: 'Книги', value: '${lib['total_books'] ?? 0}', icon: Icons.menu_book_outlined),
                const SizedBox(height: 6),
                _StatRow(label: 'Ренти', value: '${lib['total_rents'] ?? 0}', icon: Icons.assignment_outlined),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: _StatRow(
                        label: 'Активні',
                        value: '${lib['active_rents'] ?? 0}',
                        icon: Icons.check_circle_outline,
                        color: AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _StatRow(
                        label: 'Прострочені',
                        value: '${lib['overdue_rents'] ?? 0}',
                        icon: Icons.warning_amber_rounded,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.attach_money_outlined, size: 14, color: AppColors.success),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${(lib['total_revenue'] ?? 0.0).toStringAsFixed(2)} ₴',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color ?? AppColors.textSecondary),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            '$label: $value',
            style: AppTextStyles.caption.copyWith(
              color: color ?? AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
