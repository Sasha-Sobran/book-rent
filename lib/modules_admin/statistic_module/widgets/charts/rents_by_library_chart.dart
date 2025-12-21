import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:library_kursach/core/theme/theme.dart';

class RentsByLibraryChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const RentsByLibraryChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Text('Немає даних', style: AppTextStyles.bodySmall),
      );
    }

    final libraries = <String>{};
    final statuses = <String>{};
    final libraryData = <String, Map<String, int>>{};

    for (final item in data) {
      final libraryName = item['library_name'] as String? ?? '';
      final statusName = item['status_name'] as String? ?? '';
      final count = item['rent_count'] as int? ?? 0;

      libraries.add(libraryName);
      statuses.add(statusName);

      if (!libraryData.containsKey(libraryName)) {
        libraryData[libraryName] = {};
      }
      libraryData[libraryName]![statusName] = count;
    }

    final libraryList = libraries.toList()..sort();
    final statusList = statuses.toList()..sort();

    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.success,
      AppColors.warning,
      AppColors.error,
      AppColors.info,
    ];

    final maxCount = libraryData.values.fold<int>(
      0,
      (max, statusMap) {
        final total = statusMap.values.fold<int>(0, (sum, count) => sum + count);
        return max > total ? max : total;
      },
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Розподіл рентів по бібліотеках', style: AppTextStyles.h3),
          const SizedBox(height: 20),
          SizedBox(
            height: libraryList.length * 60.0 + 80,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxCount * 1.2,
                groupsSpace: 12,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.surface,
                    tooltipRoundedRadius: 8,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < libraryList.length) {
                          final name = libraryList[value.toInt()];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              name,
                              style: AppTextStyles.caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 60,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: AppTextStyles.caption,
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxCount > 0 ? maxCount / 5 : 1,
                ),
                borderData: FlBorderData(show: false),
                barGroups: libraryList.asMap().entries.map((entry) {
                  final index = entry.key;
                  final libraryName = entry.value;
                  final statusMap = libraryData[libraryName] ?? {};

                  return BarChartGroupData(
                    x: index,
                    groupVertically: true,
                    barRods: statusList.asMap().entries.map((statusEntry) {
                      final statusIndex = statusEntry.key;
                      final statusName = statusEntry.value;
                      final count = statusMap[statusName] ?? 0;

                      return BarChartRodData(
                        toY: count.toDouble(),
                        color: colors[statusIndex % colors.length],
                        width: 16,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(2),
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: statusList.asMap().entries.map((entry) {
              final index = entry.key;
              final statusName = entry.value;
              
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: colors[index % colors.length],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    statusName,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

