import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/models/user.dart';
import 'package:library_kursach/modules_admin/users_users_module/cubit.dart';
import 'package:library_kursach/modules_admin/users_users_module/views/user_edit_modal.dart';

class UserItem extends StatelessWidget {
  final User user;

  const UserItem({super.key, required this.user});

  IconData _getIconForRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin': return Icons.admin_panel_settings;
      case 'librarian': return Icons.library_books;
      case 'reader': return Icons.person;
      case 'root': return Icons.security;
      default: return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UsersUsersCubit>();
    final appCubit = GetItService().instance<AppCubit>();
    final roleColor = AppColors.roleColor(user.role);
    final canEdit = appCubit.state.user?.isRoot == true || (appCubit.state.user?.isAdmin == true && user.role != 'root');
    final canDelete = user.role != 'root';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: canEdit ? () => _showEditModal(context, cubit) : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(color: roleColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(_getIconForRole(user.role), color: roleColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('${user.name} ${user.surname}', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: roleColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                            child: Text(user.role, style: TextStyle(color: roleColor, fontSize: 11, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.email_outlined, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 6),
                          Text(user.email, style: AppTextStyles.caption),
                          if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) ...[
                            const SizedBox(width: 16),
                            Icon(Icons.phone_outlined, size: 14, color: AppColors.textMuted),
                            const SizedBox(width: 6),
                            Text(user.phoneNumber!, style: AppTextStyles.caption),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (canEdit) _ActionButton(icon: Icons.edit_outlined, color: AppColors.secondary, onTap: () => _showEditModal(context, cubit)),
                    if (canDelete) ...[
                      const SizedBox(width: 8),
                      _ActionButton(icon: Icons.delete_outline, color: AppColors.error, onTap: () => _showDeleteConfirmation(context, cubit)),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditModal(BuildContext context, UsersUsersCubit cubit) {
    showDialog(context: context, builder: (_) => BlocProvider.value(value: cubit, child: UserEditModal(user: user)));
  }

  void _showDeleteConfirmation(BuildContext context, UsersUsersCubit cubit) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Видалити користувача?'),
        content: Text('Ви впевнені, що хочете видалити ${user.name} ${user.surname}?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Скасувати')),
          ElevatedButton(
            onPressed: () { Navigator.of(ctx).pop(); cubit.deleteUser(context, user.id!); },
            style: AppButtons.danger,
            child: const Text('Видалити'),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(padding: const EdgeInsets.all(8), child: Icon(icon, color: color, size: 20)),
      ),
    );
  }
}
