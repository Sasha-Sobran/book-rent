import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/common_cubit/app_cubit/state.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules/profile_module/screen.dart';
import 'package:library_kursach/modules/notifications_module/widgets/notifications_button.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetItService().instance<AppCubit>(),
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          final user = state.user;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.local_library_outlined, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Text('Library', style: AppTextStyles.h4),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => context.go(ProfileScreen.path),
                  icon: const Icon(Icons.account_circle_outlined, size: 20),
                  label: Text(user != null ? '${user.surname} ${user.name}' : 'Гість'),
                  style: AppButtons.text(color: AppColors.textPrimary),
                ),
                const SizedBox(width: 8),
                if (user != null) ...[
                  const NotificationsButton(),
                  const SizedBox(width: 8),
                ],
                OutlinedButton.icon(
                  onPressed: () => GetItService().instance<AppCubit>().logout(context),
                  icon: const Icon(Icons.logout, size: 18),
                  label: const Text('Вийти'),
                  style: AppButtons.secondary,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
