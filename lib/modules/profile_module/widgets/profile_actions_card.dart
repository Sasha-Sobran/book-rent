import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules/profile_module/cubit.dart';
import 'package:library_kursach/modules/profile_module/widgets/edit_profile_form.dart';

class ProfileActionsCard extends StatelessWidget {
  const ProfileActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProfileCubit>().state;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Дії', style: AppTextStyles.h4),
          const SizedBox(height: 12),
          EditProfileForm(state: state),
        ],
      ),
    );
  }
}

