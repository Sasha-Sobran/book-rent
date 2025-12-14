import 'package:dio/dio.dart' show DioError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/api/books_api.dart';
import 'package:library_kursach/api/libraries_api.dart';
import 'package:library_kursach/api/rents_api.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/common_widgets/error_handler.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/models/book.dart';
import 'package:library_kursach/models/rent.dart';
import 'package:library_kursach/modules/rents_module/utils/rent_calculations.dart';
import 'package:library_kursach/utils/permission_utils.dart';

class MainState {
  final List<Rent> activeRents;
  final List<Rent> overdueRents;
  final List<Rent> recentRents;
  final List<Book> popularBooks;
  final Map<String, int> libraryStats;
  final double? todayIncome;
  final double? monthIncome;
  final bool isLoading;
  final String? error;

  const MainState({
    this.activeRents = const [],
    this.overdueRents = const [],
    this.recentRents = const [],
    this.popularBooks = const [],
    this.libraryStats = const {},
    this.todayIncome,
    this.monthIncome,
    this.isLoading = false,
    this.error,
  });

  MainState copyWith({
    List<Rent>? activeRents,
    List<Rent>? overdueRents,
    List<Rent>? recentRents,
    List<Book>? popularBooks,
    Map<String, int>? libraryStats,
    double? todayIncome,
    double? monthIncome,
    bool? isLoading,
    String? error,
  }) {
    return MainState(
      activeRents: activeRents ?? this.activeRents,
      overdueRents: overdueRents ?? this.overdueRents,
      recentRents: recentRents ?? this.recentRents,
      popularBooks: popularBooks ?? this.popularBooks,
      libraryStats: libraryStats ?? this.libraryStats,
      todayIncome: todayIncome ?? this.todayIncome,
      monthIncome: monthIncome ?? this.monthIncome,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainState());

  final _rentsApi = GetItService().instance<RentsApi>();
  final _booksApi = GetItService().instance<BooksApi>();
  final _librariesApi = GetItService().instance<LibrariesApi>();
  BuildContext? _context;

  void init(BuildContext context) {
    _context = context;
    loadData();
  }

  Future<void> loadData({bool force = false}) async {
    if (state.isLoading && !force) return;
    
    final hasData = state.activeRents.isNotEmpty || 
                    state.popularBooks.isNotEmpty || 
                    state.recentRents.isNotEmpty;
    if (!force && hasData) return;
    
    emit(state.copyWith(isLoading: !hasData, error: null));
    try {
      final appCubit = GetItService().instance<AppCubit>();
      final user = appCubit.state.user;
      if (user == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }
      final isLibrarian = PermissionUtils.canManageRents(user);

      if (isLibrarian) {
        await _loadLibrarianData();
      } else {
        await _loadReaderData();
      }
    } on DioError catch (e) {
      emit(state.copyWith(isLoading: false, error: ErrorHandler.getMessage(e)));
      if (_context?.mounted == true) {
        ErrorHandler.handle(_context!, e);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _loadReaderData() async {
    try {
      final allRents = await _rentsApi.listMyRents();
      final activeRents = allRents.where((r) => 
        r.status == 'active' || r.status == 'issued' || r.status == 'overdue'
      ).toList();
      final overdueRents = activeRents.where((r) {
        final calculation = RentCalculations.calculateRentAmounts(r);
        return calculation.isOverdue;
      }).toList();
      final recentRents = allRents.take(5).toList();
      final popularBooks = await _booksApi.getPopularBooks(limit: 8);

      emit(state.copyWith(
        activeRents: activeRents,
        overdueRents: overdueRents,
        recentRents: recentRents,
        popularBooks: popularBooks,
        isLoading: false,
      ));
    } on DioError catch (e) {
      emit(state.copyWith(isLoading: false, error: ErrorHandler.getMessage(e)));
      rethrow;
    }
  }

  Future<void> _loadLibrarianData() async {
    try {
      final myLibrary = await _librariesApi.getMyLibrary();
      final libraryId = myLibrary?.id;

      final allRents = await _rentsApi.listRents();
      final activeRents = allRents.where((r) => 
        r.status == 'active' || r.status == 'issued' || r.status == 'overdue'
      ).toList();
      final overdueRents = activeRents.where((r) {
        final calculation = RentCalculations.calculateRentAmounts(r);
        return calculation.isOverdue;
      }).toList();
      final recentRents = allRents.take(10).toList();
      final popularBooks = await _booksApi.getPopularBooks(libraryId: libraryId, limit: 8);

      emit(state.copyWith(
        activeRents: activeRents,
        overdueRents: overdueRents,
        recentRents: recentRents,
        popularBooks: popularBooks,
        libraryStats: {
          'total_books': popularBooks.length,
          'active_rents': activeRents.length,
          'overdue_rents': overdueRents.length,
        },
        isLoading: false,
      ));
    } on DioError catch (e) {
      emit(state.copyWith(isLoading: false, error: ErrorHandler.getMessage(e)));
      rethrow;
    }
  }
}

