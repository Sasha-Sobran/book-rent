import 'package:flutter/material.dart';

class EventLogScreen extends StatelessWidget {
  static const path = '/event-log';

  const EventLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Event Log'),
      ),
    );
  }
}   