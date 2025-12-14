import 'package:dio/dio.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/http_client.dart';

class UserNotification {
  final int id;
  final String title;
  final String message;
  final bool isRead;
  final String createdAt;
  final int? bookId;

  UserNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    this.bookId,
  });

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      id: json['id'] as int,
      title: json['title'] as String,
      message: json['message'] as String,
      isRead: json['is_read'] as bool,
      createdAt: json['created_at'] as String,
      bookId: json['book_id'] as int?,
    );
  }
}

class NotificationsApi {
  Dio dio = GetItService().instance<HttpClient>().dio;

  Future<List<UserNotification>> getNotifications() async {
    final response = await dio.get('/users/self/notifications/');
    return (response.data as List)
        .map((e) => UserNotification.fromJson(e))
        .toList();
  }

  Future<int> getUnreadCount() async {
    final response = await dio.get('/users/self/notifications/unread-count/');
    return response.data['count'] as int;
  }

  Future<void> markAsRead(int notificationId) async {
    await dio.post('/users/self/notifications/$notificationId/read/');
  }

  Future<void> markAllAsRead() async {
    await dio.post('/users/self/notifications/read-all/');
  }
}

