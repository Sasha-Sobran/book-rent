import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:library_kursach/api/auth_api.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/models/user.dart';
import 'package:library_kursach/modules/books_module/screen.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState(roles: [], isSignUp: true));

  final authApi = GetItService().instance<AuthApi>();

  final signInFormKey = GlobalKey<FormBuilderState>();
  final signUpFormKey = GlobalKey<FormBuilderState>();

  void signUp(BuildContext context) async {
    if (signUpFormKey.currentState?.validate() != true) {
      return;
    }
    signUpFormKey.currentState?.save();
    final tokens = await authApi.signUp({
      'name': signUpFormKey.currentState?.value['name'],
      'email': signUpFormKey.currentState?.value['email'],
      'password': signUpFormKey.currentState?.value['password'],
    });

    if (tokens != null) {
      await GetItService().instance<AppCubit>().login(
        tokens['access_token']!,
        tokens['refresh_token']!,
      );
      if (context.mounted) {
        context.go(BooksScreen.path);
      }
    }
  }

  void signIn(BuildContext context) async {
    if (signInFormKey.currentState?.validate() != true) {
      return;
    }
    signInFormKey.currentState?.save();
    final tokens = await authApi.signIn({
      'email': signInFormKey.currentState?.value['email'],
      'password': signInFormKey.currentState?.value['password'],
    });

    if (tokens != null) {
      await GetItService().instance<AppCubit>().login(
        tokens['access_token']!,
        tokens['refresh_token']!,
      );
      if (context.mounted) {
        context.go(BooksScreen.path);
      }
    }
  }

  void toggleSignUp() {
    emit(state.copyWith(isSignUp: !state.isSignUp));
  }
}

class AuthState {
  final List<Role> roles;
  final bool isSignUp;

  AuthState({required this.roles, required this.isSignUp});

  copyWith({List<Role>? roles, bool? isSignUp}) {
    return AuthState(
      roles: roles ?? this.roles,
      isSignUp: isSignUp ?? this.isSignUp,
    );
  }
}
