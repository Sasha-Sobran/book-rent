import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/router/routes.dart';
import 'package:library_kursach/modules/auth_module/screen.dart';
import 'package:library_kursach/modules/books_module/screen.dart';
import 'package:library_kursach/modules/main_module/screen.dart';

class AppRouter {
  final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> homeNavigatorKey =
      GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> adminNavigatorKey =
      GlobalKey<NavigatorState>();

  AppRouter();

  late final appRoutes = AppRoutes(
    rootNavigatorKey,
    homeNavigatorKey,
    adminNavigatorKey,
  );

  late final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: BooksScreen.path,
    routes: appRoutes.getRouteTree(),
    redirect: (context, state) {
      final appCubit = GetItService().instance<AppCubit>();
      if (!appCubit.state.isLoggedIn) {
        return AuthScreen.path;
      }
      
      final isAdminRoute = state.matchedLocation.startsWith('/admin');
      if (isAdminRoute) {
        final user = appCubit.state.user;
        final isAdminOrRoot = user?.isAdmin == true || user?.isRoot == true;
        if (!isAdminOrRoot) {
          return MainScreen.path;
        }
      }
      
      return null;
    },
  );
}
