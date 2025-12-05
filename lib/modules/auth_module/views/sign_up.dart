import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:library_kursach/common_widgets/primary_text_builder_field.dart';
import 'package:library_kursach/modules/auth_module/cubit.dart';
import 'package:library_kursach/modules/auth_module/widgets/auth_button.dart';

class SignUpView extends StatelessWidget {
  static const path = '/sign-up';

  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return BlocBuilder<AuthCubit, AuthState>(
      builder:
          (context, state) => Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.3,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Registration',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Fill in the form to register'),
                  ],
                ),
                FormBuilder(
                  key: authCubit.signUpFormKey,
                  initialValue: {
                    'name': '',
                    'surname': '',
                    'email': '',
                    'password': '',
                    'confirm_password': '',
                  },
                  child: Column(
                    spacing: 10,
                    children: [
                      PrimaryTextBuilderField(
                        name: 'email',
                        labelText: 'Enter your email',
                      ),
                      PrimaryTextBuilderField(
                        name: 'name',
                        labelText: 'Enter your name',
                      ),
                      PrimaryTextBuilderField(
                        name: 'surname',
                        labelText: 'Enter your surname',
                      ),
                      PrimaryTextBuilderField(
                        name: 'password',
                        labelText: 'Enter your password',
                      ),
                      PrimaryTextBuilderField(
                        name: 'confirm_password',
                        labelText: 'Confirm your password',
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    AuthButton(
                      text: 'Register',
                      onPressed:
                          () => context.read<AuthCubit>().signUp(context),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?'),
                        TextButton(
                          onPressed:
                              () => context.read<AuthCubit>().toggleSignUp(),
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}
