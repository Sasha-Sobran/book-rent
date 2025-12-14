import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules_admin/settings_module/cubit.dart';
import 'package:library_kursach/modules_admin/settings_module/views/categories_section.dart';
import 'package:library_kursach/modules_admin/settings_module/views/cities_section.dart';
import 'package:library_kursach/modules_admin/settings_module/views/genres_section.dart';
import 'package:library_kursach/modules_admin/settings_module/views/libraries_section.dart';
import 'package:library_kursach/modules_admin/settings_module/views/penalty_types_section.dart';
import 'package:library_kursach/modules_admin/settings_module/views/reader_categories_section.dart';

class SettingsScreen extends StatelessWidget {
  static const path = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isRoot = GetItService().instance<AppCubit>().state.user?.isRoot ?? false;

    return BlocProvider(
      create: (_) => SettingsCubit()..init(isRoot: isRoot),
      child: Container(
        decoration: AppDecorations.backgroundGradient,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const GenresSection(),
            const SizedBox(height: 20),
            const CategoriesSection(),
            const SizedBox(height: 20),
            const ReaderCategoriesSection(),
            if (isRoot) ...[
              const SizedBox(height: 20),
              const LibrariesSection(),
              const SizedBox(height: 20),
              const CitiesSection(),
            ],
            const SizedBox(height: 20),
            const PenaltyTypesSection(),
          ],
        ),
      ),
    );
  }
}
