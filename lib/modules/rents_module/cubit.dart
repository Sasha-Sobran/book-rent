import 'package:dio/dio.dart' show DioError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/api/rents_api.dart';
import 'package:library_kursach/api/penalties_api.dart';
import 'package:library_kursach/api/libraries_api.dart';
import 'package:library_kursach/api/readers_api.dart';
import 'package:library_kursach/common_widgets/app_snackbar.dart';
import 'package:library_kursach/common_widgets/error_handler.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/models/rent.dart';
import 'package:library_kursach/models/library.dart';
import 'package:library_kursach/models/reader.dart';

class RentsState {
  final List<Rent> rents;
  final bool isLoading;
  final String? statusFilter;
  final int? libraryFilter;
  final int? readerFilter;
  final List<Library> libraries;
  final List<Reader> readers;
  final int? actionInProgressId;
  final String? error;

  const RentsState({
    this.rents = const [],
    this.isLoading = false,
    this.statusFilter,
    this.libraryFilter,
    this.readerFilter,
    this.libraries = const [],
    this.readers = const [],
    this.actionInProgressId,
    this.error,
  });

  RentsState copyWith({
    List<Rent>? rents,
    bool? isLoading,
    String? statusFilter,
    int? libraryFilter,
    int? readerFilter,
    List<Library>? libraries,
    List<Reader>? readers,
    int? actionInProgressId,
    String? error,
  }) {
    return RentsState(
      rents: rents ?? this.rents,
      isLoading: isLoading ?? this.isLoading,
      statusFilter: statusFilter,
      libraryFilter: libraryFilter,
      readerFilter: readerFilter,
      libraries: libraries ?? this.libraries,
      readers: readers ?? this.readers,
      actionInProgressId: actionInProgressId,
      error: error,
    );
  }
}

class RentsCubit extends Cubit<RentsState> {
  RentsCubit() : super(const RentsState());

  final _api = GetItService().instance<RentsApi>();
  final _penaltiesApi = GetItService().instance<PenaltiesApi>();
  final _librariesApi = GetItService().instance<LibrariesApi>();
  final _readersApi = GetItService().instance<ReadersApi>();
  BuildContext? _context;

  Future<void> init(BuildContext context, {int? readerId}) async {
    _context = context;
    final appCubit = GetItService().instance<AppCubit>();
    final user = appCubit.state.user;
    final isRoot = user?.isRoot == true;
    
    if (isRoot) {
      await loadLibraries();
    }
    await loadReaders();
    
    if (readerId != null) {
      final readerExists = state.readers.any((r) => r.id == readerId);
      if (!readerExists) {
        try {
          final reader = await _readersApi.getReader(readerId);
          emit(state.copyWith(readers: [...state.readers, reader]));
        } catch (e) {
        }
      }
      await loadRents(readerId: readerId, clearReader: false);
    } else {
      await loadRents();
    }
  }

  Future<void> loadLibraries() async {
    try {
      final libraries = await _librariesApi.getLibraries();
      emit(state.copyWith(libraries: libraries));
    } on DioError catch (e) {
      if (_context?.mounted == true) {
        ErrorHandler.handle(_context!, e);
      }
    }
  }

  Future<void> loadReaders() async {
    try {
      final appCubit = GetItService().instance<AppCubit>();
      final user = appCubit.state.user;
      final isRoot = user?.isRoot == true;
      
      final readers = await _readersApi.getReadersWithActiveRents(
        libraryId: isRoot ? state.libraryFilter : null,
      );
      emit(state.copyWith(readers: readers));
    } on DioError catch (e) {
      if (_context?.mounted == true) {
        ErrorHandler.handle(_context!, e);
      }
    }
  }

  Future<void> loadRents({String? status, int? libraryId, int? readerId, bool clearStatus = false, bool clearLibrary = false, bool clearReader = false}) async {
    final finalStatus = clearStatus ? null : (status ?? state.statusFilter);
    final finalLibrary = clearLibrary ? null : (libraryId ?? state.libraryFilter);
    final finalReader = clearReader ? null : (readerId ?? state.readerFilter);
    
    emit(state.copyWith(
      isLoading: true,
      statusFilter: finalStatus,
      libraryFilter: finalLibrary,
      readerFilter: finalReader,
      error: null,
    ));
    try {
      final rents = await _api.listRents(
        status: finalStatus,
        libraryId: finalLibrary,
        readerId: finalReader,
      );
      emit(state.copyWith(
        rents: rents,
        isLoading: false,
        error: null,
        actionInProgressId: null,
        statusFilter: finalStatus,
        libraryFilter: finalLibrary,
        readerFilter: finalReader,
      ));
    } on DioError catch (e) {
      emit(state.copyWith(isLoading: false, error: ErrorHandler.getMessage(e), actionInProgressId: null));
      if (_context?.mounted == true) {
        ErrorHandler.handle(_context!, e);
      }
    }
  }

  Future<void> setStatus(String? status) async {
    await loadRents(status: status, clearStatus: status == null);
  }

  Future<void> setLibrary(int? libraryId) async {
    await loadRents(libraryId: libraryId, clearLibrary: libraryId == null);
    await loadReaders();
  }

  Future<void> setReader(int? readerId) async {
    await loadRents(readerId: readerId, clearReader: readerId == null);
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
      await loadRents(status: state.statusFilter, libraryId: state.libraryFilter, readerId: state.readerFilter);
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
      await loadRents(status: state.statusFilter, libraryId: state.libraryFilter, readerId: state.readerFilter);
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


