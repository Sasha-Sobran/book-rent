import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:library_kursach/common_widgets/primary_text_builder_field.dart';
import 'package:library_kursach/modules/auth_module/cubit.dart';
import 'package:library_kursach/modules/auth_module/widgets/auth_button.dart';

class SignInView extends StatelessWidget {
  static const path = '/sign-in';

  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
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
                'Login',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('Fill in the form to login'),
            ],
          ),
          FormBuilder(
            key: authCubit.signInFormKey,
            initialValue: {'email': '', 'password': ''},
            child: Column(
              spacing: 10,
              children: [
                PrimaryTextBuilderField(name: 'email', labelText: 'Enter your email'),
                PrimaryTextBuilderField(
                  name: 'password',
                  labelText: 'Enter your password',
                ),
              ],
            ),
          ),
          Column(
            children: [
              AuthButton(
                text: 'Login',
                onPressed: () => context.read<AuthCubit>().signIn(context),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () => context.read<AuthCubit>().toggleSignUp(),
                    child: const Text('Register'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
