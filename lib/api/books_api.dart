
import 'package:dio/dio.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/http_client.dart';
import 'package:library_kursach/models/book.dart';

class BooksApi {
  Dio dio = GetItService().instance<HttpClient>().dio;

  Future<List<Book>> getBooks() async {
    final response = await dio.get('/books');
    return response.data;
  }
}