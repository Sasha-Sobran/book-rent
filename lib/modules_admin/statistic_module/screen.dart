import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules_admin/statistic_module/cubit.dart';
import 'package:library_kursach/modules_admin/statistic_module/views/overview_section.dart';
import 'package:library_kursach/modules_admin/statistic_module/views/libraries_section.dart';
import 'package:library_kursach/modules_admin/statistic_module/widgets/charts/rents_by_status_chart.dart';
import 'package:library_kursach/modules_admin/statistic_module/widgets/charts/books_by_library_chart.dart';
import 'package:library_kursach/modules_admin/statistic_module/widgets/charts/readers_by_category_chart.dart';
import 'package:library_kursach/modules_admin/statistic_module/widgets/charts/rents_by_library_chart.dart';

class StatisticScreen extends StatelessWidget {
  static const path = '/statistic';

  const StatisticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatisticsCubit()..loadAll(),
      child: Container(
        decoration: AppDecorations.backgroundGradient,
        child: BlocBuilder<StatisticsCubit, StatisticsState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const OverviewSection(),
                const SizedBox(height: 20),
                const LibrariesSection(),
                const SizedBox(height: 20),
                if (state.isLoadingCharts)
                  const Center(child: CircularProgressIndicator())
                else ...[
                  RentsByStatusChart(data: state.rentsByStatusChart),
                  const SizedBox(height: 20),
                  BooksByLibraryChart(data: state.booksByLibraryChart),
                  const SizedBox(height: 20),
                  ReadersByCategoryChart(data: state.readersByCategoryChart),
                  const SizedBox(height: 20),
                  RentsByLibraryChart(data: state.rentsByLibraryChart),
                  const SizedBox(height: 20),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
