import 'package:flutter/material.dart';
import 'package:frog/presentation/routes/app_router.dart';
import 'package:frog/presentation/widgets/frog_logo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog/domain/blocs/auth/auth_bloc.dart';
import 'package:frog/domain/blocs/auth/auth_event.dart';
import 'package:frog/domain/blocs/auth/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nicknameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, AppRouter.homeRoute);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FrogLogo(size: 100),
                        const SizedBox(height: 48),
                        TextFormField(
                          controller: _nicknameController,
                          decoration: const InputDecoration(
                            hintText: 'Нікнейм', // Nickname in Ukrainian
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your nickname';
                            }
                            return null;
                          },
                          key: const Key('login_nickname'),
                          autofillHints: const [AutofillHints.username],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            hintText: 'Пароль', // Password in Ukrainian
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          key: const Key('login_password'),
                          autofillHints: const [AutofillHints.password],
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            // Forgot password logic
                          },
                          child: const Text('Повторіть пароль'), // Confirm password in Ukrainian
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: state is AuthLoading
                                ? null
                                : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                  LoginEvent(
                                    nickname: _nicknameController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                              }
                            },
                            child: state is AuthLoading
                                ? const CircularProgressIndicator()
                                : const Text('Увійти'), // Login in Ukrainian
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRouter.registerRoute);
                          },
                          child: const Text('Зареєструватися'), // Register in Ukrainian
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}