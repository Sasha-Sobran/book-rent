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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFFA855F7)],
          ),
        ),
        child: SafeArea(
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: GetItService().instance<AppCubit>()),
              BlocProvider(create: (context) => AuthCubit()),
            ],
            child: Stack(
              children: [
                Positioned(
                  top: -100,
                  right: -100,
                  child: Container(width: 300, height: 300, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.1))),
                ),
                Positioned(
                  bottom: -50,
                  left: -50,
                  child: Container(width: 200, height: 200, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.1))),
                ),
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
                          child: const Icon(Icons.local_library, size: 60, color: Colors.white),
                        ),
                        const SizedBox(height: 24),
                        const Text('Library App', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
                        const SizedBox(height: 8),
                        Text('Ваша бібліотека в одному місці', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8))),
                        const SizedBox(height: 48),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: state.isSignUp ? const SignUpView(key: ValueKey('signup')) : const SignInView(key: ValueKey('signin')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
