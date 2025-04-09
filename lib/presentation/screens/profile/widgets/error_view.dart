import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Помилка: $message', style: const TextStyle(color: Colors.white), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: const Text(
              'Спробувати знову',
              style: TextStyle(color: Color(0xFFA9C683)),
            ),
          ),
        ],
      ),
    );
  }
}
