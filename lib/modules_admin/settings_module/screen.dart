import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/models/settings.dart';
import 'package:library_kursach/modules_admin/settings_module/cubit.dart';

class SettingsScreen extends StatelessWidget {
  static const path = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit()..init(),
      child: Container(
        decoration: AppDecorations.backgroundGradient,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: const [
            _GenresSection(),
            SizedBox(height: 20),
            _CategoriesSection(),
            SizedBox(height: 20),
            _ReaderCategoriesSection(),
            SizedBox(height: 20),
            _PenaltyTypesSection(),
          ],
        ),
      ),
    );
  }
}
class _GenresSection extends StatelessWidget {
  const _GenresSection();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) => _SettingsCard(
        title: 'Жанри книг',
        icon: Icons.category_outlined,
        onAdd: () => _showAddDialog(context, 'Новий жанр', (name) => cubit.createGenre(context, name)),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: state.genres.map((genre) => _Chip(
            label: genre.name,
            onDelete: () => cubit.deleteGenre(context, genre.id),
          )).toList(),
        ),
      ),
    );
  }
}

class _CategoriesSection extends StatelessWidget {
  const _CategoriesSection();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) => _SettingsCard(
        title: 'Категорії книг',
        icon: Icons.folder_outlined,
        onAdd: () => _showAddDialog(context, 'Нова категорія', (name) => cubit.createCategory(context, name)),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: state.categories.map((cat) => _Chip(
            label: cat.name,
            color: AppColors.secondary,
            onDelete: () => cubit.deleteCategory(context, cat.id),
          )).toList(),
        ),
      ),
    );
  }
}

class _ReaderCategoriesSection extends StatelessWidget {
  const _ReaderCategoriesSection();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) => _SettingsCard(
        title: 'Категорії читачів',
        icon: Icons.people_outline,
        subtitle: 'Кожна категорія має свою знижку на прокат',
        onAdd: () => _showCategoryDialog(context, cubit),
        child: state.readerCategories.isEmpty
            ? Text('Немає категорій', style: AppTextStyles.bodySmall)
            : Column(
                children: state.readerCategories.map((cat) => _CategoryItem(
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

class _PenaltyTypesSection extends StatelessWidget {
  const _PenaltyTypesSection();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) => _SettingsCard(
        title: 'Типи штрафів',
        icon: Icons.warning_amber_outlined,
        subtitle: 'Види штрафів за пошкодження книг',
        onAdd: () => _showAddDialog(context, 'Новий тип штрафу', (name) => cubit.createPenaltyType(context, name)),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: state.penaltyTypes.map((type) => _Chip(
            label: type.name,
            color: AppColors.warning,
            onDelete: () => cubit.deletePenaltyType(context, type.id),
          )).toList(),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? subtitle;
  final VoidCallback onAdd;
  final Widget child;

  const _SettingsCard({
    required this.title,
    required this.icon,
    this.subtitle,
    required this.onAdd,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
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
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.h4),
                    if (subtitle != null) Text(subtitle!, style: AppTextStyles.caption),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Додати'),
                style: AppButtons.primary(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color? color;
  final VoidCallback onDelete;

  const _Chip({required this.label, this.color, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(color: chipColor, fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          InkWell(
            onTap: onDelete,
            child: Icon(Icons.close, size: 16, color: chipColor),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final ReaderCategory category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryItem({required this.category, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('Знижка: ${category.discountPercentage}%', style: AppTextStyles.caption),
              ],
            ),
          ),
          IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined, color: AppColors.secondary)),
          IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline, color: AppColors.error)),
        ],
      ),
    );
  }
}

void _showAddDialog(BuildContext context, String title, Function(String) onCreate) {
  final controller = TextEditingController();

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: AppDecorations.inputWithIcon(Icons.label_outline, 'Назва'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати')),
        ElevatedButton(
          onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              onCreate(controller.text.trim());
              Navigator.pop(ctx);
            }
          },
          style: AppButtons.primary(),
          child: const Text('Створити'),
        ),
      ],
    ),
  );
}

