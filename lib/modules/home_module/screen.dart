import 'package:flutter/material.dart';
import 'package:library_kursach/modules/home_module/views/app_bar.dart';

class HomeScreen extends StatelessWidget {
  static const path = '/';

  const HomeScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: const Size.fromHeight(kToolbarHeight), child: const CustomAppBar()),
      body: child,
    );
  }
}
