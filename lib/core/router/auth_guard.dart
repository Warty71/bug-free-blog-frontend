import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import 'route_constants.dart';

class AuthGuard {
  /// Handles authentication-based redirects for the router
  static String? redirect(BuildContext context, GoRouterState state) {
    final authState = context.read<AuthBloc>().state;
    final isLoginRoute = state.uri.path == RouteConstants.login;

    // If user is authenticated and trying to access login, redirect to home
    if (authState is AuthAuthenticated && isLoginRoute) {
      return RouteConstants.home;
    }

    // If user is not authenticated and not on login page, redirect to login
    if (authState is AuthUnauthenticated && !isLoginRoute) {
      return RouteConstants.login;
    }

    // If user is authenticated and not on login page, allow access
    if (authState is AuthAuthenticated && !isLoginRoute) {
      return null;
    }

    // If user is not authenticated and on login page, allow access
    if (authState is AuthUnauthenticated && isLoginRoute) {
      return null;
    }

    // For loading and error states, allow access to login
    if (authState is AuthLoading || authState is AuthError) {
      return RouteConstants.login;
    }

    // Default case: redirect to login
    return RouteConstants.login;
  }
}
