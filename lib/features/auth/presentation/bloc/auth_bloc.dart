import 'package:bug_free_blog_frontend/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _loginUseCase(
      email: event.email,
      password: event.password,
    );

    await result.fold(
      (failure) async => emit(AuthError(_getFailureMessage(failure))),
      (token) async {
        // Fetch user data after successful login
        final userResult = await _getCurrentUserUseCase();

        userResult.fold(
          (failure) => emit(AuthError(_getFailureMessage(failure))),
          (user) => emit(AuthAuthenticated(user: user, token: token)),
        );
      },
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _registerUseCase(
      name: event.name,
      email: event.email,
      password: event.password,
    );

    result.fold((failure) => emit(AuthError(_getFailureMessage(failure))), (
      user,
    ) {
      // Registration successful, now login
      add(LoginRequested(email: event.email, password: event.password));
    });
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    // In a real app, you'd call logout API and clear stored tokens
    emit(const AuthUnauthenticated());
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    // In a real app, you'd check for stored tokens and validate them
    emit(const AuthUnauthenticated());
  }

  String _getFailureMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return failure.message;
    } else if (failure is ValidationFailure) {
      return failure.message;
    } else if (failure is CacheFailure) {
      return failure.message;
    }
    return 'An unexpected error occurred';
  }
}
