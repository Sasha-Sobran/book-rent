import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules/profile_module/cubit.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key, required this.state});
  final ProfileState state;

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _surnameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final u = widget.state.user;
    _nameCtrl.text = u?.name ?? '';
    _surnameCtrl.text = u?.surname ?? '';
    _phoneCtrl.text = u?.phoneNumber ?? '';
    _emailCtrl.text = u?.email ?? '';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _surnameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = widget.state.isSaving;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Редагувати профіль', style: AppTextStyles.h4),
          const SizedBox(height: 12),
          TextFormField(
            controller: _nameCtrl,
            decoration: AppDecorations.inputWithIcon(Icons.person_outline, 'Імʼя'),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _surnameCtrl,
            decoration: AppDecorations.inputWithIcon(Icons.person_outline, 'Прізвище'),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _phoneCtrl,
            decoration: AppDecorations.inputWithIcon(Icons.phone_outlined, 'Телефон'),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailCtrl,
            decoration: AppDecorations.inputWithIcon(Icons.mail_outline, 'Email'),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordCtrl,
            decoration: AppDecorations.inputWithIcon(Icons.lock_outline, 'Новий пароль (опційно)'),
            obscureText: true,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: isSaving
                  ? null
                  : () {
                      if (!_formKey.currentState!.validate()) return;
                      context.read<ProfileCubit>().updateUser(
                            name: _nameCtrl.text.trim().isEmpty ? null : _nameCtrl.text.trim(),
                            surname: _surnameCtrl.text.trim().isEmpty ? null : _surnameCtrl.text.trim(),
                            phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
                            email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
                            password: _passwordCtrl.text.trim().isEmpty ? null : _passwordCtrl.text.trim(),
                          );
                    },
              icon: isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.save, size: 18),
              label: const Text('Зберегти'),
              style: AppButtons.primary(),
            ),
          ),
        ],
      ),
    );
  }
}


