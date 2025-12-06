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
        builder: (context, state) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () => context.go(BooksScreen.path),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.local_library, color: AppColors.primary, size: 24),
                ),
              ),
              const SizedBox(width: 12),
              Text('Library Admin', style: AppTextStyles.h4.copyWith(color: AppColors.primary)),
              const Spacer(),
              if (state.user != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person, size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(state.user!.name, style: AppTextStyles.label),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
              ],
              IconButton(
                onPressed: () => GetItService().instance<AppCubit>().logout(context),
                icon: const Icon(Icons.logout, color: AppColors.textSecondary),
                tooltip: 'Вийти',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
