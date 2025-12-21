import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/api/user_api.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/models/user.dart';

class ProfileState {
  final User? user;
  final bool isLoading;
  final bool isSaving;
  final String? error;
  final String? readerCategoryName;
  final double totalDebt;

  ProfileState({
    this.user,
    this.isLoading = false,
    this.isSaving = false,
    this.error,
    this.readerCategoryName,
    this.totalDebt = 0.0,
  });

  ProfileState copyWith({
    User? user,
    bool? isLoading,
    bool? isSaving,
    String? error,
    String? readerCategoryName,
    double? totalDebt,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
      readerCategoryName: readerCategoryName ?? this.readerCategoryName,
      totalDebt: totalDebt ?? this.totalDebt,
    );
  }
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState());

  final _userApi = UserApi();

  Future<void> loadUser() async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = await _userApi.getSelf();
      String? readerCategoryName;
      double totalDebt = 0.0;
      
      if (user?.isReader == true) {
        try {
          final readerInfo = await _userApi.getReaderInfo();
          readerCategoryName = readerInfo['reader_category_name'];
          totalDebt = (readerInfo['total_debt'] as num?)?.toDouble() ?? 0.0;
        } catch (e) {
        }
      }
      
      emit(state.copyWith(
        user: user,
        isLoading: false,
        readerCategoryName: readerCategoryName,
        totalDebt: totalDebt,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> updateUser({
    required String? name,
    required String? surname,
    required String? phone,
    required String? email,
    required String? password,
  }) async {
    emit(state.copyWith(isSaving: true, error: null));
    try {
      final updated = await _userApi.updateSelf(
        name: name,
        surname: surname,
        phoneNumber: phone,
        email: email,
        password: password,
      );
      emit(state.copyWith(user: updated, isSaving: false));
      GetItService().instance<AppCubit>().getSelf();
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: e.toString()));
    }
  }
}

