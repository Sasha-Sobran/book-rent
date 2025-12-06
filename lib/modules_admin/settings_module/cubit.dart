import 'package:dio/dio.dart' show DioError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/api/settings_api.dart';
import 'package:library_kursach/common_widgets/app_snackbar.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/models/settings.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState());

  final api = GetItService().instance<SettingsApi>();

  void init() {
    loadGenres();
    loadCategories();
    loadReaderCategories();
    loadPenaltyTypes();
  }

  Future<void> loadGenres() async {
    final genres = await api.getGenres();
    emit(state.copyWith(genres: genres));
  }

  Future<void> loadCategories() async {
    final categories = await api.getCategories();
    emit(state.copyWith(categories: categories));
  }

  Future<void> loadReaderCategories() async {
    final categories = await api.getReaderCategories();
    emit(state.copyWith(readerCategories: categories));
  }

  Future<void> loadPenaltyTypes() async {
    final types = await api.getPenaltyTypes();
    emit(state.copyWith(penaltyTypes: types));
  }

  Future<void> createGenre(BuildContext context, String name) async {
    try {
      await api.createGenre(name);
      await loadGenres();
      if (context.mounted) AppSnackbar.success(context, 'Жанр створено');
    } on DioError catch (e) {
      if (context.mounted) AppSnackbar.error(context, e.response?.data?['detail'] ?? 'Помилка');
    }
  }

  Future<void> deleteGenre(BuildContext context, int id) async {
    try {
      await api.deleteGenre(id);
      await loadGenres();
      if (context.mounted) AppSnackbar.success(context, 'Жанр видалено');
    } on DioError catch (e) {
      if (context.mounted) AppSnackbar.error(context, e.response?.data?['detail'] ?? 'Помилка');
    }
  }

  Future<void> createCategory(BuildContext context, String name) async {
    try {
      await api.createCategory(name);
      await loadCategories();
      if (context.mounted) AppSnackbar.success(context, 'Категорію створено');
    } on DioError catch (e) {
      if (context.mounted) AppSnackbar.error(context, e.response?.data?['detail'] ?? 'Помилка');
    }
  }

  Future<void> deleteCategory(BuildContext context, int id) async {
    try {
      await api.deleteCategory(id);
      await loadCategories();
      if (context.mounted) AppSnackbar.success(context, 'Категорію видалено');
    } on DioError catch (e) {
      if (context.mounted) AppSnackbar.error(context, e.response?.data?['detail'] ?? 'Помилка');
    }
  }

  Future<void> createReaderCategory(BuildContext context, String name, int discount) async {
    try {
      await api.createReaderCategory(name, discount);
      await loadReaderCategories();
      if (context.mounted) AppSnackbar.success(context, 'Категорію читача створено');
    } on DioError catch (e) {
      if (context.mounted) AppSnackbar.error(context, e.response?.data?['detail'] ?? 'Помилка');
    }
  }

  Future<void> updateReaderCategory(BuildContext context, int id, String name, int discount) async {
    try {
      await api.updateReaderCategory(id, name, discount);
      await loadReaderCategories();
      if (context.mounted) AppSnackbar.success(context, 'Категорію читача оновлено');
    } on DioError catch (e) {
      if (context.mounted) AppSnackbar.error(context, e.response?.data?['detail'] ?? 'Помилка');
    }
  }

  Future<void> deleteReaderCategory(BuildContext context, int id) async {
    try {
      await api.deleteReaderCategory(id);
      await loadReaderCategories();
      if (context.mounted) AppSnackbar.success(context, 'Категорію читача видалено');
    } on DioError catch (e) {
      if (context.mounted) AppSnackbar.error(context, e.response?.data?['detail'] ?? 'Помилка');
    }
  }

  Future<void> createPenaltyType(BuildContext context, String name) async {
    try {
      await api.createPenaltyType(name);
      await loadPenaltyTypes();
      if (context.mounted) AppSnackbar.success(context, 'Тип штрафу створено');
    } on DioError catch (e) {
      if (context.mounted) AppSnackbar.error(context, e.response?.data?['detail'] ?? 'Помилка');
    }
  }

  Future<void> deletePenaltyType(BuildContext context, int id) async {
    try {
      await api.deletePenaltyType(id);
      await loadPenaltyTypes();
      if (context.mounted) AppSnackbar.success(context, 'Тип штрафу видалено');
    } on DioError catch (e) {
      if (context.mounted) AppSnackbar.error(context, e.response?.data?['detail'] ?? 'Помилка');
    }
  }
}

class SettingsState {
  final List<Genre> genres;
  final List<Category> categories;
  final List<ReaderCategory> readerCategories;
  final List<PenaltyType> penaltyTypes;

  SettingsState({
    this.genres = const [],
    this.categories = const [],
    this.readerCategories = const [],
    this.penaltyTypes = const [],
  });

  SettingsState copyWith({
    List<Genre>? genres,
    List<Category>? categories,
    List<ReaderCategory>? readerCategories,
    List<PenaltyType>? penaltyTypes,
  }) {
    return SettingsState(
      genres: genres ?? this.genres,
      categories: categories ?? this.categories,
      readerCategories: readerCategories ?? this.readerCategories,
      penaltyTypes: penaltyTypes ?? this.penaltyTypes,
    );
  }
}
