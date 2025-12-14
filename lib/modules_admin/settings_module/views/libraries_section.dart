import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/common_widgets/app_snackbar.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules_admin/settings_module/cubit.dart';
import 'package:library_kursach/modules_admin/settings_module/widgets/library_item.dart';
import 'package:library_kursach/modules_admin/settings_module/widgets/settings_card.dart';

class LibrariesSection extends StatelessWidget {
  const LibrariesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) => SettingsCard(
        title: 'Бібліотеки',
        icon: Icons.local_library_outlined,
        subtitle: 'Керуйте філіями, видимі лише для root',
        onAdd: () => _showLibraryDialog(context, cubit, state),
        child: state.isLoadingLibraries
            ? const Center(child: CircularProgressIndicator())
            : state.libraries.isEmpty
                ? Text('Бібліотек поки немає', style: AppTextStyles.bodySmall)
                : Column(
                    children: state.libraries
                        .map((lib) => LibraryItem(library: lib))
                        .toList(),
                  ),
      ),
    );
  }

  void _showLibraryDialog(BuildContext context, SettingsCubit cubit, SettingsState state) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();
    int? cityId = state.cities.isNotEmpty ? state.cities.first.id : null;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Нова бібліотека'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: AppDecorations.inputWithIcon(Icons.business_outlined, 'Назва'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: cityId,
                items: state.cities
                    .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                    .toList(),
                decoration: AppDecorations.inputWithIcon(Icons.location_city_outlined, 'Місто'),
                onChanged: (v) => cityId = v,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: AppDecorations.inputWithIcon(Icons.place_outlined, 'Адреса'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: AppDecorations.inputWithIcon(Icons.phone_outlined, 'Телефон'),
              ),
              if (state.cities.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Спочатку додайте місто', style: AppTextStyles.caption.copyWith(color: AppColors.error)),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати')),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final address = addressController.text.trim();
              final phone = phoneController.text.trim();
              if (name.isEmpty || address.isEmpty || phone.isEmpty || cityId == null) {
                AppSnackbar.error(context, 'Заповніть усі поля та виберіть місто');
                return;
              }
              cubit.createLibrary(
                context,
                name: name,
                cityId: cityId!,
                address: address,
                phone: phone,
              );
              Navigator.pop(ctx);
            },
            style: AppButtons.primary(),
            child: const Text('Створити'),
          ),
        ],
      ),
    );
  }
}
