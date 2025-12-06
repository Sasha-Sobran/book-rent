import 'package:flutter/material.dart';
import 'colors.dart';

class AppButtons {
  static ButtonStyle primary({Color? color}) => ElevatedButton.styleFrom(
    backgroundColor: color ?? AppColors.primary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 0,
  );

  static ButtonStyle secondary = OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    side: const BorderSide(color: AppColors.border),
    foregroundColor: AppColors.textSecondary,
  );

  static ButtonStyle danger = ElevatedButton.styleFrom(
    backgroundColor: AppColors.error,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 0,
  );

  static ButtonStyle text({Color? color}) => TextButton.styleFrom(
    foregroundColor: color ?? AppColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  );
}

