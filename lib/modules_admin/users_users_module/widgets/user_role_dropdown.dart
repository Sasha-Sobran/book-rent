import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/models/user.dart';
import 'package:library_kursach/modules_admin/users_users_module/cubit.dart';

class UserRoleDropdown extends StatelessWidget {
  final int currentRoleId;

  const UserRoleDropdown({super.key, required this.currentRoleId});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UsersUsersCubit>();
    final allowedRoles = cubit.assignableRoles;
    final allowedRoleIds = allowedRoles.map((r) => r.id).toSet();
    final currentRole = cubit.state.roles.firstWhere(
      (r) => r.id == currentRoleId,
      orElse: () => Role(id: -1, name: ''),
    );
    final dropdownRoles = [
      ...allowedRoles,
      if (!allowedRoleIds.contains(currentRole.id) && currentRole.id != -1) currentRole,
    ];

    return FormBuilderDropdown(
      name: 'role_id',
      decoration: AppDecorations.inputWithIcon(Icons.badge_outlined, 'Роль'),
      items: dropdownRoles
          .map(
            (role) => DropdownMenuItem(
              value: role.id,
              enabled: allowedRoleIds.contains(role.id),
              child: Text(
                allowedRoleIds.contains(role.id) ? role.name : '${role.name} (недоступно)',
              ),
            ),
          )
          .toList(),
    );
  }
}

