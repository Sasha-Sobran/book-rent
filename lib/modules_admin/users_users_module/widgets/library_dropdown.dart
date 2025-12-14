import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules_admin/users_users_module/cubit.dart';

class LibraryDropdown extends StatelessWidget {
  const LibraryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UsersUsersCubit>();

    return FormBuilderDropdown<int>(
      name: 'library_id',
      decoration: AppDecorations.inputWithIcon(Icons.location_city_outlined, 'Бібліотека'),
      items: cubit.state.libraries
          .map((l) => DropdownMenuItem(value: l.id, child: Text('${l.name}${l.cityName != null ? ' • ${l.cityName}' : ''}')))
          .toList(),
      validator: (v) => v == null ? 'Оберіть бібліотеку' : null,
    );
  }
}

