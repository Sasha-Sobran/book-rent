import 'package:dio/dio.dart';
import 'package:library_kursach/api/common_api.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/http_client.dart';
import 'package:library_kursach/models/settings.dart';

class SettingsApi {
  Dio dio = GetItService().instance<HttpClient>().dio;
  final _commonApi = GetItService().instance<CommonApi>();

  Future<List<Genre>> getGenres() => _commonApi.getGenres();
  Future<List<Category>> getCategories() => _commonApi.getCategories();

  Future<List<ReaderCategory>> getReaderCategories() async {
    final response = await dio.get('/settings/reader-categories/');
    return (response.data as List).map((e) => ReaderCategory.fromJson(e)).toList();
  }

  Future<List<PenaltyType>> getPenaltyTypes() async {
    final response = await dio.get('/settings/penalty-types/');
    return (response.data as List).map((e) => PenaltyType.fromJson(e)).toList();
  }

  Future<void> createGenre(String name) async {
    await dio.post('/settings/genres/', queryParameters: {'name': name});
  }

  Future<void> deleteGenre(int id) async {
    await dio.delete('/settings/genres/$id/');
  }

  Future<void> createCategory(String name) async {
    await dio.post('/settings/categories/', queryParameters: {'name': name});
  }

  Future<void> deleteCategory(int id) async {
    await dio.delete('/settings/categories/$id/');
  }

  Future<void> createReaderCategory(String name, int discountPercentage) async {
    await dio.post('/settings/reader-categories/', queryParameters: {'name': name, 'discount_percentage': discountPercentage});
  }

  Future<void> updateReaderCategory(int id, String name, int discountPercentage) async {
    await dio.put('/settings/reader-categories/$id/', queryParameters: {'name': name, 'discount_percentage': discountPercentage});
  }

  Future<void> deleteReaderCategory(int id) async {
    await dio.delete('/settings/reader-categories/$id/');
  }

  Future<void> createPenaltyType(String name) async {
    await dio.post('/settings/penalty-types/', queryParameters: {'name': name});
  }

  Future<void> deletePenaltyType(int id) async {
    await dio.delete('/settings/penalty-types/$id/');
  }
}
