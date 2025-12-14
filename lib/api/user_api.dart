import 'package:dio/dio.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/http_client.dart';
import 'package:library_kursach/models/user.dart';

class UserApi {
  Dio dio = GetItService().instance<HttpClient>().dio;

  Future<User?> getSelf([String? token]) async {
    final response = await dio.get('/users/self/');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return User.fromJson(response.data);
    } else {
      throw Exception(response.data['message'] ?? 'Get self failed');
    }
  }

  Future<User> updateSelf({
    String? name,
    String? surname,
    String? phoneNumber,
    String? email,
    String? password,
  }) async {
    final response = await dio.put('/users/self/', data: {
      if (name != null) 'name': name,
      if (surname != null) 'surname': surname,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
    });
    return User.fromJson(response.data);
  }

  Future<Map<String, dynamic>> getReaderInfo() async {
    final response = await dio.get('/users/self/reader-info/');
    return response.data as Map<String, dynamic>;
  }
}
