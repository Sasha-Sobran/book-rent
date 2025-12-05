
import 'package:dio/dio.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/http_client.dart';

class AuthApi {
  Dio dio = GetItService().instance<HttpClient>().dio;

  Future<Map<String, String>?> signUp(Map<String, dynamic> data) async {
    final response = await dio.post('/users/register/', data: data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'access_token': response.data['access_token'] as String,
        'refresh_token': response.data['refresh_token'] as String,
      };
    } else {
      throw Exception(response.data['message'] ?? 'Registration failed');
    }
  }

  Future<Map<String, String>?> signIn(Map<String, dynamic> data) async {
    final response = await dio.post('/users/login/', data: data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'access_token': response.data['access_token'] as String,
        'refresh_token': response.data['refresh_token'] as String,
      };
    } else {
      throw Exception(response.data['message'] ?? 'Login failed');
    }
  }

  Future<String?> refreshToken(String refreshToken) async {
    final response = await dio.post(
      '/users/tokens/obtain/',
      data: {'refresh_token': refreshToken},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data['access_token'] as String?;
    } else {
      throw Exception(response.data['message'] ?? 'Token refresh failed');
    }
  }
}