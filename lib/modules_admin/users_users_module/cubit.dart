import 'package:dio/dio.dart' show DioError;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/api/admin_api.dart';
import 'package:library_kursach/api/libraries_api.dart';
import 'package:library_kursach/common_widgets/app_snackbar.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/models/user.dart';
import 'package:library_kursach/models/library.dart';

class UsersUsersCubit extends Cubit<UsersUsersState> {
  UsersUsersCubit() : super(UsersUsersState(roles: [], users: [], libraries: []));

  final adminApi = GetItService().instance<AdminApi>();
  final librariesApi = GetItService().instance<LibrariesApi>();
  final appCubit = GetItService().instance<AppCubit>();
  final userCreateFormKey = GlobalKey<FormBuilderState>();
  final userEditFormKey = GlobalKey<FormBuilderState>();
  final searchController = TextEditingController();

  String get _currentUserRole => appCubit.state.user?.role.toLowerCase() ?? '';

  List<String> get _assignableRoleNames {
    switch (_currentUserRole) {
      case 'root':
        return ['admin', 'librarian'];
      case 'admin':
        return ['librarian'];
      default:
        return [];
    }
  }

  List<Role> get assignableRoles {
    final allowedNames = _assignableRoleNames;
    return state.roles.where((role) => allowedNames.contains(role.name.toLowerCase())).toList();
  }

  bool canAssignRole(Role role) => _assignableRoleNames.contains(role.name.toLowerCase());

  void init() {
    getRoles();
    getUsers();
    loadLibraries();
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

  Future<void> loadLibraries() async {
    final libs = await librariesApi.getLibraries();
    emit(state.copyWith(libraries: libs));
  }

  Future<void> createUser(BuildContext context) async {
    if (userCreateFormKey.currentState?.validate() != true) return;
    userCreateFormKey.currentState?.save();
    final v = userCreateFormKey.currentState!.value;
    final roleId = v['role_id'] as int?;
    final role = state.roles.firstWhere(
      (r) => r.id == roleId,
      orElse: () => Role(id: roleId ?? -1, name: ''),
    );

    if (roleId == null || role.id == -1) {
      emit(state.copyWith(isSubmitting: false));
      if (context.mounted) AppSnackbar.error(context, 'Оберіть роль');
      return;
    }

    if (!canAssignRole(role)) {
      emit(state.copyWith(isSubmitting: false));
      if (context.mounted) AppSnackbar.error(context, 'У вас немає прав створювати користувачів з цією роллю');
      return;
    }

    emit(state.copyWith(isSubmitting: true));
    try {
      if (role.name.toLowerCase() == 'librarian') {
        final libraryId = v['library_id'] as int?;
        if (libraryId == null) {
          emit(state.copyWith(isSubmitting: false));
          if (context.mounted) AppSnackbar.error(context, 'Оберіть бібліотеку');
          return;
        }
        await adminApi.createLibrarian(
          email: v['email'],
          password: v['password'],
          name: v['name'],
          surname: v['surname'],
          phoneNumber: v['phone_number'],
          libraryId: libraryId,
        );
      } else {
        await adminApi.createUser(v['email'], v['password'], v['role_id'], v['name'], v['surname'], v['phone_number']);
      }
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
    final roleId = v['role_id'] as int?;
    final role = state.roles.firstWhere(
      (r) => r.id == roleId,
      orElse: () => Role(id: roleId ?? -1, name: ''),
    );

    if (roleId == null || role.id == -1) {
      emit(state.copyWith(isSubmitting: false));
      if (context.mounted) AppSnackbar.error(context, 'Оберіть роль');
      return;
    }

    if (!canAssignRole(role)) {
      emit(state.copyWith(isSubmitting: false));
      if (context.mounted) AppSnackbar.error(context, 'Ви не можете призначати цю роль');
      return;
    }

    emit(state.copyWith(isSubmitting: true));
    try {
      await adminApi.editUser(userId, v['email'], v['password'], roleId, v['name'], v['surname'], v['phone_number']);
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
  final List<Library> libraries;

  UsersUsersState({
    required this.roles,
    required this.users,
    this.selectedRoleId,
    this.searchQuery = '',
    this.isLoading = false,
    this.isSubmitting = false,
    this.libraries = const [],
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
    List<Library>? libraries,
  }) {
    return UsersUsersState(
      roles: roles ?? this.roles,
      users: users ?? this.users,
      selectedRoleId: clearRoleId ? null : (selectedRoleId ?? this.selectedRoleId),
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      libraries: libraries ?? this.libraries,
    );
  }
}
