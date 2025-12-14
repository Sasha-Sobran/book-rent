import 'package:dio/dio.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/http_client.dart';
import 'package:library_kursach/models/settings.dart';

class CommonApi {
  Dio dio = GetItService().instance<HttpClient>().dio;

  Future<List<Genre>> getGenres() async {
    final response = await dio.get('/genres/');
    return (response.data as List).map((e) => Genre.fromJson(e)).toList();
  }

  Future<List<Category>> getCategories() async {
    final response = await dio.get('/categories/');
    return (response.data as List).map((e) => Category.fromJson(e)).toList();
  }

  Future<List<ReaderCategory>> getReaderCategories() async {
    final response = await dio.get('/reader-categories/');
    return (response.data as List).map((e) => ReaderCategory.fromJson(e)).toList();
  }
}
