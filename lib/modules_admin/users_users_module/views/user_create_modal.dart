import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules_admin/users_users_module/cubit.dart';

class UserCreateModal extends StatelessWidget {
  const UserCreateModal({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UsersUsersCubit>();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 420,
        constraints: const BoxConstraints(maxHeight: 600),
        decoration: AppDecorations.modalDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: AppDecorations.gradientHeader(),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.person_add, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Новий користувач', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Заповніть форму для створення', style: TextStyle(color: Colors.white70, fontSize: 13)),
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
                  key: cubit.userCreateFormKey,
                  child: Column(
                    children: [
                      _buildDropdown(cubit),
                      const SizedBox(height: 16),
                      FormBuilderTextField(name: 'name', decoration: AppDecorations.inputWithIcon(Icons.person_outline, 'Імʼя')),
                      const SizedBox(height: 16),
                      FormBuilderTextField(name: 'surname', decoration: AppDecorations.inputWithIcon(Icons.person_outline, 'Прізвище')),
                      const SizedBox(height: 16),
                      FormBuilderTextField(name: 'email', decoration: AppDecorations.inputWithIcon(Icons.email_outlined, 'Email')),
                      const SizedBox(height: 16),
                      FormBuilderTextField(name: 'password', obscureText: true, decoration: AppDecorations.inputWithIcon(Icons.lock_outline, 'Пароль')),
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
                        onPressed: state.isSubmitting ? null : () => cubit.createUser(context),
                        style: AppButtons.primary(),
                        child: state.isSubmitting ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Створити'),
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

  Widget _buildDropdown(UsersUsersCubit cubit) {
    return FormBuilderDropdown(
      name: 'role_id',
      decoration: AppDecorations.inputWithIcon(Icons.badge_outlined, 'Роль'),
      items: cubit.state.roles.map((role) => DropdownMenuItem(value: role.id, child: Text(role.name))).toList(),
    );
  }
}
