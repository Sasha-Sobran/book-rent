import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules_admin/users_users_module/cubit.dart';
import 'package:library_kursach/modules_admin/users_users_module/views/filters.dart';
import 'package:library_kursach/modules_admin/users_users_module/views/users.dart';

class ManageUsersScreen extends StatelessWidget {
  static const path = '/manage-users';

  const ManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersUsersCubit()..init(),
      child: Container(
        decoration: AppDecorations.backgroundGradient,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: const [
            FiltersScreen(),
            SizedBox(height: 20),
            UsersScreen(),
          ],
        ),
      ),
    );
  }
}
