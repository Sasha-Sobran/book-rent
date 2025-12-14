import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/http_client.dart';
import 'package:library_kursach/models/book.dart';

class BooksApi {
  Dio dio = GetItService().instance<HttpClient>().dio;

  Future<List<Book>> getBooks({
    int? libraryId,
    String? search,
    List<int>? categoryIds,
    List<int>? genreIds,
  }) async {
    final params = <String, dynamic>{};
    if (libraryId != null) params['library_id'] = libraryId;
    if (search != null && search.trim().isNotEmpty) params['search'] = search.trim();
    if (categoryIds != null && categoryIds.isNotEmpty) params['category_ids'] = categoryIds.join(',');
    if (genreIds != null && genreIds.isNotEmpty) params['genre_ids'] = genreIds.join(',');

    final response = await dio.get('/books/', queryParameters: params.isEmpty ? null : params);
    return (response.data as List).map((e) => Book.fromJson(e)).toList();
  }

  Future<Book> getBook(int bookId) async {
    final response = await dio.get('/books/$bookId/');
    return Book.fromJson(response.data);
  }

  Future<List<Book>> getPopularBooks({int? libraryId, int limit = 8}) async {
    final params = <String, dynamic>{'limit': limit};
    if (libraryId != null) params['library_id'] = libraryId;
    final response = await dio.get('/books/popular/', queryParameters: params);
    return (response.data as List).map((e) => Book.fromJson(e)).toList();
  }

  Future<Book> createBook({
    required String title,
    required String author,
    required double price,
    required String publishYear,
    required int quantity,
    List<int>? categoryIds,
    List<int>? genreIds,
    List<String>? newCategories,
    List<String>? newGenres,
  }) async {
    final response = await dio.post('/books/', data: {
      'title': title,
      'author': author,
      'price': price,
      'publish_year': publishYear,
      'quantity': quantity,
      if (categoryIds != null) 'category_ids': categoryIds,
      if (genreIds != null) 'genre_ids': genreIds,
      if (newCategories != null) 'new_categories': newCategories,
      if (newGenres != null) 'new_genres': newGenres,
    });
    return Book.fromJson(response.data);
  }

  Future<Book> updateBook(
    int id, {
    String? title,
    String? author,
    double? price,
    String? publishYear,
    int? quantity,
    int? libraryId,
    List<int>? categoryIds,
    List<int>? genreIds,
    List<String>? newCategories,
    List<String>? newGenres,
  }) async {
    final response = await dio.put('/books/$id/', data: {
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (price != null) 'price': price,
      if (publishYear != null) 'publish_year': publishYear,
      if (quantity != null) 'quantity': quantity,
      if (libraryId != null) 'library_id': libraryId,
      if (categoryIds != null) 'category_ids': categoryIds,
      if (genreIds != null) 'genre_ids': genreIds,
      if (newCategories != null) 'new_categories': newCategories,
      if (newGenres != null) 'new_genres': newGenres,
    });
    return Book.fromJson(response.data);
  }

  Future<void> deleteBook(int id) async {
    await dio.delete('/books/$id/');
  }

  Future<Map<String, dynamic>> subscribeNotification(int bookId) async {
    final response = await dio.post('/books/$bookId/notify');
    return response.data;
  }

  Future<Map<String, dynamic>> unsubscribeNotification(int bookId) async {
    final response = await dio.delete('/books/$bookId/notify');
    return response.data;
  }

  Future<bool> getSubscriptionStatus(int bookId) async {
    final response = await dio.get('/books/$bookId/notify');
    return response.data['subscribed'] as bool;
  }

  Future<String> uploadBookImage(int bookId, String imagePath, [Uint8List? imageBytes, String? fileName]) async {
    MultipartFile file;
    if (imageBytes != null) {
      final name = fileName ?? imagePath.split('/').last;
      final finalName = name.contains('.') ? name : '$name.jpg';
      file = MultipartFile.fromBytes(
        imageBytes,
        filename: finalName,
      );
    } else {
      file = await MultipartFile.fromFile(imagePath);
    }
    
    final formData = FormData.fromMap({
      'file': file,
    });
    final response = await dio.post(
      '/books/$bookId/upload-image',
      data: formData,
    );
    return response.data['image_url'] as String;
  }
}