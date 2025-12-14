import 'package:flutter/material.dart';
import 'package:library_kursach/core/theme/theme.dart';

class ConfirmationDialog {
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Так',
    String cancelText = 'Скасувати',
    Color? confirmColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: AppTextStyles.h4),
        content: Text(message, style: AppTextStyles.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: confirmColor != null
                ? ElevatedButton.styleFrom(backgroundColor: confirmColor)
                : AppButtons.primary(),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}

