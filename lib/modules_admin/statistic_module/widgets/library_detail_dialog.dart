import 'package:flutter/material.dart';
import 'package:library_kursach/core/theme/theme.dart';

class LibraryDetailDialog extends StatelessWidget {
  final Map<String, dynamic> library;

  const LibraryDetailDialog({super.key, required this.library});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: AppDecorations.modalDecoration,
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.library_books_outlined, color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          library['library_name'] ?? '',
                          style: AppTextStyles.h3,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          library['city_name'] ?? '',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 24),
              _buildStatCard(
                'Книги',
                '${library['total_books'] ?? 0}',
                Icons.menu_book_outlined,
                AppColors.primary,
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                'Всього рентів',
                '${library['total_rents'] ?? 0}',
                Icons.assignment_outlined,
                AppColors.secondary,
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                'Активні ренти',
                '${library['active_rents'] ?? 0}',
                Icons.check_circle_outline,
                AppColors.warning,
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                'Прострочені ренти',
                '${library['overdue_rents'] ?? 0}',
                Icons.warning_amber_rounded,
                AppColors.error,
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                'Повернуті ренти',
                '${library['returned_rents'] ?? 0}',
                Icons.done_all_outlined,
                AppColors.success,
              ),
              const SizedBox(height: 24),
              Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 24),
              _buildStatCard(
                'Загальний дохід',
                '${(library['total_revenue'] ?? 0.0).toStringAsFixed(2)} ₴',
                Icons.attach_money_outlined,
                AppColors.success,
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                'Дохід від зданих книг',
                '${(library['confirmed_revenue'] ?? 0.0).toStringAsFixed(2)} ₴',
                Icons.verified_outlined,
                AppColors.success,
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                'Штрафи',
                '${(library['total_penalties'] ?? 0.0).toStringAsFixed(2)} ₴',
                Icons.gavel_outlined,
                AppColors.error,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: AppButtons.primary(),
                  child: const Text('Закрити'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(value, style: AppTextStyles.h4.copyWith(color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

