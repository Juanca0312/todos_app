import 'package:flutter/material.dart';

class AppSnackBar {
  AppSnackBar._();

  static void success(BuildContext context, {required String message}) {
    _show(
      context,
      message: message,
      backgroundColor: Colors.green.shade700,
      icon: Icons.check_circle_outline,
    );
  }

  static void error(BuildContext context, {required String message}) {
    _show(
      context,
      message: message,
      backgroundColor: Colors.red.shade700,
      icon: Icons.error_outline,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
  }
}
