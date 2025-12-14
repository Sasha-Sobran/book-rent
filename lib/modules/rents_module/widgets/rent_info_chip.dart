import 'package:flutter/material.dart';
import 'package:library_kursach/common_widgets/info_chip.dart';

class RentInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const RentInfoChip({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return InfoChip.icon(icon: icon, label: label);
  }
}

