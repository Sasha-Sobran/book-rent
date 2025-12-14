import 'package:dio/dio.dart' show DioError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/api/readers_api.dart';
import 'package:library_kursach/common_widgets/app_snackbar.dart';
import 'package:library_kursach/common_widgets/error_handler.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/models/reader.dart';

class ReadersCubit extends Cubit<ReadersState> {
  ReadersCubit() : super(ReadersState());

  final _api = GetItService().instance<ReadersApi>();
  final searchController = TextEditingController();
  BuildContext? _context;

  void init(BuildContext context) {
    _context = context;
    loadReaders();
  }

  Future<void> loadReaders() async {
    emit(state.copyWith(isLoading: true));
    try {
      final readers = await _api.getReaders();
      emit(state.copyWith(readers: readers, isLoading: false));
    } on DioError catch (e) {
      emit(state.copyWith(isLoading: false, error: ErrorHandler.getMessage(e)));
      if (_context != null && _context!.mounted) {
        ErrorHandler.handle(_context!, e);
      }
    }
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      loadReaders();
      return;
    }
    emit(state.copyWith(isLoading: true));
    try {
      final readers = await _api.getReaders(query: query);
      emit(state.copyWith(readers: readers, isLoading: false));
    } on DioError catch (e) {
      emit(state.copyWith(isLoading: false, error: ErrorHandler.getMessage(e)));
      if (_context != null && _context!.mounted) {
        ErrorHandler.handle(_context!, e);
      }
    }
  }

  Future<void> createReader(
    BuildContext context, {
    required String name,
    required String surname,
    String? phoneNumber,
    String? address,
    int? readerCategoryId,
  }) async {
    try {
      await _api.createReader(
        name: name,
        surname: surname,
        phoneNumber: phoneNumber,
        address: address,
        readerCategoryId: readerCategoryId,
      );
      await loadReaders();
      if (context.mounted) {
        Navigator.pop(context);
        AppSnackbar.success(context, 'Читача створено');
      }
    } on DioError catch (e) {
      if (context.mounted) ErrorHandler.handle(context, e);
    }
  }

  Future<void> updateReader(
    BuildContext context,
    int id, {
    required String name,
    required String surname,
    String? phoneNumber,
    String? address,
    int? readerCategoryId,
  }) async {
    try {
      await _api.updateReader(
        id,
        name: name,
        surname: surname,
        phoneNumber: phoneNumber,
        address: address,
        readerCategoryId: readerCategoryId,
      );
      await loadReaders();
      if (context.mounted) {
        Navigator.pop(context);
        AppSnackbar.success(context, 'Читача оновлено');
      }
    } on DioError catch (e) {
      if (context.mounted) ErrorHandler.handle(context, e);
    }
  }

  Future<void> deleteReader(BuildContext context, int id) async {
    try {
      await _api.deleteReader(id);
      await loadReaders();
      if (context.mounted) AppSnackbar.success(context, 'Читача видалено');
    } on DioError catch (e) {
      if (context.mounted) ErrorHandler.handle(context, e);
    }
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}

class ReadersState {
  final List<Reader> readers;
  final bool isLoading;
  final String? error;

  ReadersState({
    this.readers = const [],
    this.isLoading = false,
    this.error,
  });

  ReadersState copyWith({
    List<Reader>? readers,
    bool? isLoading,
    String? error,
  }) {
    return ReadersState(
      readers: readers ?? this.readers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

