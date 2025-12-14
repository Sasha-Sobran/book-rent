import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/api/notifications_api.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/websocket_client.dart';

class NotificationsState {
  final List<UserNotification> notifications;
  final int unreadCount;
  final bool isLoading;
  final String? error;

  NotificationsState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.error,
  });

  NotificationsState copyWith({
    List<UserNotification>? notifications,
    int? unreadCount,
    bool? isLoading,
    String? error,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsState()) {
    _initWebSocket();
  }

  final _api = GetItService().instance<NotificationsApi>();
  final _wsClient = WebSocketClient();
  StreamSubscription? _wsSubscription;

  void _initWebSocket() {
    final appCubit = GetItService().instance<AppCubit>();
    if (appCubit.state.isLoggedIn && appCubit.state.token != null) {
      _wsClient.connect();
      _wsSubscription = _wsClient.messageStream.listen((message) {
        if (message['type'] == 'notification') {
          final notificationData = message['notification'] as Map<String, dynamic>;
          final notification = UserNotification.fromJson(notificationData);
          final updated = [notification, ...state.notifications];
          final unreadCount = updated.where((n) => !n.isRead).length;
          emit(state.copyWith(
            notifications: updated,
            unreadCount: unreadCount,
          ));
          refreshUnreadCount();
        }
      });
    }
  }

  @override
  Future<void> close() {
    _wsSubscription?.cancel();
    _wsClient.dispose();
    return super.close();
  }

  Future<void> loadNotifications() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final notifications = await _api.getNotifications();
      final unreadCount = await _api.getUnreadCount();
      emit(state.copyWith(
        notifications: notifications,
        unreadCount: unreadCount,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> refreshUnreadCount() async {
    try {
      final unreadCount = await _api.getUnreadCount();
      emit(state.copyWith(unreadCount: unreadCount));
    } catch (_) {}
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      await _api.markAsRead(notificationId);
      final updated = state.notifications.map((n) {
        if (n.id == notificationId) {
          return UserNotification(
            id: n.id,
            title: n.title,
            message: n.message,
            isRead: true,
            createdAt: n.createdAt,
            bookId: n.bookId,
          );
        }
        return n;
      }).toList();
      final unreadCount = updated.where((n) => !n.isRead).length;
      emit(state.copyWith(
        notifications: updated,
        unreadCount: unreadCount,
      ));
    } catch (_) {}
  }

  Future<void> markAllAsRead() async {
    try {
      await _api.markAllAsRead();
      final updated = state.notifications
          .map((n) => UserNotification(
                id: n.id,
                title: n.title,
                message: n.message,
                isRead: true,
                createdAt: n.createdAt,
                bookId: n.bookId,
              ))
          .toList();
      emit(state.copyWith(
        notifications: updated,
        unreadCount: 0,
      ));
    } catch (_) {}
  }
}

