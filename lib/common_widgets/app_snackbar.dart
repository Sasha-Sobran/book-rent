import 'package:flutter/material.dart';
import 'package:library_kursach/core/theme/theme.dart';

enum SnackbarType { success, error }

class AppSnackbar {
  static void show(BuildContext context, {required String message, required SnackbarType type}) {
    final isSuccess = type == SnackbarType.success;
    
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(isSuccess ? Icons.check_circle : Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500))),
          ],
        ),
        backgroundColor: isSuccess ? AppColors.success : AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: Duration(seconds: isSuccess ? 2 : 4),
      ),
    );
  }

  static void success(BuildContext context, String message) => show(context, message: message, type: SnackbarType.success);
  static void error(BuildContext context, String message) => show(context, message: message, type: SnackbarType.error);
}
