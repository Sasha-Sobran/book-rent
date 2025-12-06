import 'package:get_it/get_it.dart';
import 'package:library_kursach/api/admin_api.dart';
import 'package:library_kursach/api/auth_api.dart';
import 'package:library_kursach/api/books_api.dart';
import 'package:library_kursach/api/common_api.dart';
import 'package:library_kursach/api/settings_api.dart';
import 'package:library_kursach/api/user_api.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/core/app_env.dart';
import 'package:library_kursach/core/http_client.dart';

class GetItService { 
  final _instance = GetIt.instance;

  GetIt get instance => _instance;

  void setup(AppEnv appEnv) {
    _instance.registerSingleton<AppEnv>(appEnv);
    _instance.registerSingleton<HttpClient>(HttpClient());
    _instance.registerSingleton<AppCubit>(AppCubit()..getSelf());
    
    _instance.registerLazySingleton<AuthApi>(() => AuthApi());
    _instance.registerLazySingleton<UserApi>(() => UserApi());
    _instance.registerLazySingleton<BooksApi>(() => BooksApi());
    _instance.registerLazySingleton<CommonApi>(() => CommonApi());
    _instance.registerLazySingleton<AdminApi>(() => AdminApi());
    _instance.registerLazySingleton<SettingsApi>(() => SettingsApi());
  }
}