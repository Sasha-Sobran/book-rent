import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules_admin/event_log_module/cubit.dart';

class EventLogFilters extends StatelessWidget {
  const EventLogFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EventLogCubit>();

    return BlocBuilder<EventLogCubit, EventLogState>(
      builder: (context, state) => Container(
        padding: const EdgeInsets.all(24),
        decoration: AppDecorations.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.filter_list, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Text('Фільтри', style: AppTextStyles.h4),
                const Spacer(),
                if (state.isFiltered)
                  TextButton.icon(
                    onPressed: () => cubit.resetFilters(),
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text('Скинути'),
                    style: AppButtons.text(color: AppColors.error),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: 250,
                  child: TextField(
                    onChanged: (value) => cubit.filterBySearch(value),
                    decoration: AppDecorations.inputWithIcon(
                      Icons.search,
                      'Пошук',
                      hint: 'Пошук по опису...',
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: DropdownButtonFormField<String>(
                    value: state.selectedActionType,
                    decoration: AppDecorations.inputDecoration.copyWith(
                      labelText: 'Тип дії',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('Всі типи')),
                      DropdownMenuItem(value: 'create', child: Text('Створення')),
                      DropdownMenuItem(value: 'update', child: Text('Оновлення')),
                      DropdownMenuItem(value: 'delete', child: Text('Видалення')),
                      DropdownMenuItem(value: 'login', child: Text('Вхід')),
                    ],
                    onChanged: (value) => cubit.filterByActionType(value),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: DropdownButtonFormField<String>(
                    value: state.selectedEntityType,
                    decoration: AppDecorations.inputDecoration.copyWith(
                      labelText: 'Тип сутності',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('Всі сутності')),
                      DropdownMenuItem(value: 'book', child: Text('Книга')),
                      DropdownMenuItem(value: 'user', child: Text('Користувач')),
                      DropdownMenuItem(value: 'rent', child: Text('Рент')),
                      DropdownMenuItem(value: 'reader', child: Text('Читач')),
                      DropdownMenuItem(value: 'role', child: Text('Роль')),
                    ],
                    onChanged: (value) => cubit.filterByEntityType(value),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

