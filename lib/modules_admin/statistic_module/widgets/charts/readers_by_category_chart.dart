import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:library_kursach/core/theme/theme.dart';

class ReadersByCategoryChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const ReadersByCategoryChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Text('Немає даних', style: AppTextStyles.bodySmall),
      );
    }

    final total = data.fold<int>(
      0,
      (sum, item) => sum + (item['reader_count'] as int? ?? 0),
    );

    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.success,
      AppColors.warning,
      AppColors.info,
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Розподіл читачів по категоріях', style: AppTextStyles.h3),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 60,
                sections: data.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final count = item['reader_count'] as int? ?? 0;
                  final percentage = total > 0 ? (count / total * 100) : 0.0;
                  
                  return PieChartSectionData(
                    value: count.toDouble(),
                    title: '${percentage.toStringAsFixed(1)}%',
                    color: colors[index % colors.length],
                    radius: 100,
                    titleStyle: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: data.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final count = item['reader_count'] as int? ?? 0;
              final categoryName = item['category_name'] as String? ?? '';
              
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: colors[index % colors.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$categoryName: $count',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              );
            }).toList(),
          ),
          if (total > 0)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Center(
                child: Text(
                  'Всього: $total читачів',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

