import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/modules_admin/users_users_module/cubit.dart';
import 'package:library_kursach/modules_admin/users_users_module/widgets/role_item.dart';

class RolesScreen extends StatelessWidget {
  static const path = '/roles';

  const RolesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersUsersCubit, UsersUsersState>(
      builder:
          (context, state) => Column(
            children: [
                  Text('Roles'),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...state.roles.map((role) => RoleItem(role: role)),
                ],
              ),
            ],
          ),
    );
  }
}
