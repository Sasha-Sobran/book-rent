import 'package:dio/dio.dart' show DioError;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/api/event_log_api.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/models/event_log.dart';

class EventLogCubit extends Cubit<EventLogState> {
  EventLogCubit() : super(EventLogState(events: [], totalCount: 0));

  final eventLogApi = GetItService().instance<EventLogApi>();

  Future<void> init() async {
    await loadEvents();
  }

  Future<void> loadEvents() async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await eventLogApi.getEventLogs(
        userId: state.selectedUserId,
        actionType: state.selectedActionType,
        entityType: state.selectedEntityType,
        entityId: state.selectedEntityId,
        dateFrom: state.dateFrom,
        dateTo: state.dateTo,
        search: state.searchQuery,
        limit: state.limit,
        offset: state.offset,
      );
      emit(state.copyWith(
        events: response.items,
        totalCount: response.totalCount,
        isLoading: false,
      ));
    } on DioError catch (e) {
      emit(state.copyWith(isLoading: false));
      _handleDioError(e);
    }
  }

  Future<void> filterByUser(int? userId) async {
    emit(state.copyWith(
      selectedUserId: userId,
      offset: 0,
      clearUserId: userId == null,
    ));
    await loadEvents();
  }

  Future<void> filterByActionType(String? actionType) async {
    emit(state.copyWith(
      selectedActionType: actionType,
      offset: 0,
      clearActionType: actionType == null,
    ));
    await loadEvents();
  }

  Future<void> filterByEntityType(String? entityType) async {
    emit(state.copyWith(
      selectedEntityType: entityType,
      offset: 0,
      clearEntityType: entityType == null,
    ));
    await loadEvents();
  }

  Future<void> filterByEntityId(int? entityId) async {
    emit(state.copyWith(
      selectedEntityId: entityId,
      offset: 0,
      clearEntityId: entityId == null,
    ));
    await loadEvents();
  }

  Future<void> filterByDateRange(DateTime? from, DateTime? to) async {
    emit(state.copyWith(
      dateFrom: from,
      dateTo: to,
      offset: 0,
      clearDateFrom: from == null,
      clearDateTo: to == null,
    ));
    await loadEvents();
  }

  Future<void> filterBySearch(String query) async {
    emit(state.copyWith(searchQuery: query, offset: 0));
    await loadEvents();
  }

  Future<void> resetFilters() async {
    emit(state.copyWith(
      selectedActionType: null,
      selectedEntityType: null,
      selectedEntityId: null,
      dateFrom: null,
      dateTo: null,
      searchQuery: '',
      offset: 0,
      clearUserId: true,
      clearActionType: true,
      clearEntityType: true,
      clearEntityId: true,
      clearDateFrom: true,
      clearDateTo: true,
    ));
    await loadEvents();
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.events.length >= state.totalCount) return;
    
    final newOffset = state.offset + state.limit;
    emit(state.copyWith(offset: newOffset, isLoading: true));
    
    try {
      final response = await eventLogApi.getEventLogs(
        userId: state.selectedUserId,
        actionType: state.selectedActionType,
        entityType: state.selectedEntityType,
        entityId: state.selectedEntityId,
        dateFrom: state.dateFrom,
        dateTo: state.dateTo,
        search: state.searchQuery,
        limit: state.limit,
        offset: newOffset,
      );
      emit(state.copyWith(
        events: [...state.events, ...response.items],
        totalCount: response.totalCount,
        isLoading: false,
      ));
    } on DioError catch (e) {
      emit(state.copyWith(isLoading: false));
      _handleDioError(e);
    }
  }

  void _handleDioError(DioError e) {
    final detail = e.response?.data?['detail'];
    final message = detail ?? 'Щось пішло не так';
    // Можна додати snackbar, але тут немає контексту
    print('EventLog error: $message');
  }
}

class EventLogState {
  final List<EventLog> events;
  final int totalCount;
  final bool isLoading;
  final int? selectedUserId;
  final String? selectedActionType;
  final String? selectedEntityType;
  final int? selectedEntityId;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String searchQuery;
  final int limit;
  final int offset;

  EventLogState({
    required this.events,
    required this.totalCount,
    this.isLoading = false,
    this.selectedUserId,
    this.selectedActionType,
    this.selectedEntityType,
    this.selectedEntityId,
    this.dateFrom,
    this.dateTo,
    this.searchQuery = '',
    this.limit = 50,
    this.offset = 0,
  });

  bool get isFiltered =>
      selectedUserId != null ||
      selectedActionType != null ||
      selectedEntityType != null ||
      selectedEntityId != null ||
      dateFrom != null ||
      dateTo != null ||
      searchQuery.isNotEmpty;

  bool get hasMore => events.length < totalCount;

  EventLogState copyWith({
    List<EventLog>? events,
    int? totalCount,
    bool? isLoading,
    int? selectedUserId,
    String? selectedActionType,
    String? selectedEntityType,
    int? selectedEntityId,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? searchQuery,
    int? limit,
    int? offset,
    bool clearUserId = false,
    bool clearActionType = false,
    bool clearEntityType = false,
    bool clearEntityId = false,
    bool clearDateFrom = false,
    bool clearDateTo = false,
  }) {
    return EventLogState(
      events: events ?? this.events,
      totalCount: totalCount ?? this.totalCount,
      isLoading: isLoading ?? this.isLoading,
      selectedUserId: clearUserId ? null : (selectedUserId ?? this.selectedUserId),
      selectedActionType: clearActionType ? null : (selectedActionType ?? this.selectedActionType),
      selectedEntityType: clearEntityType ? null : (selectedEntityType ?? this.selectedEntityType),
      selectedEntityId: clearEntityId ? null : (selectedEntityId ?? this.selectedEntityId),
      dateFrom: clearDateFrom ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDateTo ? null : (dateTo ?? this.dateTo),
      searchQuery: searchQuery ?? this.searchQuery,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }
}

