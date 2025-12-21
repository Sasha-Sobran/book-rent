import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules/readers_module/cubit.dart';
import 'package:library_kursach/modules/readers_module/widgets/reader_form_dialog.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/utils/permission_utils.dart';

class ReadersHeader extends StatelessWidget {
  const ReadersHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReadersCubit>();
    final appCubit = GetItService().instance<AppCubit>();
    final isRoot = PermissionUtils.isRoot(appCubit.state.user);
    final isReadOnly = isRoot;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppDecorations.cardDecoration,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.people_alt_outlined, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Картотека читачів', style: AppTextStyles.h3),
                const SizedBox(height: 4),
                BlocBuilder<ReadersCubit, ReadersState>(
                  builder: (context, state) => Text(
                    'Всього: ${state.readers.length} читачів',
                    style: AppTextStyles.caption,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 280,
            child: TextField(
              controller: cubit.searchController,
              decoration: AppDecorations.inputWithIcon(Icons.search, 'Пошук за ім\'ям, прізвищем, телефоном...'),
              onChanged: (v) => cubit.search(v),
            ),
          ),
          const SizedBox(width: 16),
          if (!isReadOnly)
          ElevatedButton.icon(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => BlocProvider.value(value: cubit, child: const ReaderFormDialog()),
            ),
            icon: const Icon(Icons.person_add_outlined),
            label: const Text('Додати читача'),
            style: AppButtons.primary(),
          ),
        ],
      ),
    );
  }
}

