import 'package:flutter/material.dart';
import 'package:library_kursach/common_widgets/info_chip.dart';

class RentInfoChip extends StatelessWidget {
  final String text;

  const RentInfoChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return InfoChip.text(label: text);
  }
}

