import 'package:dio/dio.dart' show DioError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/api/rents_api.dart';
import 'package:library_kursach/api/penalties_api.dart';
import 'package:library_kursach/common_widgets/app_snackbar.dart';
import 'package:library_kursach/common_widgets/error_handler.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/models/rent.dart';

class RentsState {
  final List<Rent> rents;
  final bool isLoading;
  final String? statusFilter;
  final int? actionInProgressId;
  final String? error;

  const RentsState({
    this.rents = const [],
    this.isLoading = false,
    this.statusFilter,
    this.actionInProgressId,
    this.error,
  });

  RentsState copyWith({
    List<Rent>? rents,
    bool? isLoading,
    String? statusFilter,
    int? actionInProgressId,
    String? error,
  }) {
    return RentsState(
      rents: rents ?? this.rents,
      isLoading: isLoading ?? this.isLoading,
      statusFilter: statusFilter ?? this.statusFilter,
      actionInProgressId: actionInProgressId,
      error: error,
    );
  }
}

class RentsCubit extends Cubit<RentsState> {
  RentsCubit() : super(const RentsState());

  final _api = GetItService().instance<RentsApi>();
  final _penaltiesApi = GetItService().instance<PenaltiesApi>();
  BuildContext? _context;

  void init(BuildContext context) {
    _context = context;
    loadRents();
  }

  Future<void> loadRents({String? status}) async {
    emit(state.copyWith(isLoading: true, statusFilter: status, error: null));
    try {
      final rents = await _api.listRents(status: status);
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

  Future<void> issue(int id) => _runAction(id, _api.issueRent, successMsg: 'Видано');

  Future<void> decline(int id) => _runAction(id, _api.declineRent, successMsg: 'Відхилено');

  Future<void> returnRent(int id) => _runAction(id, _api.returnRent, successMsg: 'Повернено');

  Future<void> createPenalty({
    required int rentId,
    required String penaltyType,
    int? daysOverdue,
    double? damageRate,
    double? manualAmount,
  }) async {
    emit(state.copyWith(actionInProgressId: rentId, error: null));
    try {
      await _penaltiesApi.createPenalty(
        rentId: rentId,
        penaltyType: penaltyType,
        daysOverdue: daysOverdue,
        damageRate: damageRate,
        manualAmount: manualAmount,
      );
      await loadRents(status: state.statusFilter);
      if (_context?.mounted == true) {
        AppSnackbar.success(_context!, 'Штраф додано');
      }
    } on DioError catch (e) {
      emit(state.copyWith(actionInProgressId: null, error: ErrorHandler.getMessage(e)));
      if (_context?.mounted == true) {
        ErrorHandler.handle(_context!, e);
      }
    }
  }

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


