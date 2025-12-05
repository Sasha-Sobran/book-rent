import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/modules_admin/users_users_module/cubit.dart';
import 'package:library_kursach/modules_admin/users_users_module/views/roles.dart';
import 'package:library_kursach/modules_admin/users_users_module/views/users.dart';

class ManageUsersScreen extends StatelessWidget {
  static const path = '/manage-users';

  const ManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersUsersCubit()..init(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          RolesScreen(),
          UsersScreen(),
        ],
      ),
    );
  }
}
