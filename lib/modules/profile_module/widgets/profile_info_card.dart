import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/models/user.dart';
import 'package:library_kursach/modules/profile_module/cubit.dart';
import 'package:library_kursach/modules/profile_module/widgets/profile_info_row.dart';
import 'package:library_kursach/utils/currency_utils.dart';

class ProfileInfoCard extends StatelessWidget {
  final User? user;

  const ProfileInfoCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProfileCubit>().state;
    final isReader = user?.isReader == true;
    
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
          Text('Дані профілю', style: AppTextStyles.h4),
          const SizedBox(height: 12),
          ProfileInfoRow(label: 'Email', value: user?.email ?? '-'),
          const SizedBox(height: 10),
          ProfileInfoRow(label: 'Телефон', value: user?.phoneNumber ?? '—'),
          const SizedBox(height: 10),
          ProfileInfoRow(label: 'Роль', value: user?.role ?? '—'),
          if (isReader) ...[
            const SizedBox(height: 10),
            ProfileInfoRow(
              label: 'Категорія читача',
              value: state.readerCategoryName ?? '—',
            ),
            const SizedBox(height: 10),
            ProfileInfoRow(
              label: 'Загальний борг',
              value: CurrencyUtils.formatCurrency(state.totalDebt),
            ),
          ],
        ],
      ),
    );
  }
}

