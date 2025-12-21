import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/models/user.dart';
import 'package:library_kursach/modules_admin/users_users_module/cubit.dart';

class RoleItem extends StatelessWidget {
  final Role role;

  const RoleItem({super.key, required this.role});

  IconData _getRoleIcon() {
    switch (role.name.toLowerCase()) {
      case 'root': return Icons.security;
      case 'librarian': return Icons.library_books;
      case 'reader': return Icons.person;
      default: return Icons.badge;
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleColor = AppColors.roleColor(role.name);
    final roleIcon = _getRoleIcon();

    return BlocBuilder<UsersUsersCubit, UsersUsersState>(
      builder: (context, state) {
        final isSelected = state.selectedRoleId == role.id;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.read<UsersUsersCubit>().filterByRole(role.id),
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 90,
              decoration: BoxDecoration(
                color: isSelected ? roleColor.withValues(alpha: 0.15) : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? roleColor : AppColors.border, width: isSelected ? 2 : 1),
                boxShadow: isSelected
                    ? [BoxShadow(color: roleColor.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))]
                    : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: roleColor.withValues(alpha: isSelected ? 0.2 : 0.1), borderRadius: BorderRadius.circular(10)),
                    child: Icon(roleIcon, color: roleColor, size: 22),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    role.name,
                    style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, color: isSelected ? roleColor : AppColors.textSecondary),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
