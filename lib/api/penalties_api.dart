import 'package:dio/dio.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/http_client.dart';

class PenaltiesApi {
  Dio dio = GetItService().instance<HttpClient>().dio;

  Future<void> createPenalty({
    required int rentId,
    required String penaltyType, 
    int? daysOverdue,
    double? damageRate,
    double? manualAmount,
  }) async {
    await dio.post('/penalties/', data: {
      'rent_id': rentId,
      'penalty_type': penaltyType,
      if (daysOverdue != null) 'days_overdue': daysOverdue,
      if (damageRate != null) 'damage_rate': damageRate,
      if (manualAmount != null) 'manual_amount': manualAmount,
    });
  }
}

