import 'dart:developer';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/core/app_env.dart';
import 'package:library_kursach/core/get_it.dart';

class HttpClient {
  late AppEnv env;
  late Dio dio;

  HttpClient() {
    env = GetItService().instance<AppEnv>();

    dio = Dio(BaseOptions(baseUrl: env.apiUrl));

    if (!kIsWeb) {
      dio.httpClientAdapter = DefaultHttpClientAdapter();
    }

    _initInterceptors(dio.interceptors);
  }

  void _initInterceptors(Interceptors interceptors) {
    interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          try {
            final appCubit = GetItService().instance<AppCubit>();
            final token = appCubit.state.token;
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          } catch (e) {
            log('Could not get token: $e');
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final path = error.requestOptions.path;
            if (path != '/users/login/' && path != '/users/register/' && path != '/users/tokens/obtain/') {
              try {
                final appCubit = GetItService().instance<AppCubit>();
                if (appCubit.state.refreshToken != null) {
                  final refreshed = await appCubit.refreshAccessToken();
                  if (refreshed) {
                    final opts = error.requestOptions;
                    opts.headers['Authorization'] = 'Bearer ${appCubit.state.token}';
                    final newDio = Dio(BaseOptions(baseUrl: env.apiUrl));
                    final response = await newDio.fetch(opts);
                    return handler.resolve(response);
                  }
                }
              } catch (e) {
                log('Token refresh error: $e');
              }
            }
          }
          handler.next(error);
        },
      ),
    );

    if (kDebugMode) {
      interceptors.add(
        AppDioLogger(requestBody: true, requestHeader: true, responseBody: true),
      );
    }
  }
}

class AppDioLogger extends Interceptor {
  final bool requestBody;
  final bool requestHeader;
  final bool responseBody;

  AppDioLogger({
    required this.requestBody,
    required this.requestHeader,
    required this.responseBody,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('Request: ${options.uri}');
    if (requestBody) {
      log('Request Body: ${options.data}');
    }
    if (requestHeader) {
      log('Request Header: ${options.headers}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (responseBody) {
      log('Response Body: ${response.data}');
    }
    super.onResponse(response, handler);
  }
}
