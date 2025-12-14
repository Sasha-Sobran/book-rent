import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/models/user.dart';
import 'package:library_kursach/modules/profile_module/cubit.dart';
import 'package:library_kursach/modules/profile_module/widgets/profile_info_card.dart';
import 'package:library_kursach/modules/profile_module/widgets/profile_actions_card.dart';
import 'package:library_kursach/modules/profile_module/widgets/profile_chip.dart';

class ProfileScreen extends StatelessWidget {
  static const path = '/profile';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appCubit = GetItService().instance<AppCubit>();
    return BlocProvider(
      create: (_) => ProfileCubit()..loadUser(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final user = state.user ?? appCubit.state.user;
          return Container(
            decoration: AppDecorations.backgroundGradient,
            width: double.infinity,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 980),
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: AppDecorations.cardDecoration,
                child: ListView(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          child: Text(
                            _initials(user),
                            style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user != null ? '${user.surname} ${user.name}' : 'Анонім', style: AppTextStyles.h3),
                              const SizedBox(height: 6),
                              Text(user?.email ?? '-', style: AppTextStyles.bodySmall),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  ProfileChip(label: user?.role ?? '-', color: AppColors.primary),
                                  if (user?.phoneNumber != null && user!.phoneNumber!.isNotEmpty)
                                    ProfileChip(label: user.phoneNumber!, color: AppColors.secondary),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 720;
                        return isWide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: ProfileInfoCard(user: user)),
                                  const SizedBox(width: 16),
                                  Expanded(child: ProfileActionsCard()),
                                ],
                              )
                            : Column(
                                children: [
                                  ProfileInfoCard(user: user),
                                  const SizedBox(height: 16),
                                  ProfileActionsCard(),
                                ],
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _initials(User? user) {
    if (user == null) return '?';
    final n = user.name.isNotEmpty ? user.name[0] : '';
    final s = user.surname.isNotEmpty ? user.surname[0] : '';
    return (s + n).toUpperCase();
  }
}

