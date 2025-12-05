import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/common_cubit/app_cubit/state.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/modules_admin/statistic_module/screen.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final appCubit = GetItService().instance<AppCubit>();
    final isAdminOrRoot = appCubit.state.user?.isAdmin == true || appCubit.state.user?.isRoot == true;
    print(isAdminOrRoot);
    return BlocProvider.value(
      value: GetItService().instance<AppCubit>(),
      child: BlocBuilder<AppCubit, AppState>(
        builder:
            (context, state) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (state.user?.isAdmin == true || state.user?.isRoot == true)
                  IconButton(
                    onPressed: () => context.go(StatisticScreen.path),
                    icon: const Icon(Icons.admin_panel_settings_outlined),
                  ),
                Text('Library App'),
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
