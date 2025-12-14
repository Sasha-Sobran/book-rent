import 'package:dio/dio.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/http_client.dart';
import 'package:library_kursach/models/library.dart';

class LibrariesApi {
  Dio dio = GetItService().instance<HttpClient>().dio;

  Future<List<Library>> getLibraries() async {
    final response = await dio.get('/libraries/');
    return (response.data as List).map((e) => Library.fromJson(e)).toList();
  }

  Future<Library?> getMyLibrary() async {
    try {
      final response = await dio.get('/libraries/me/');
      return Library.fromJson(response.data);
    } catch (_) {
      return null;
    }
  }

  Future<void> createLibrary({
    required String name,
    required int cityId,
    required String address,
    required String phoneNumber,
  }) async {
    await dio.post('/libraries/', data: {
      'name': name,
      'city_id': cityId,
      'address': address,
      'phone_number': phoneNumber,
    });
  }
}

