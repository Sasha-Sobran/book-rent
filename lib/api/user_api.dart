import 'package:dio/dio.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/http_client.dart';
import 'package:library_kursach/models/user.dart';

class UserApi {
  Dio dio = GetItService().instance<HttpClient>().dio;

  Future<User?> getSelf(String token) async {
    final response = await dio.get(
      '/users/self/',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return User.fromJson(response.data);
    } else {
      throw Exception(response.data['message'] ?? 'Get self failed');
    }
  }

  Future<List<User>> getUsers() async {
    final response = await dio.get('/admin/get-all-users/');
    return (response.data as List<dynamic>)
        .map((user) => User.fromJson(user))
        .toList();
  }
}
