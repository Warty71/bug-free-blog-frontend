import 'package:flutter/material.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';

void main() {
  // Initialize dependency injection
  configureDependencies();

  runApp(const BugFreeBlogApp());
}

class BugFreeBlogApp extends StatelessWidget {
  const BugFreeBlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Bug Free Blog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0175C2),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0175C2),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      routerConfig: AppRouter.router,
    );
  }
}
