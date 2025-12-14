import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/api/cities_api.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules_admin/settings_module/cubit.dart';
import 'package:library_kursach/modules_admin/settings_module/views/add_dialog.dart';
import 'package:library_kursach/modules_admin/settings_module/widgets/settings_card.dart';

class CitiesSection extends StatelessWidget {
  const CitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) => SettingsCard(
        title: 'Міста',
        icon: Icons.location_city_outlined,
        subtitle: 'Довідник міст для бібліотек',
        onAdd: () => showAddDialog(context, 'Нове місто', (name) => cubit.createCity(context, name)),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: state.cities
              .map((c) => _CityPill(city: c))
              .toList(),
        ),
      ),
    );
  }
}

class _CityPill extends StatelessWidget {
  final City city;

  const _CityPill({required this.city});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
      ),
      child: Text(city.name, style: AppTextStyles.caption.copyWith(color: AppColors.secondary, fontWeight: FontWeight.w600)),
    );
  }
}
