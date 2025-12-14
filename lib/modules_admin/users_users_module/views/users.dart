import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules_admin/users_users_module/cubit.dart';
import 'package:library_kursach/modules_admin/users_users_module/views/user_create_modal.dart';
import 'package:library_kursach/modules_admin/users_users_module/widgets/user_item.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersUsersCubit, UsersUsersState>(
      builder: (context, state) {
        final cubit = context.read<UsersUsersCubit>();

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: AppDecorations.cardDecoration,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.people, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Користувачі', style: AppTextStyles.h4),
                        Text('${state.users.length} ${_getUsersWord(state.users.length)}', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => showDialog(context: context, builder: (_) => BlocProvider.value(value: cubit, child: const UserCreateModal())),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Додати'),
                    style: AppButtons.primary(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 16),
              if (state.isLoading)
                const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
              else if (state.users.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.people_outline, size: 48, color: AppColors.textMuted),
                        const SizedBox(height: 12),
                        Text('Користувачів не знайдено', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                )
              else
                ...state.users.map((user) => UserItem(user: user)),
            ],
          ),
        );
      },
    );
  }

  String _getUsersWord(int count) {
    if (count == 1) return 'користувач';
    if (count >= 2 && count <= 4) return 'користувачі';
    return 'користувачів';
  }
}
