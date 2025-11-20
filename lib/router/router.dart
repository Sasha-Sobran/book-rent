import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:library_kursach/router/routes.dart';

class AppRouter {
  final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> homeNavigatorKey =
      GlobalKey<NavigatorState>();

  AppRouter();

  late final appRoutes = AppRoutes(rootNavigatorKey, homeNavigatorKey);

  late final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/books',
    routes: appRoutes.getRouteTree(),
    redirect: (context, state) {
      return null;
    },
  );
}
