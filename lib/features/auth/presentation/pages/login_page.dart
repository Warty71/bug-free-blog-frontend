import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLogin = true;

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _onSubmit(String email, String password, [String? name]) {
    if (_isLogin) {
      context.read<AuthBloc>().add(
        LoginRequested(email: email, password: password),
      );
    } else {
      context.read<AuthBloc>().add(
        RegisterRequested(name: name!, email: email, password: password),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          } else if (state is AuthAuthenticated) {
            // Navigate to home page
            context.go('/');
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Logo/Icon
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.article_outlined,
                              size: 40,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Title
                          Text(
                            _isLogin ? 'Welcome Back' : 'Create Account',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isLogin
                                ? 'Sign in to continue to Bug Free Blog'
                                : 'Join Bug Free Blog today',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          // Form
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return AuthForm(
                                isLogin: _isLogin,
                                onToggleMode: _toggleMode,
                                onSubmit: _onSubmit,
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          // Loading indicator
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              if (state is AuthLoading) {
                                return const CircularProgressIndicator();
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
