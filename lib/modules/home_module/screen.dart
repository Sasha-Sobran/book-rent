import 'package:flutter/material.dart';
import 'package:library_kursach/modules/home_module/views/app_bar.dart';
import 'package:library_kursach/modules/home_module/views/header.dart';

class HomeScreen extends StatelessWidget {
  static const path = '/';

  const HomeScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight * 2),
        child: Column(
          children: [
            const Header(),
            const HomeAppBar(),
          ],
        ),
      ),
      body: child,
    );
  }
}
