import 'package:dio/dio.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/http_client.dart';
import 'package:library_kursach/models/rent.dart';

class RentsApi {
  Dio dio = GetItService().instance<HttpClient>().dio;

  Future<Rent> createRent({
    required int bookId,
    required int readerId,
    required int loanDays,
  }) async {
    final response = await dio.post('/rents/', data: {
      'book_id': bookId,
      'reader_id': readerId,
      'loan_days': loanDays,
    });
    return Rent.fromJson(response.data);
  }

  Future<Rent> createRentOrder({
    required int bookId,
    required int loanDays,
  }) async {
    final response = await dio.post('/rents/request/', data: {
      'book_id': bookId,
      'loan_days': loanDays,
    });
    return Rent.fromJson(response.data);
  }

  Future<List<Rent>> listRents({String? status, int? readerId, int? libraryId}) async {
    final response = await dio.get('/rents/', queryParameters: {
      if (status != null) 'status': status,
      if (readerId != null) 'reader_id': readerId,
      if (libraryId != null) 'library_id': libraryId,
    });
    final data = response.data as List<dynamic>;
    return data.map((e) => Rent.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Rent>> listMyRents({String? status}) async {
    final response = await dio.get('/rents/my/', queryParameters: {
      if (status != null) 'status': status,
    });
    final data = response.data as List<dynamic>;
    return data.map((e) => Rent.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Rent> issueRent(int id) async {
    final response = await dio.post('/rents/$id/issue/');
    return Rent.fromJson(response.data);
  }

  Future<Rent> declineRent(int id) async {
    final response = await dio.post('/rents/$id/decline/');
    return Rent.fromJson(response.data);
  }

  Future<Rent> returnRent(int id) async {
    final response = await dio.post('/rents/$id/return/');
    return Rent.fromJson(response.data);
  }

  Future<Rent> cancelRent(int id) async {
    final response = await dio.post('/rents/$id/cancel/');
    return Rent.fromJson(response.data);
  }
}


