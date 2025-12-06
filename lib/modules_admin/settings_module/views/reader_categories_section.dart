import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/models/settings.dart';
import 'package:library_kursach/modules_admin/settings_module/cubit.dart';
import 'package:library_kursach/modules_admin/settings_module/widgets/settings_card.dart';
import 'package:library_kursach/modules_admin/settings_module/widgets/reader_category_item.dart';

class ReaderCategoriesSection extends StatelessWidget {
  const ReaderCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) => SettingsCard(
        title: 'Категорії читачів',
        icon: Icons.people_outline,
        subtitle: 'Кожна категорія має свою знижку на прокат',
        onAdd: () => _showCategoryDialog(context, cubit),
        child: state.readerCategories.isEmpty
            ? Text('Немає категорій', style: AppTextStyles.bodySmall)
            : Column(
                children: state.readerCategories.map((cat) => ReaderCategoryItem(
                  category: cat,
                  onEdit: () => _showCategoryDialog(context, cubit, category: cat),
                  onDelete: () => cubit.deleteReaderCategory(context, cat.id),
                )).toList(),
              ),
      ),
    );
  }

  void _showCategoryDialog(BuildContext context, SettingsCubit cubit, {ReaderCategory? category}) {
    final nameController = TextEditingController(text: category?.name ?? '');
    final discountController = TextEditingController(text: category?.discountPercentage.toString() ?? '0');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(category == null ? 'Нова категорія' : 'Редагувати категорію'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: AppDecorations.inputWithIcon(Icons.label_outline, 'Назва'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: discountController,
              keyboardType: TextInputType.number,
              decoration: AppDecorations.inputWithIcon(Icons.percent, 'Знижка (%)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final discount = int.tryParse(discountController.text) ?? 0;
              if (name.isNotEmpty) {
                if (category == null) {
                  cubit.createReaderCategory(context, name, discount);
                } else {
                  cubit.updateReaderCategory(context, category.id, name, discount);
                }
                Navigator.pop(ctx);
              }
            },
            style: AppButtons.primary(),
            child: Text(category == null ? 'Створити' : 'Зберегти'),
          ),
        ],
      ),
    );
  }
}

