import 'package:flutter/material.dart';
import 'package:library_kursach/modules_admin/home_module/views/app_bar.dart';
import 'package:library_kursach/modules_admin/home_module/views/header.dart';

class AdminScreen extends StatelessWidget {
  static const path = '/admin';

  const AdminScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            AdminHeader(),
            AdminAppBar(),
          ],
        ),
      ),
      body: child,
    );
  }
}
