import 'package:dio/dio.dart' show DioError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/api/rents_api.dart';
import 'package:library_kursach/common_widgets/app_snackbar.dart';
import 'package:library_kursach/common_widgets/error_handler.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/models/rent.dart';

class MyRentsState {
  final List<Rent> rents;
  final bool isLoading;
  final String? statusFilter;
  final int? actionInProgressId;
  final String? error;

  const MyRentsState({
    this.rents = const [],
    this.isLoading = false,
    this.statusFilter,
    this.actionInProgressId,
    this.error,
  });

  MyRentsState copyWith({
    List<Rent>? rents,
    bool? isLoading,
    String? statusFilter,
    int? actionInProgressId,
    String? error,
  }) {
    return MyRentsState(
      rents: rents ?? this.rents,
      isLoading: isLoading ?? this.isLoading,
      statusFilter: statusFilter ?? this.statusFilter,
      actionInProgressId: actionInProgressId,
      error: error,
    );
  }
}

class MyRentsCubit extends Cubit<MyRentsState> {
  MyRentsCubit() : super(const MyRentsState());

  final _api = GetItService().instance<RentsApi>();
  BuildContext? _context;

  void init(BuildContext context) {
    _context = context;
    loadRents();
  }

  Future<void> loadRents({String? status}) async {
    emit(state.copyWith(isLoading: true, statusFilter: status, error: null));
    try {
      final rents = await _api.listMyRents(status: status);
      emit(state.copyWith(rents: rents, isLoading: false, error: null, actionInProgressId: null, statusFilter: status));
    } on DioError catch (e) {
      emit(state.copyWith(isLoading: false, error: ErrorHandler.getMessage(e), actionInProgressId: null));
      if (_context?.mounted == true) {
        ErrorHandler.handle(_context!, e);
      }
    }
  }

  Future<void> setStatus(String? status) async {
    await loadRents(status: status);
  }

  Future<void> cancel(int id) => _runAction(id, _api.cancelRent, successMsg: 'Скасовано');

  Future<void> _runAction(
    int rentId,
    Future<Rent> Function(int id) action, {
    required String successMsg,
  }) async {
    emit(state.copyWith(actionInProgressId: rentId, error: null));
    try {
      await action(rentId);
      await loadRents(status: state.statusFilter);
      if (_context?.mounted == true) {
        AppSnackbar.success(_context!, successMsg);
      }
    } on DioError catch (e) {
      emit(state.copyWith(actionInProgressId: null, error: ErrorHandler.getMessage(e)));
      if (_context?.mounted == true) {
        ErrorHandler.handle(_context!, e);
      }
    }
  }
}


