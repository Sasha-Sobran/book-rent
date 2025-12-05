import 'package:flutter/material.dart';

class ReadersScreen extends StatelessWidget {
  static const path = '/readers';

  const ReadersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Readers'),
      ),
    );
  }
} 