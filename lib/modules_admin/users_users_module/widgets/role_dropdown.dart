import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/models/user.dart';
import 'package:library_kursach/modules_admin/users_users_module/cubit.dart';

class RoleDropdown extends StatelessWidget {
  final void Function(int?)? onChanged;
  final List<Role>? allowedRoles;

  const RoleDropdown({
    super.key,
    this.onChanged,
    this.allowedRoles,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UsersUsersCubit>();
    final roles = allowedRoles ?? cubit.assignableRoles;

    return FormBuilderDropdown<int>(
      name: 'role_id',
      decoration: AppDecorations.inputWithIcon(Icons.badge_outlined, 'Роль'),
      items: roles.map((role) => DropdownMenuItem(value: role.id, child: Text(role.name))).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? 'Оберіть роль' : null,
    );
  }
}

