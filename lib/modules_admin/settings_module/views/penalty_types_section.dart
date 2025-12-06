import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules_admin/settings_module/cubit.dart';
import 'package:library_kursach/modules_admin/settings_module/widgets/settings_card.dart';
import 'package:library_kursach/modules_admin/settings_module/widgets/settings_chip.dart';
import 'package:library_kursach/modules_admin/settings_module/views/add_dialog.dart';

class PenaltyTypesSection extends StatelessWidget {
  const PenaltyTypesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) => SettingsCard(
        title: 'Типи штрафів',
        icon: Icons.warning_amber_outlined,
        subtitle: 'Види штрафів за пошкодження книг',
        onAdd: () => showAddDialog(context, 'Новий тип штрафу', (name) => cubit.createPenaltyType(context, name)),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: state.penaltyTypes.map((type) => SettingsChip(
            label: type.name,
            color: AppColors.warning,
            onDelete: () => cubit.deletePenaltyType(context, type.id),
          )).toList(),
        ),
      ),
    );
  }
}

