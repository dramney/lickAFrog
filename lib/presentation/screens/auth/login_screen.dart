import 'package:flutter/material.dart';
import 'package:frog/presentation/routes/app_router.dart';
import 'package:frog/presentation/screens/auth/widgets/rounded_input.dart';
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
  String? _errorText;

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
                          errorText: _errorText != null ? '' : null,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Введіть нікнейм';
                            }
                            return null;
                          },
                        ),
                        if (_errorText != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _errorText!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
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
                                setState(() => _errorText = null);
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
                                : const Text('Увійти'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRouter.registerRoute);
                          },
                          child: const Text('Зареєструватися'),
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
