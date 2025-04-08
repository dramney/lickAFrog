import 'package:flutter/material.dart';
import 'package:frog/presentation/routes/app_router.dart';
import 'package:frog/presentation/widgets/frog_logo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog/domain/blocs/auth/auth_bloc.dart';
import 'package:frog/domain/blocs/auth/auth_event.dart';
import 'package:frog/domain/blocs/auth/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nicknameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                              return 'Please enter a nickname';
                            }
                            return null;
                          },
                          key: const Key('register_nickname'),
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
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          key: const Key('register_password'),
                          autofillHints: const [AutofillHints.newPassword],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: const InputDecoration(
                            hintText: 'Повторіть пароль', // Confirm password in Ukrainian
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          key: const Key('register_confirm_password'),
                          autofillHints: const [AutofillHints.newPassword],
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: state is AuthLoading
                                ? null
                                : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                  RegisterEvent(
                                    nickname: _nicknameController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                              }
                            },
                            child: state is AuthLoading
                                ? const CircularProgressIndicator()
                                : const Text('Зареєструватися'), // Register in Ukrainian
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRouter.loginRoute);
                          },
                          child: const Text('Увійти'), // Login in Ukrainian
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