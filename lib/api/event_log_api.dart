import 'package:dio/dio.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/http_client.dart';
import 'package:library_kursach/models/event_log.dart';

class EventLogApi {
  Dio dio = GetItService().instance<HttpClient>().dio;

  Future<EventLogListResponse> getEventLogs({
    int? userId,
    String? actionType,
    String? entityType,
    int? entityId,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? search,
    int limit = 100,
    int offset = 0,
  }) async {
    final Map<String, dynamic> queryParams = {
      'limit': limit,
      'offset': offset,
    };
    
    if (userId != null) queryParams['user_id'] = userId;
    if (actionType != null && actionType.isNotEmpty) queryParams['action_type'] = actionType;
    if (entityType != null && entityType.isNotEmpty) queryParams['entity_type'] = entityType;
    if (entityId != null) queryParams['entity_id'] = entityId;
    if (dateFrom != null) queryParams['date_from'] = dateFrom.toIso8601String();
    if (dateTo != null) queryParams['date_to'] = dateTo.toIso8601String();
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    
    final response = await dio.get(
      '/event-log/',
      queryParameters: queryParams,
    );
    
    return EventLogListResponse.fromJson(response.data);
  }

  Future<EventLog> getEventLogById(int eventId) async {
    final response = await dio.get('/event-log/$eventId');
    return EventLog.fromJson(response.data);
  }
}

class EventLogListResponse {
  final List<EventLog> items;
  final int totalCount;

  EventLogListResponse({
    required this.items,
    required this.totalCount,
  });

  factory EventLogListResponse.fromJson(Map<String, dynamic> json) {
    return EventLogListResponse(
      items: (json['events'] as List<dynamic>? ?? [])
          .map((item) => EventLog.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalCount: json['total'] as int? ?? 0,
    );
  }
}

