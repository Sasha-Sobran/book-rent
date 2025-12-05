
import 'package:dio/dio.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/http_client.dart';
import 'package:library_kursach/models/user.dart';

class CommonApi {
  Dio dio = GetItService().instance<HttpClient>().dio;

  Future<List<Role>> getRoles() async {
    final response = await dio.get('/roles/');
    return (response.data as List<dynamic>).map((role) => Role.fromJson(role)).toList();
  }
}