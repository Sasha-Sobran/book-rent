import 'package:get_it/get_it.dart';
import 'package:library_kursach/api/admin_api.dart';
import 'package:library_kursach/api/auth_api.dart';
import 'package:library_kursach/api/books_api.dart';
import 'package:library_kursach/api/common_api.dart';
import 'package:library_kursach/api/cities_api.dart';
import 'package:library_kursach/api/event_log_api.dart';
import 'package:library_kursach/api/libraries_api.dart';
import 'package:library_kursach/api/readers_api.dart';
import 'package:library_kursach/api/rents_api.dart';
import 'package:library_kursach/api/penalties_api.dart';
import 'package:library_kursach/api/settings_api.dart';
import 'package:library_kursach/api/user_api.dart';
import 'package:library_kursach/api/notifications_api.dart';
import 'package:library_kursach/api/statistics_api.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/core/app_env.dart';
import 'package:library_kursach/core/http_client.dart';
import 'package:library_kursach/modules/notifications_module/cubit.dart';

class GetItService {
  final _instance = GetIt.instance;

  GetIt get instance => _instance;

  void setup(AppEnv appEnv) {
    _instance.registerSingleton<AppEnv>(appEnv);
    _instance.registerSingleton<HttpClient>(HttpClient());
    final appCubit = AppCubit()..getSelf();
    _instance.registerSingleton<NotificationsApi>(NotificationsApi());
    _instance.registerSingleton<AppCubit>(appCubit);
    final notificationsCubit = NotificationsCubit();
    appCubit.stream.listen((state) {
      if (state.isLoggedIn) {
        notificationsCubit.refreshUnreadCount();
      }
    });
    _instance.registerSingleton<NotificationsCubit>(notificationsCubit);

    _instance.registerLazySingleton<AuthApi>(() => AuthApi());
    _instance.registerLazySingleton<UserApi>(() => UserApi());
    _instance.registerLazySingleton<BooksApi>(() => BooksApi());
    _instance.registerLazySingleton<CommonApi>(() => CommonApi());
    _instance.registerLazySingleton<AdminApi>(() => AdminApi());
    _instance.registerLazySingleton<SettingsApi>(() => SettingsApi());
    _instance.registerLazySingleton<ReadersApi>(() => ReadersApi());
    _instance.registerLazySingleton<RentsApi>(() => RentsApi());
    _instance.registerLazySingleton<PenaltiesApi>(() => PenaltiesApi());
    _instance.registerLazySingleton<LibrariesApi>(() => LibrariesApi());
    _instance.registerLazySingleton<CitiesApi>(() => CitiesApi());
    _instance.registerLazySingleton<EventLogApi>(() => EventLogApi());
    _instance.registerLazySingleton<StatisticsApi>(() => StatisticsApi());
  }
}
