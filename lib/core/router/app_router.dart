import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import 'route_constants.dart';
import 'error_builder.dart';
import 'auth_guard.dart';

class AppRouter {
  static GoRouter createRouter(BuildContext context) {
    return GoRouter(
      initialLocation: RouteConstants.login,
      redirect: (context, state) => AuthGuard.redirect(context, state),
      routes: [
        GoRoute(
          path: RouteConstants.home,
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: RouteConstants.login,
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),
      ],
      errorBuilder: (context, state) => AppErrorBuilder(state: state),
    );
  }
}
