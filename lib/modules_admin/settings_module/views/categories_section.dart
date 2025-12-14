import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/common_widgets/confirmation_dialog.dart';
import 'package:library_kursach/modules_admin/settings_module/cubit.dart';
import 'package:library_kursach/modules_admin/settings_module/widgets/settings_card.dart';
import 'package:library_kursach/modules_admin/settings_module/widgets/settings_chip.dart';
import 'package:library_kursach/modules_admin/settings_module/views/add_dialog.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) => SettingsCard(
        title: 'Категорії книг',
        icon: Icons.folder_outlined,
        onAdd: () => showAddDialog(context, 'Нова категорія', (name) => cubit.createCategory(context, name)),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: state.categories
              .map(
                (cat) => SettingsChip(
                  label: cat.name,
                  color: AppColors.secondary,
                  onDelete: () => _confirmDelete(context, 'категорію "${cat.name}"', () => cubit.deleteCategory(context, cat.id)),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String itemLabel, VoidCallback onConfirm) {
    ConfirmationDialog.show(
      context,
      title: 'Підтвердьте видалення',
      message: 'Видалити $itemLabel?',
      confirmText: 'Видалити',
      confirmColor: AppColors.error,
    ).then((confirmed) {
      if (confirmed == true) {
        onConfirm();
      }
    });
  }
}

