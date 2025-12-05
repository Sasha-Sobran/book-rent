import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/modules/auth_module/cubit.dart';
import 'package:library_kursach/modules/auth_module/views/sign_in.dart';
import 'package:library_kursach/modules/auth_module/views/sign_up.dart';

class AuthScreen extends StatelessWidget {
  static const path = '/auth';

  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Library App')),
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: GetItService().instance<AppCubit>()),
          BlocProvider(create: (context) => AuthCubit()),
        ],
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return Center(
              child: state.isSignUp ? const SignUpView() : const SignInView(),
            );
          },
        ),
      ),
    );
  }
}
