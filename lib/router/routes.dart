import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:library_kursach/modules/books_module/screen.dart';
import 'package:library_kursach/modules/home_module/screen.dart';
import 'package:library_kursach/modules/main_module/screen.dart';
import 'package:library_kursach/modules/users_module/screen.dart';

class AppRoutes {
  final GlobalKey<NavigatorState> rootNavigatorKey;
  final GlobalKey<NavigatorState> homeNavigatorKey;

  AppRoutes(this.rootNavigatorKey, this.homeNavigatorKey);

  late final homeShellRoute = ShellRoute(
    routes: getHomeRoutes(),
    navigatorKey: homeNavigatorKey,
    parentNavigatorKey: rootNavigatorKey,
    builder: (context, state, child) => HomeScreen(child: child),
  );

  late final booksRoute = GoRoute(
    path: BooksScreen.path,
    parentNavigatorKey: homeNavigatorKey,
    pageBuilder: (context, state) {
      return MaterialPage(child: const BooksScreen());
    },
  );

  late final usersRoute = GoRoute(
    path: UsersScreen.path,
    parentNavigatorKey: homeNavigatorKey,
    pageBuilder: (context, state) {
      return MaterialPage(child: const UsersScreen());
    },
  );

  late final mainRoute = GoRoute(
    path: MainScreen.path,
    parentNavigatorKey: homeNavigatorKey,
    pageBuilder: (context, state) {
      return MaterialPage(child: const MainScreen());
    },
  );

  List<RouteBase> getHomeRoutes() => [mainRoute, booksRoute, usersRoute];

  List<RouteBase> getRouteTree() => [homeShellRoute];
}
