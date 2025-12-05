import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:library_kursach/api/auth_api.dart';
import 'package:library_kursach/api/user_api.dart';
import 'package:library_kursach/common_cubit/app_cubit/state.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/modules/auth_module/screen.dart';

class AppCubit extends HydratedCubit<AppState> {
  AppCubit() : super(AppState(isLoggedIn: false));

  Future<void> login(String accessToken, String refreshToken) async {
    emit(state.copyWith(
      isLoggedIn: true,
      token: accessToken,
      refreshToken: refreshToken,
    ));
    getSelf();
  }

  void logout(BuildContext context) {
    HydratedBloc.storage.clear();
    GoRouter.of(context).go(AuthScreen.path);
    emit(state.copyWith(
      isLoggedIn: false,
      token: null,
      refreshToken: null,
      user: null,
    ));
  }

  Future<void> getSelf() async {
    final user = await UserApi().getSelf(state.token ?? '');
    emit(state.copyWith(user: user));
  }

  Future<bool> refreshAccessToken() async {
    if (state.refreshToken == null) {
      return false;
    }

    try {
      final authApi = GetItService().instance<AuthApi>();
      final newAccessToken = await authApi.refreshToken(state.refreshToken!);
      if (newAccessToken != null) {
        emit(state.copyWith(token: newAccessToken));
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    return AppState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AppState state) {
    return state.toJson();
  }
}
