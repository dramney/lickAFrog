import 'package:flutter/material.dart';
import 'package:frog/presentation/routes/app_router.dart';
import 'package:frog/presentation/widgets/frog_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    print("SplashScreen initialized");
    // Removed auto-navigation since we now have buttons
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB5E8A3), // Light green background color
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FrogLogo(size: 120),
              const SizedBox(height: 40),
              _buildButton(
                  "Увійти",
                      () => Navigator.pushReplacementNamed(context, AppRouter.loginRoute)
              ),
              const SizedBox(height: 16),
              _buildButton(
                  "Зареєструватися",
                      () => Navigator.pushReplacementNamed(context, AppRouter.registerRoute)
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: 220, // Fixed width for both buttons
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8ABD78), // Darker green button
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}