import 'package:flutter/material.dart';
import 'package:library_kursach/core/theme/theme.dart';

void showAddDialog(BuildContext context, String title, Function(String) onCreate) {
  final controller = TextEditingController();

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: AppDecorations.inputWithIcon(Icons.label_outline, 'Назва'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Скасувати')),
        ElevatedButton(
          onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              onCreate(controller.text.trim());
              Navigator.pop(ctx);
            }
          },
          style: AppButtons.primary(),
          child: const Text('Створити'),
        ),
      ],
    ),
  );
}

