import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/common_cubit/app_cubit/state.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/modules/books_module/screen.dart';

class AdminHeader extends StatelessWidget {
  const AdminHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetItService().instance<AppCubit>(),
      child: BlocBuilder<AppCubit, AppState>(
        builder:
            (context, state) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () => context.go(BooksScreen.path),
                  icon: const Icon(Icons.home),
                ),
                Text('Library App Admin'),
                IconButton(
                  onPressed:
                      () => GetItService().instance<AppCubit>().logout(context),
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
      ),
    );
  }
}
