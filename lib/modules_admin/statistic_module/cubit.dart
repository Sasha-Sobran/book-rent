import 'package:dio/dio.dart' show DioError;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/api/statistics_api.dart';
import 'package:library_kursach/core/get_it.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit() : super(StatisticsState());

  final _statisticsApi = GetItService().instance<StatisticsApi>();

  Future<void> loadOverview({int? libraryId}) async {
    emit(state.copyWith(isLoadingOverview: true));
    try {
      final data = await _statisticsApi.getOverview(libraryId: libraryId);
      emit(state.copyWith(isLoadingOverview: false, overview: data));
    } on DioError catch (e) {
      emit(state.copyWith(isLoadingOverview: false, error: e.message));
    } catch (e) {
      emit(state.copyWith(isLoadingOverview: false, error: e.toString()));
    }
  }

  Future<void> loadLibrariesStatistics({int? libraryId}) async {
    emit(state.copyWith(isLoadingLibraries: true));
    try {
      final data = await _statisticsApi.getLibrariesStatistics(
        libraryId: libraryId,
      );
      emit(
        state.copyWith(isLoadingLibraries: false, librariesStatistics: data),
      );
    } on DioError catch (e) {
      emit(state.copyWith(isLoadingLibraries: false, error: e.message));
    } catch (e) {
      emit(state.copyWith(isLoadingLibraries: false, error: e.toString()));
    }
  }

  Future<void> loadRevenueStatistics({
    DateTime? startDate,
    DateTime? endDate,
    int? libraryId,
  }) async {
    emit(state.copyWith(isLoadingRevenue: true));
    try {
      final data = await _statisticsApi.getRevenueStatistics(
        startDate: startDate,
        endDate: endDate,
        libraryId: libraryId,
      );
      emit(state.copyWith(isLoadingRevenue: false, revenueStatistics: data));
    } on DioError catch (e) {
      emit(state.copyWith(isLoadingRevenue: false, error: e.message));
    } catch (e) {
      emit(state.copyWith(isLoadingRevenue: false, error: e.toString()));
    }
  }

  Future<void> loadTrends({
    DateTime? startDate,
    DateTime? endDate,
    int? libraryId,
  }) async {
    emit(state.copyWith(isLoadingTrends: true));
    try {
      final data = await _statisticsApi.getTrends(
        startDate: startDate,
        endDate: endDate,
        libraryId: libraryId,
      );
      emit(state.copyWith(isLoadingTrends: false, trends: data));
    } on DioError catch (e) {
      emit(state.copyWith(isLoadingTrends: false, error: e.message));
    } catch (e) {
      emit(state.copyWith(isLoadingTrends: false, error: e.toString()));
    }
  }

  Future<void> loadChartData() async {
    emit(state.copyWith(isLoadingCharts: true, error: null));
    try {
      final rentsByStatus = await _statisticsApi.getRentsByStatusChart();
      final booksByLibrary = await _statisticsApi.getBooksByLibraryChart();
      final readersByCategory = await _statisticsApi.getReadersByCategoryChart();
      final rentsByLibrary = await _statisticsApi.getRentsByLibraryChart();
      
      emit(state.copyWith(
        isLoadingCharts: false,
        rentsByStatusChart: rentsByStatus,
        booksByLibraryChart: booksByLibrary,
        readersByCategoryChart: readersByCategory,
        rentsByLibraryChart: rentsByLibrary,
        error: null,
      ));
    } on DioError catch (e) {
      emit(state.copyWith(
        isLoadingCharts: false,
        error: e.message,
        rentsByStatusChart: const [],
        booksByLibraryChart: const [],
        readersByCategoryChart: const [],
        rentsByLibraryChart: const [],
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingCharts: false,
        error: e.toString(),
        rentsByStatusChart: const [],
        booksByLibraryChart: const [],
        readersByCategoryChart: const [],
        rentsByLibraryChart: const [],
      ));
    }
  }

  Future<void> loadAll({int? libraryId}) async {
    await Future.wait([
      loadOverview(libraryId: libraryId),
      loadLibrariesStatistics(libraryId: libraryId),
      loadChartData(),
    ]);
  }
}

class StatisticsState {
  final bool isLoadingOverview;
  final bool isLoadingLibraries;
  final bool isLoadingBooks;
  final bool isLoadingReaders;
  final bool isLoadingRents;
  final bool isLoadingRevenue;
  final bool isLoadingTrends;
  final bool isLoadingCharts;
  final Map<String, dynamic>? overview;
  final List<Map<String, dynamic>> librariesStatistics;
  final List<Map<String, dynamic>> booksStatistics;
  final List<Map<String, dynamic>> readersStatistics;
  final List<Map<String, dynamic>> rentsStatistics;
  final List<Map<String, dynamic>> revenueStatistics;
  final List<Map<String, dynamic>> trends;
  final List<Map<String, dynamic>> rentsByStatusChart;
  final List<Map<String, dynamic>> booksByLibraryChart;
  final List<Map<String, dynamic>> readersByCategoryChart;
  final List<Map<String, dynamic>> rentsByLibraryChart;
  final String? error;

  StatisticsState({
    this.isLoadingOverview = false,
    this.isLoadingLibraries = false,
    this.isLoadingBooks = false,
    this.isLoadingReaders = false,
    this.isLoadingRents = false,
    this.isLoadingRevenue = false,
    this.isLoadingTrends = false,
    this.isLoadingCharts = false,
    this.overview,
    this.librariesStatistics = const [],
    this.booksStatistics = const [],
    this.readersStatistics = const [],
    this.rentsStatistics = const [],
    this.revenueStatistics = const [],
    this.trends = const [],
    this.rentsByStatusChart = const [],
    this.booksByLibraryChart = const [],
    this.readersByCategoryChart = const [],
    this.rentsByLibraryChart = const [],
    this.error,
  });

  StatisticsState copyWith({
    bool? isLoadingOverview,
    bool? isLoadingLibraries,
    bool? isLoadingBooks,
    bool? isLoadingReaders,
    bool? isLoadingRents,
    bool? isLoadingRevenue,
    bool? isLoadingTrends,
    bool? isLoadingCharts,
    Map<String, dynamic>? overview,
    List<Map<String, dynamic>>? librariesStatistics,
    List<Map<String, dynamic>>? booksStatistics,
    List<Map<String, dynamic>>? readersStatistics,
    List<Map<String, dynamic>>? rentsStatistics,
    List<Map<String, dynamic>>? revenueStatistics,
    List<Map<String, dynamic>>? trends,
    List<Map<String, dynamic>>? rentsByStatusChart,
    List<Map<String, dynamic>>? booksByLibraryChart,
    List<Map<String, dynamic>>? readersByCategoryChart,
    List<Map<String, dynamic>>? rentsByLibraryChart,
    String? error,
  }) {
    return StatisticsState(
      isLoadingOverview: isLoadingOverview ?? this.isLoadingOverview,
      isLoadingLibraries: isLoadingLibraries ?? this.isLoadingLibraries,
      isLoadingBooks: isLoadingBooks ?? this.isLoadingBooks,
      isLoadingReaders: isLoadingReaders ?? this.isLoadingReaders,
      isLoadingRents: isLoadingRents ?? this.isLoadingRents,
      isLoadingRevenue: isLoadingRevenue ?? this.isLoadingRevenue,
      isLoadingTrends: isLoadingTrends ?? this.isLoadingTrends,
      isLoadingCharts: isLoadingCharts ?? this.isLoadingCharts,
      overview: overview ?? this.overview,
      librariesStatistics: librariesStatistics ?? this.librariesStatistics,
      booksStatistics: booksStatistics ?? this.booksStatistics,
      readersStatistics: readersStatistics ?? this.readersStatistics,
      rentsStatistics: rentsStatistics ?? this.rentsStatistics,
      revenueStatistics: revenueStatistics ?? this.revenueStatistics,
      trends: trends ?? this.trends,
      rentsByStatusChart: rentsByStatusChart ?? this.rentsByStatusChart,
      booksByLibraryChart: booksByLibraryChart ?? this.booksByLibraryChart,
      readersByCategoryChart: readersByCategoryChart ?? this.readersByCategoryChart,
      rentsByLibraryChart: rentsByLibraryChart ?? this.rentsByLibraryChart,
      error: error ?? this.error,
    );
  }
}
