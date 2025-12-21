import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/common_widgets/confirmation_dialog.dart';
import 'package:library_kursach/modules/readers_module/cubit.dart';
import 'package:library_kursach/modules/readers_module/widgets/reader_card.dart';
import 'package:library_kursach/modules/readers_module/widgets/reader_form_dialog.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/utils/permission_utils.dart';

class ReadersList extends StatelessWidget {
  const ReadersList({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReadersCubit>();
    final appCubit = GetItService().instance<AppCubit>();
    final isRoot = PermissionUtils.isRoot(appCubit.state.user);
    final isReadOnly = isRoot;

    return BlocBuilder<ReadersCubit, ReadersState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.readers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: AppColors.textSecondary),
                const SizedBox(height: 16),
                Text('Читачів не знайдено', style: AppTextStyles.body),
                if (!isReadOnly) ...[
                const SizedBox(height: 8),
                Text('Додайте першого читача', style: AppTextStyles.caption),
                ],
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 450,
            childAspectRatio: 2.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: state.readers.length,
          itemBuilder: (context, index) {
            final reader = state.readers[index];
            return ReaderCard(
              reader: reader,
              onEdit: isReadOnly ? null : () => showDialog(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: cubit,
                  child: ReaderFormDialog(reader: reader),
                ),
              ),
              onDelete: isReadOnly ? null : () => _confirmDelete(context, cubit, reader.id, reader.fullName),
              canNavigateToRents: !isReadOnly,
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, ReadersCubit cubit, int id, String name) {
    ConfirmationDialog.show(
      context,
      title: 'Видалити читача?',
      message: 'Ви впевнені, що хочете видалити читача "$name"?',
      confirmText: 'Видалити',
      confirmColor: AppColors.error,
    ).then((confirmed) {
      if (confirmed == true) {
        cubit.deleteReader(context, id);
      }
    });
  }
}

