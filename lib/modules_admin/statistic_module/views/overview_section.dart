import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules_admin/statistic_module/cubit.dart';

class OverviewSection extends StatelessWidget {
  const OverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        final overview = state.overview;
        if (state.isLoadingOverview) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: AppDecorations.cardDecoration,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        if (overview == null) {
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
                    child: const Icon(Icons.dashboard_outlined, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text('Загальна статистика', style: AppTextStyles.h4),
                ],
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _StatCard(
                    title: 'Всього книг',
                    value: '${overview['total_books'] ?? 0}',
                    icon: Icons.menu_book_outlined,
                    color: AppColors.primary,
                  ),
                  _StatCard(
                    title: 'Всього читачів',
                    value: '${overview['total_readers'] ?? 0}',
                    icon: Icons.people_outlined,
                    color: AppColors.secondary,
                  ),
                  _StatCard(
                    title: 'Всього бібліотек',
                    value: '${overview['total_libraries'] ?? 0}',
                    icon: Icons.library_books_outlined,
                    color: AppColors.success,
                  ),
                  _StatCard(
                    title: 'Активні ренти',
                    value: '${overview['active_rents'] ?? 0}',
                    icon: Icons.assignment_outlined,
                    color: AppColors.warning,
                  ),
                  _StatCard(
                    title: 'Прострочені ренти',
                    value: '${overview['overdue_rents'] ?? 0}',
                    icon: Icons.warning_amber_rounded,
                    color: AppColors.error,
                  ),
                  _StatCard(
                    title: 'Загальний дохід',
                    value: '${(overview['total_revenue'] ?? 0.0).toStringAsFixed(2)} ₴',
                    icon: Icons.attach_money_outlined,
                    color: AppColors.success,
                  ),
                  _StatCard(
                    title: 'Штрафи',
                    value: '${(overview['total_penalties'] ?? 0.0).toStringAsFixed(2)} ₴',
                    icon: Icons.gavel_outlined,
                    color: AppColors.error,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.h3.copyWith(color: color)),
        ],
      ),
    );
  }
}

