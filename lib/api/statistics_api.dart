import 'package:dio/dio.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/http_client.dart';

class StatisticsApi {
  Dio get dio => GetItService().instance<HttpClient>().dio;

  Future<Map<String, dynamic>> getOverview({int? libraryId}) async {
    final params = <String, dynamic>{};
    if (libraryId != null) params['library_id'] = libraryId;
    final response = await dio.get(
      '/statistics/overview',
      queryParameters: params,
    );
    return response.data as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getLibrariesStatistics({
    int? libraryId,
  }) async {
    final params = <String, dynamic>{};
    if (libraryId != null) params['library_id'] = libraryId;
    final response = await dio.get(
      '/statistics/libraries',
      queryParameters: params,
    );
    return (response.data as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> getRentsStatistics() async {
    final response = await dio.get('/statistics/rents');
    return (response.data as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> getRevenueStatistics({
    DateTime? startDate,
    DateTime? endDate,
    int? libraryId,
  }) async {
    final params = <String, dynamic>{};
    if (startDate != null) params['start_date'] = startDate.toIso8601String();
    if (endDate != null) params['end_date'] = endDate.toIso8601String();
    if (libraryId != null) params['library_id'] = libraryId;
    final response = await dio.get(
      '/statistics/revenue',
      queryParameters: params,
    );
    return (response.data as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> getTrends({
    DateTime? startDate,
    DateTime? endDate,
    int? libraryId,
  }) async {
    final params = <String, dynamic>{};
    if (startDate != null) params['start_date'] = startDate.toIso8601String();
    if (endDate != null) params['end_date'] = endDate.toIso8601String();
    if (libraryId != null) params['library_id'] = libraryId;
    final response = await dio.get(
      '/statistics/trends',
      queryParameters: params,
    );
    return (response.data as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> getRentsByStatusChart() async {
    final response = await dio.get('/statistics/charts/rents-by-status');
    return (response.data as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> getBooksByLibraryChart() async {
    final response = await dio.get('/statistics/charts/books-by-library');
    return (response.data as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> getReadersByCategoryChart() async {
    final response = await dio.get('/statistics/charts/readers-by-category');
    return (response.data as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> getRentsByLibraryChart() async {
    final response = await dio.get('/statistics/charts/rents-by-library');
    return (response.data as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }
}
