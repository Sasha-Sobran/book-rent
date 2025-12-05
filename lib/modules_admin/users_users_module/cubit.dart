import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:library_kursach/api/common_api.dart';
import 'package:library_kursach/api/user_api.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/models/user.dart';

class UsersUsersCubit extends Cubit<UsersUsersState> {
  UsersUsersCubit() : super(UsersUsersState(roles: [], users: []));

  void init() {
    getRoles();
    getUsers();
  }

  Future<void> getRoles() async {
    final roles = await GetItService().instance<CommonApi>().getRoles();
    emit(state.copyWith(roles: roles));
  }

  Future<void> getUsers() async {
    final users = await GetItService().instance<UserApi>().getUsers();
    emit(state.copyWith(users: users));
  }
}

class UsersUsersState {
  final List<Role> roles;
  final List<User> users;

  UsersUsersState({required this.roles, required this.users});

  copyWith({List<Role>? roles, List<User>? users}) {
    return UsersUsersState(
      roles: roles ?? this.roles,
      users: users ?? this.users,
    );
  }
}
