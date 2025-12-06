import 'package:dio/dio.dart' show DioError;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:library_kursach/api/admin_api.dart';
import 'package:library_kursach/common_widgets/app_snackbar.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/models/user.dart';

class UsersUsersCubit extends Cubit<UsersUsersState> {
  UsersUsersCubit() : super(UsersUsersState(roles: [], users: []));

  final adminApi = GetItService().instance<AdminApi>();
  final userCreateFormKey = GlobalKey<FormBuilderState>();
  final userEditFormKey = GlobalKey<FormBuilderState>();
  final searchController = TextEditingController();

  void init() {
    getRoles();
    getUsers();
  }

  Future<void> getRoles() async {
    final roles = await adminApi.getRoles();
    emit(state.copyWith(roles: roles));
  }

  Future<void> getUsers() async {
    emit(state.copyWith(isLoading: true));
    final users = await adminApi.getUsers(
      roleId: state.selectedRoleId,
      query: state.searchQuery,
    );
    emit(state.copyWith(users: users, isLoading: false));
  }

  Future<void> filterByRole(int? roleId) async {
    if (state.selectedRoleId == roleId) {
      emit(state.copyWith(clearRoleId: true));
    } else {
      emit(state.copyWith(selectedRoleId: roleId));
    }
    await getUsers();
  }

  Future<void> filterByQuery(String query) async {
    emit(state.copyWith(searchQuery: query));
    await getUsers();
  }

  Future<void> resetFilter() async {
    searchController.clear();
    emit(state.copyWith(selectedRoleId: null, searchQuery: '', clearRoleId: true));
    await getUsers();
  }

  Future<void> createUser(BuildContext context) async {
    if (userCreateFormKey.currentState?.validate() != true) return;
    userCreateFormKey.currentState?.save();
    final v = userCreateFormKey.currentState!.value;

    emit(state.copyWith(isSubmitting: true));
    try {
      await adminApi.createUser(v['email'], v['password'], v['role_id'], v['name'], v['surname'], v['phone_number']);
      await getUsers();
      emit(state.copyWith(isSubmitting: false));
      if (context.mounted) {
        Navigator.of(context).pop();
        AppSnackbar.success(context, 'Користувача створено!');
      }
    } on DioError catch (e) {
      emit(state.copyWith(isSubmitting: false));
      if (context.mounted) _handleDioError(context, e);
    }
  }

  Future<void> editUserFromForm(BuildContext context, int userId) async {
    if (userEditFormKey.currentState?.validate() != true) return;
    userEditFormKey.currentState?.save();
    final v = userEditFormKey.currentState!.value;

    emit(state.copyWith(isSubmitting: true));
    try {
      await adminApi.editUser(userId, v['email'], v['password'], v['role_id'], v['name'], v['surname'], v['phone_number']);
      await getUsers();
      emit(state.copyWith(isSubmitting: false));
      if (context.mounted) {
        Navigator.of(context).pop();
        AppSnackbar.success(context, 'Користувача оновлено!');
      }
    } on DioError catch (e) {
      emit(state.copyWith(isSubmitting: false));
      if (context.mounted) _handleDioError(context, e);
    }
  }

  Future<void> deleteUser(BuildContext context, int userId) async {
    try {
      await adminApi.deleteUser(userId);
      await getUsers();
      if (context.mounted) AppSnackbar.success(context, 'Користувача видалено!');
    } on DioError catch (e) {
      if (context.mounted) _handleDioError(context, e);
    }
  }

  void _handleDioError(BuildContext context, DioError e) {
    final detail = e.response?.data?['detail'];
    final message = detail ?? 'Щось пішло не так';
    AppSnackbar.error(context, message);
  }
}

class UsersUsersState {
  final List<Role> roles;
  final List<User> users;
  final int? selectedRoleId;
  final String searchQuery;
  final bool isLoading;
  final bool isSubmitting;

  UsersUsersState({
    required this.roles,
    required this.users,
    this.selectedRoleId,
    this.searchQuery = '',
    this.isLoading = false,
    this.isSubmitting = false,
  });

  bool get isFiltered => selectedRoleId != null || searchQuery.isNotEmpty;

  UsersUsersState copyWith({
    List<Role>? roles,
    List<User>? users,
    int? selectedRoleId,
    String? searchQuery,
    bool clearRoleId = false,
    bool? isLoading,
    bool? isSubmitting,
  }) {
    return UsersUsersState(
      roles: roles ?? this.roles,
      users: users ?? this.users,
      selectedRoleId: clearRoleId ? null : (selectedRoleId ?? this.selectedRoleId),
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
