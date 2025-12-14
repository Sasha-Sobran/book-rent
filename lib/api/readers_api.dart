import 'package:dio/dio.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/http_client.dart';
import 'package:library_kursach/models/reader.dart';

class ReadersApi {
  Dio dio = GetItService().instance<HttpClient>().dio;

  Future<List<Reader>> getReaders({String? query}) async {
    final response = await dio.get('/readers/', queryParameters: query != null ? {'query': query} : null);
    return (response.data as List).map((e) => Reader.fromJson(e)).toList();
  }

  Future<Reader> getReader(int id) async {
    final response = await dio.get('/readers/$id/');
    return Reader.fromJson(response.data);
  }

  Future<void> createReader({
    required String name,
    required String surname,
    String? phoneNumber,
    String? address,
    int? readerCategoryId,
    int? userId,
  }) async {
    await dio.post('/readers/', data: {
      'name': name,
      'surname': surname,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (address != null) 'address': address,
      if (readerCategoryId != null) 'reader_category_id': readerCategoryId,
      if (userId != null) 'user_id': userId,
    });
  }

  Future<void> updateReader(int id, {
    String? name,
    String? surname,
    String? phoneNumber,
    String? address,
    int? readerCategoryId,
  }) async {
    await dio.put('/readers/$id/', data: {
      if (name != null) 'name': name,
      if (surname != null) 'surname': surname,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (address != null) 'address': address,
      if (readerCategoryId != null) 'reader_category_id': readerCategoryId,
    });
  }

  Future<void> deleteReader(int id) async {
    await dio.delete('/readers/$id/');
  }
}

