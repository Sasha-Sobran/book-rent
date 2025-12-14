import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/models/user.dart';
import 'package:library_kursach/modules_admin/users_users_module/cubit.dart';
import 'package:library_kursach/modules_admin/users_users_module/widgets/user_role_dropdown.dart';

class UserEditModal extends StatelessWidget {
  final User user;

  const UserEditModal({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UsersUsersCubit>();
    final currentRoleId = cubit.state.roles.firstWhere((r) => r.name == user.role, orElse: () => cubit.state.roles.first).id;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 420,
        constraints: const BoxConstraints(maxHeight: 620),
        decoration: AppDecorations.modalDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: AppDecorations.gradientHeader(colors: AppColors.gradientSecondary),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.edit, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Редагування', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('${user.name} ${user.surname}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close, color: Colors.white70)),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: FormBuilder(
                  key: cubit.userEditFormKey,
                  initialValue: {'role_id': currentRoleId, 'name': user.name, 'surname': user.surname, 'email': user.email, 'phone_number': user.phoneNumber ?? '', 'password': ''},
                  child: Column(
                    children: [
                      UserRoleDropdown(currentRoleId: currentRoleId),
                      const SizedBox(height: 16),
                      FormBuilderTextField(name: 'name', decoration: AppDecorations.inputWithIcon(Icons.person_outline, 'Імʼя')),
                      const SizedBox(height: 16),
                      FormBuilderTextField(name: 'surname', decoration: AppDecorations.inputWithIcon(Icons.person_outline, 'Прізвище')),
                      const SizedBox(height: 16),
                      FormBuilderTextField(name: 'email', decoration: AppDecorations.inputWithIcon(Icons.email_outlined, 'Email')),
                      const SizedBox(height: 16),
                      FormBuilderTextField(name: 'password', obscureText: true, decoration: AppDecorations.inputWithIcon(Icons.lock_outline, 'Новий пароль', hint: 'Залиште пустим, щоб не змінювати')),
                      const SizedBox(height: 16),
                      FormBuilderTextField(name: 'phone_number', decoration: AppDecorations.inputWithIcon(Icons.phone_outlined, 'Телефон')),
                    ],
                  ),
                ),
              ),
            ),
            BlocBuilder<UsersUsersCubit, UsersUsersState>(
              builder: (context, state) => Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20))),
                child: Row(
                  children: [
                    Expanded(child: OutlinedButton(onPressed: state.isSubmitting ? null : () => Navigator.of(context).pop(), style: AppButtons.secondary, child: const Text('Скасувати'))),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: state.isSubmitting ? null : () => cubit.editUserFromForm(context, user.id!),
                        style: AppButtons.primary(color: AppColors.secondary),
                        child: state.isSubmitting ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Зберегти'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
