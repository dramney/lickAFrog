import 'package:flutter/material.dart';
import 'package:frog/presentation/screens/splash_screen.dart';
import 'package:frog/presentation/screens/login_screen.dart';
import 'package:frog/presentation/screens/register_screen.dart';
import 'package:frog/presentation/screens/home_screen.dart';
import '../modules/profile_module.dart';

class AppRouter {
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String profileRoute = '/profile';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case registerRoute:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case profileRoute:
        return MaterialPageRoute(builder: (_) => const ProfileModule());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}