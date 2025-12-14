import 'package:flutter/material.dart';
import 'package:library_kursach/core/theme/theme.dart';

class InfoChip extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? iconSize;
  final EdgeInsets? padding;

  const InfoChip({
    super.key,
    this.icon,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.iconSize = 16,
    this.padding,
  });

  const InfoChip.icon({
    super.key,
    required IconData icon,
    required String label,
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    double? iconSize,
    EdgeInsets? padding,
  })  : icon = icon,
        label = label,
        backgroundColor = backgroundColor ?? AppColors.surfaceVariant,
        textColor = textColor ?? AppColors.textSecondary,
        borderColor = borderColor ?? AppColors.border,
        iconSize = iconSize ?? 16,
        padding = padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 6);

  InfoChip.text({
    super.key,
    this.label = '',
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
    EdgeInsets? padding,
  })  : icon = null,
        backgroundColor = backgroundColor ?? AppColors.primary.withValues(alpha: 0.06),
        textColor = textColor ?? AppColors.primary,
        borderColor = borderColor ?? AppColors.primary.withValues(alpha: 0.15),
        iconSize = null,
        padding = padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 6);

  InfoChip.colored({
    super.key,
    required IconData this.icon,
    this.label = '',
    required Color color,
    double? iconSize,
    EdgeInsets? padding,
  })  : backgroundColor = color.withValues(alpha: 0.1),
        textColor = color,
        borderColor = color.withValues(alpha: 0.3),
        iconSize = iconSize ?? 16,
        padding = padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(icon == null ? 10 : 10),
        border: Border.all(color: borderColor ?? AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize, color: textColor),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: icon == null
                ? AppTextStyles.caption.copyWith(color: textColor)
                : AppTextStyles.bodySmall.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}

