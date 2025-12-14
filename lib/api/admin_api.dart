import 'package:dio/dio.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/http_client.dart';
import 'package:library_kursach/models/user.dart';

class AdminApi {
  Dio dio = GetItService().instance<HttpClient>().dio;

  Future<void> createRole(String name) async {
    await dio.post('/admin/roles/', data: {'name': name});
  }

  Future<void> createUser(
    String email,
    String password,
    int roleId,
    String name,
    String surname,
    String? phoneNumber,
  ) async {
    await dio.post(
      '/admin/create-user/',
      data: {
        'email': email,
        'password': password,
        'role_id': roleId,
        'name': name,
        'surname': surname,
        'phone_number': phoneNumber,
      },
    );
  }

  Future<void> createLibrarian({
    required String email,
    required String password,
    required String name,
    required String surname,
    String? phoneNumber,
    required int libraryId,
  }) async {
    await dio.post(
      '/admin/create-librarian/',
      data: {
        'email': email,
        'password': password,
        'name': name,
        'surname': surname,
        'phone_number': phoneNumber,
        'library_id': libraryId,
      },
    );
  }

  Future<void> editUser(
    int userId,
    String email,
    String? password,
    int roleId,
    String name,
    String surname,
    String? phoneNumber,
  ) async {
    await dio.put(
      '/admin/edit-user/$userId/',
      data: {
        'email': email,
        if (password != null && password.isNotEmpty) 'password': password,
        'role_id': roleId,
        'name': name,
        'surname': surname,
        'phone_number': phoneNumber,
      },
    );
  }

  Future<void> deleteUser(int userId) async {
    await dio.delete('/admin/delete-user/$userId/');
  }

  Future<List<User>> getUsers({int? roleId, String? query}) async {
    final Map<String, dynamic> queryParams = {};
    if (roleId != null) queryParams['role_id'] = roleId;
    if (query != null && query.isNotEmpty) queryParams['query'] = query;
    
    final response = await dio.get(
      '/admin/get-users/',
      queryParameters: queryParams,
    );
    return (response.data as List<dynamic>)
        .map((user) => User.fromJson(user))
        .toList();
  }

  Future<List<Role>> getRoles() async {
    final response = await dio.get('/roles/');
    return (response.data as List<dynamic>)
        .map((role) => Role.fromJson(role))
        .toList();
  }
}
