import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frog/domain/blocs/auth/auth_bloc.dart';
import 'package:frog/domain/blocs/auth/auth_event.dart';
import 'package:frog/domain/blocs/auth/auth_state.dart';
import 'package:frog/presentation/routes/app_router.dart';
import 'package:frog/presentation/widgets/frog_logo.dart';

import 'widgets/rounded_input.dart';


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
  String? _errorText;

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
            setState(() {
              _errorText = state.message;
            });
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
                        RoundedInput(
                          controller: _nicknameController,
                          hintText: 'Нікнейм',
                          errorText: _errorText?.contains('нікнейм') == true ? _errorText : null,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Введіть нікнейм';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        RoundedInput(
                          controller: _passwordController,
                          hintText: 'Пароль',
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Введіть пароль';
                            }
                            if (value.length < 6) {
                              return 'Пароль має містити щонайменше 6 символів';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        RoundedInput(
                          controller: _confirmPasswordController,
                          hintText: 'Повторіть пароль',
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Підтвердіть пароль';
                            }
                            if (value != _passwordController.text) {
                              return 'Паролі не співпадають';
                            }
                            return null;
                          },
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
                                    nickname: _nicknameController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  ),
                                );
                              }
                            },
                            child: state is AuthLoading
                                ? const CircularProgressIndicator()
                                : const Text('Зареєструватися'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRouter.loginRoute);
                          },
                          child: const Text('Увійти'),
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
