import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:library_kursach/common_widgets/app_snackbar.dart';

class ErrorHandler {
  static void handle(BuildContext context, DioError e) {
    final statusCode = e.response?.statusCode;
    
    switch (statusCode) {
      case 401:
        AppSnackbar.error(context, 'Сесія закінчилась. Увійдіть знову');
        context.go('/auth');
        break;
      case 403:
        AppSnackbar.error(context, 'У вас немає доступу до цієї дії');
        break;
      case 404:
        AppSnackbar.error(context, 'Ресурс не знайдено');
        break;
      case 409:
        AppSnackbar.error(context, e.response?.data?['detail'] ?? 'Конфлікт даних');
        break;
      case 422:
        AppSnackbar.error(context, 'Невірні дані');
        break;
      case 500:
        AppSnackbar.error(context, 'Помилка сервера');
        break;
      default:
        AppSnackbar.error(context, e.response?.data?['detail'] ?? 'Щось пішло не так');
    }
  }

  static String getMessage(DioError e) {
    final statusCode = e.response?.statusCode;
    
    switch (statusCode) {
      case 401:
        return 'Сесія закінчилась';
      case 403:
        return 'Немає доступу';
      case 404:
        return 'Не знайдено';
      default:
        return e.response?.data?['detail'] ?? 'Помилка';
    }
  }
}

