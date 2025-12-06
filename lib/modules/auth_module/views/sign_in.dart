import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules/auth_module/cubit.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

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
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Вхід', style: AppTextStyles.h2),
          const SizedBox(height: 8),
          Text('Введіть дані для входу', style: AppTextStyles.bodySmall),
          const SizedBox(height: 32),
          FormBuilder(
            key: cubit.signInFormKey,
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
                  name: 'password',
                  obscureText: true,
                  decoration: AppDecorations.inputWithIcon(
                    Icons.lock_outline,
                    'Пароль',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => cubit.signIn(context),
              style: AppButtons.primary(),
              child: const Text('Увійти'),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Немає акаунту?', style: AppTextStyles.bodySmall),
              TextButton(
                onPressed: () => cubit.toggleSignUp(),
                style: AppButtons.text(),
                child: const Text('Зареєструватись'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
