import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:library_kursach/modules/auth_module/screen.dart';
import 'package:library_kursach/modules/books_module/screen.dart';
import 'package:library_kursach/modules/home_module/screen.dart';
import 'package:library_kursach/modules/main_module/screen.dart';
import 'package:library_kursach/modules/readers_module/screen.dart';
import 'package:library_kursach/modules/profile_module/screen.dart';
import 'package:library_kursach/modules/rents_module/screen.dart';
import 'package:library_kursach/modules/my_rents_module/screen.dart';
import 'package:library_kursach/modules_admin/event_log_module/screen.dart';
import 'package:library_kursach/modules_admin/users_users_module/screen.dart';
import 'package:library_kursach/modules_admin/settings_module/screen.dart';
import 'package:library_kursach/modules_admin/statistic_module/screen.dart';

class AppRoutes {
  final GlobalKey<NavigatorState> rootNavigatorKey;
  final GlobalKey<NavigatorState> homeNavigatorKey;

  AppRoutes(
    this.rootNavigatorKey,
    this.homeNavigatorKey,
  );

  late final homeShellRoute = ShellRoute(
    routes: getHomeRoutes(),
    navigatorKey: homeNavigatorKey,
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state, child) => HomeScreen(child: child),
  );

  late final authRoute = GoRoute(
    path: AuthScreen.path,
    parentNavigatorKey: rootNavigatorKey,
    pageBuilder: (context, state) {
      return MaterialPage(child: const AuthScreen());
    },
  );

  late final mainRoute = GoRoute(
    path: MainScreen.path,
    parentNavigatorKey: homeNavigatorKey,
    pageBuilder: (context, state) {
      return MaterialPage(child: const MainScreen());
    },
  );

  late final booksRoute = GoRoute(
    path: BooksScreen.path,
    parentNavigatorKey: homeNavigatorKey,
    pageBuilder: (context, state) {
      return MaterialPage(child: const BooksScreen());
    },
  );

  late final readersRoute = GoRoute(
    path: ReadersModuleScreen.path,
    parentNavigatorKey: homeNavigatorKey,
    pageBuilder: (context, state) {
      return MaterialPage(child: const ReadersModuleScreen());
    },
  );

  late final profileRoute = GoRoute(
    path: ProfileScreen.path,
    parentNavigatorKey: homeNavigatorKey,
    pageBuilder: (context, state) {
      return MaterialPage(child: const ProfileScreen());
    },
  );

  late final rentsRoute = GoRoute(
    path: RentsScreen.path,
    parentNavigatorKey: homeNavigatorKey,
    pageBuilder: (context, state) {
      final readerId = state.uri.queryParameters['reader_id'];
      final readerIdInt = readerId != null ? int.tryParse(readerId) : null;
      return MaterialPage(child: RentsScreen(readerId: readerIdInt));
    },
  );

  late final myRentsRoute = GoRoute(
    path: MyRentsScreen.path,
    parentNavigatorKey: homeNavigatorKey,
    pageBuilder: (context, state) {
      return MaterialPage(child: const MyRentsScreen());
    },
  );

  late final statisticRoute = GoRoute(
    path: StatisticScreen.path,
    parentNavigatorKey: homeNavigatorKey,
    pageBuilder: (context, state) {
      return MaterialPage(child: const StatisticScreen());
    },
  );

  late final settingsRoute = GoRoute(
    path: SettingsScreen.path,
    parentNavigatorKey: homeNavigatorKey,
    pageBuilder: (context, state) {
      return MaterialPage(child: const SettingsScreen());
    },
  );

  late final eventLogRoute = GoRoute(
    path: EventLogScreen.path,
    parentNavigatorKey: homeNavigatorKey,
    pageBuilder: (context, state) {
      return MaterialPage(child: const EventLogScreen());
    },
  );

  late final manageUsersRoute = GoRoute(
    path: ManageUsersScreen.path,
    parentNavigatorKey: homeNavigatorKey,
    pageBuilder: (context, state) {
      return MaterialPage(child: const ManageUsersScreen());
    },
  );

  List<RouteBase> getHomeRoutes() => [
    mainRoute,
    booksRoute,
    readersRoute,
    rentsRoute,
    myRentsRoute,
    profileRoute,
    statisticRoute,
    settingsRoute,
    eventLogRoute,
    manageUsersRoute,
  ];

  List<RouteBase> getRouteTree() => [
    homeShellRoute,
    authRoute,
  ];
}
