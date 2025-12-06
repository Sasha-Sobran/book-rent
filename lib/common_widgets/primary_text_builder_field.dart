import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:library_kursach/core/theme/theme.dart';

class PrimaryTextBuilderField extends StatelessWidget {
  const PrimaryTextBuilderField({
    super.key,
    required this.name,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.obscureText = false,
  });
  
  final String name;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      obscureText: obscureText,
      decoration: prefixIcon != null 
        ? AppDecorations.inputWithIcon(prefixIcon!, labelText ?? '', hint: hintText)
        : AppDecorations.inputDecoration.copyWith(labelText: labelText, hintText: hintText),
    );
  }
}
