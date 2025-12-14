import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules/auth_module/cubit.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return Container(
      width: 400,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Реєстрація', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          Text('Створіть новий акаунт', style: AppTextStyles.bodySmall),
          const SizedBox(height: 32),
          FormBuilder(
            key: cubit.signUpFormKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'email',
                  decoration: AppDecorations.inputWithIcon(
                    Icons.email_outlined,
                    'Email',
                  ),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'name',
                  decoration: AppDecorations.inputWithIcon(
                    Icons.person_outline,
                    'Імʼя',
                  ),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'surname',
                  decoration: AppDecorations.inputWithIcon(
                    Icons.person_outline,
                    'Прізвище',
                  ),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'password',
                  obscureText: true,
                  decoration: AppDecorations.inputWithIcon(
                    Icons.lock_outline,
                    'Пароль',
                  ),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'confirm_password',
                  obscureText: true,
                  decoration: AppDecorations.inputWithIcon(
                    Icons.lock_outline,
                    'Підтвердіть пароль',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => cubit.signUp(context),
              style: AppButtons.primary(),
              child: const Text('Зареєструватись'),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Вже є акаунт?', style: AppTextStyles.bodySmall),
              TextButton(
                onPressed: () => cubit.toggleSignUp(),
                style: AppButtons.text(),
                child: const Text('Увійти'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
