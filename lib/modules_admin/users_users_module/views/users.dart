import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/modules_admin/users_users_module/cubit.dart';
import 'package:library_kursach/modules_admin/users_users_module/widgets/user_item.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersUsersCubit, UsersUsersState>(
      builder:
          (context, state) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Users'),
              ...state.users.map((user) => UserItem(user: user)),
            ],
          ),
    );
  }
}
