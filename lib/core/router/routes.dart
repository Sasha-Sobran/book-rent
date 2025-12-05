import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:library_kursach/modules_admin/home_module/screen.dart';
import 'package:library_kursach/modules/auth_module/screen.dart';
import 'package:library_kursach/modules/books_module/screen.dart';
import 'package:library_kursach/modules/home_module/screen.dart';
import 'package:library_kursach/modules/main_module/screen.dart';
import 'package:library_kursach/modules/readers_module/screen.dart';
import 'package:library_kursach/modules_admin/event_log_module/screen.dart';
import 'package:library_kursach/modules_admin/users_users_module/screen.dart';
import 'package:library_kursach/modules_admin/settings_module/screen.dart';
import 'package:library_kursach/modules_admin/statistic_module/screen.dart';

class AppRoutes {
  final GlobalKey<NavigatorState> rootNavigatorKey;
  final GlobalKey<NavigatorState> homeNavigatorKey;
  final GlobalKey<NavigatorState> adminNavigatorKey;

  AppRoutes(
    this.rootNavigatorKey,
    this.homeNavigatorKey,
    this.adminNavigatorKey,
  );

  late final homeShellRoute = ShellRoute(
    routes: getHomeRoutes(),
    navigatorKey: homeNavigatorKey,
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state, child) => HomeScreen(child: child),
  );

  late final adminShellRoute = ShellRoute(
    routes: getAdminRoutes(),
    navigatorKey: adminNavigatorKey,
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state, child) => AdminScreen(child: child),
  );

  late final authRoute = GoRoute(
    path: AuthScreen.path,
    parentNavigatorKey: rootNavigatorKey,
    pageBuilder: (context, state) {
      return MaterialPage(child: const AuthScreen());
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
    path: ReadersScreen.path,
    parentNavigatorKey: homeNavigatorKey,
    pageBuilder: (context, state) {
      return MaterialPage(child: const ReadersScreen());
    },
  );

  late final mainRoute = GoRoute(
    path: MainScreen.path,
    parentNavigatorKey: homeNavigatorKey,
    pageBuilder: (context, state) {
      return MaterialPage(child: const MainScreen());
    },
  );

  late final statisticRoute = GoRoute(
    path: StatisticScreen.path,
    parentNavigatorKey: adminNavigatorKey,
    pageBuilder: (context, state) {
      return MaterialPage(child: const StatisticScreen());
    },
  );

  late final settingsRoute = GoRoute(
    path: SettingsScreen.path,
    parentNavigatorKey: adminNavigatorKey,
    pageBuilder: (context, state) {
      return MaterialPage(child: const SettingsScreen());
    },
  );

  late final eventLogRoute = GoRoute(
    path: EventLogScreen.path,
    parentNavigatorKey: adminNavigatorKey,
    pageBuilder: (context, state) {
      return MaterialPage(child: const EventLogScreen());
    },
  );

  late final manageUsersRoute = GoRoute(
    path: ManageUsersScreen.path,
    parentNavigatorKey: adminNavigatorKey,
    pageBuilder: (context, state) {
      return MaterialPage(child: const ManageUsersScreen());
    },
  );

  List<RouteBase> getHomeRoutes() => [mainRoute, booksRoute, readersRoute];

  List<RouteBase> getRouteTree() => [
    homeShellRoute,
    adminShellRoute,
    authRoute,
  ];

  List<RouteBase> getAdminRoutes() => [
    statisticRoute,
    settingsRoute,
    eventLogRoute,
    manageUsersRoute,
  ];
}
