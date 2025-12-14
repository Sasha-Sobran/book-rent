import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/common_widgets/confirmation_dialog.dart';
import 'package:library_kursach/modules/readers_module/cubit.dart';
import 'package:library_kursach/modules/readers_module/widgets/reader_card.dart';
import 'package:library_kursach/modules/readers_module/widgets/reader_form_dialog.dart';

class ReadersList extends StatelessWidget {
  const ReadersList({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReadersCubit>();

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
                const SizedBox(height: 8),
                Text('Додайте першого читача', style: AppTextStyles.caption),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 450,
            childAspectRatio: 1.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: state.readers.length,
          itemBuilder: (context, index) {
            final reader = state.readers[index];
            return ReaderCard(
              reader: reader,
              onEdit: () => showDialog(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: cubit,
                  child: ReaderFormDialog(reader: reader),
                ),
              ),
              onDelete: () => _confirmDelete(context, cubit, reader.id, reader.fullName),
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

