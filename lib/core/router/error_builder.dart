import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_constants.dart';

class AppErrorBuilder extends StatelessWidget {
  final GoRouterState state;

  const AppErrorBuilder({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'The page "${state.uri}" does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RouteConstants.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
