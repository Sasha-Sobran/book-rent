import 'package:flutter/material.dart';
import 'package:library_kursach/core/theme/theme.dart';

class LoadingIndicator extends StatelessWidget {
  final double? size;
  final Color? color;
  final double? strokeWidth;

  const LoadingIndicator({
    super.key,
    this.size,
    this.color,
    this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth ?? 4,
          color: color ?? AppColors.primary,
        ),
      ),
    );
  }
}

