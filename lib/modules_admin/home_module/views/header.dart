import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/common_cubit/app_cubit/state.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules/books_module/screen.dart';

class AdminHeader extends StatelessWidget {
  const AdminHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: GetItService().instance<AppCubit>(),
      child: BlocBuilder<AppCubit, AppState>(
        builder:
            (context, state) => Container(
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.security_outlined,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('Адміністратор', style: AppTextStyles.h4),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => context.go(BooksScreen.path),
                    icon: const Icon(Icons.local_library_outlined, size: 18),
                    label: const Text('На головну'),
                    style: AppButtons.text(color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 12),
                  if (state.user != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${state.user!.surname} ${state.user!.name}',
                            style: AppTextStyles.label,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed:
                        () =>
                            GetItService().instance<AppCubit>().logout(context),
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('Вийти'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
