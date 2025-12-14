import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules_admin/users_users_module/cubit.dart';
import 'package:library_kursach/modules_admin/users_users_module/widgets/role_item.dart';

class FiltersScreen extends StatelessWidget {
  const FiltersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UsersUsersCubit>();

    return BlocBuilder<UsersUsersCubit, UsersUsersState>(
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
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.filter_list, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Text('Фільтри', style: AppTextStyles.h4),
                const Spacer(),
                if (state.isFiltered)
                  TextButton.icon(
                    onPressed: () => cubit.resetFilter(),
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text('Скинути'),
                    style: AppButtons.text(color: AppColors.error),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    onChanged: (value) => cubit.filterByQuery(value),
                    controller: cubit.searchController,
                    decoration: AppDecorations.inputWithIcon(Icons.search, 'Пошук', hint: 'Пошук за імʼям, email...'),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Фільтр по ролі', style: AppTextStyles.label),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 90,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.roles.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) => RoleItem(role: state.roles[index]),
                        ),
                      ),
                    ],
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
