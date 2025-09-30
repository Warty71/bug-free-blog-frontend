import 'package:bug_free_blog_frontend/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';

void main() {
  // Initialize dependency injection
  configureDependencies();

  runApp(const BugFreeBlogApp());
}

class BugFreeBlogApp extends StatelessWidget {
  const BugFreeBlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            loginUseCase: getIt<LoginUseCase>(),
            registerUseCase: getIt<RegisterUseCase>(),
            getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
          )..add(const CheckAuthStatus()),
        ),
      ],
      child: Builder(
        builder: (context) {
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
            routerConfig: AppRouter.createRouter(context),
          );
        },
      ),
    );
  }
}
