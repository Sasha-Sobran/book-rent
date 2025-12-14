import 'package:dio/dio.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/http_client.dart';

class City {
  final int id;
  final String name;

  City({required this.id, required this.name});

  factory City.fromJson(Map<String, dynamic> json) => City(id: json['id'], name: json['name']);
}

class CitiesApi {
  Dio dio = GetItService().instance<HttpClient>().dio;

  Future<List<City>> getCities() async {
    final response = await dio.get('/libraries/cities/');
    return (response.data as List).map((e) => City.fromJson(e)).toList();
  }

  Future<void> createCity(String name) async {
    await dio.post('/libraries/cities/', data: {'name': name});
  }
}

