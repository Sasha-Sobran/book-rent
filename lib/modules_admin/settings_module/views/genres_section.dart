import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/modules_admin/settings_module/cubit.dart';
import 'package:library_kursach/modules_admin/settings_module/widgets/settings_card.dart';
import 'package:library_kursach/modules_admin/settings_module/widgets/settings_chip.dart';
import 'package:library_kursach/modules_admin/settings_module/views/add_dialog.dart';

class GenresSection extends StatelessWidget {
  const GenresSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) => SettingsCard(
        title: 'Жанри книг',
        icon: Icons.category_outlined,
        onAdd: () => showAddDialog(context, 'Новий жанр', (name) => cubit.createGenre(context, name)),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: state.genres.map((genre) => SettingsChip(
            label: genre.name,
            onDelete: () => cubit.deleteGenre(context, genre.id),
          )).toList(),
        ),
      ),
    );
  }
}

