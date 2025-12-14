import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules_admin/event_log_module/cubit.dart';
import 'package:library_kursach/modules_admin/event_log_module/views/events_list.dart';
import 'package:library_kursach/modules_admin/event_log_module/views/filters.dart';

class EventLogScreen extends StatelessWidget {
  static const path = '/event-log';

  const EventLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventLogCubit()..init(),
      child: Container(
        decoration: AppDecorations.backgroundGradient,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: const [
            EventLogFilters(),
            SizedBox(height: 20),
            EventsList(),
          ],
        ),
      ),
    );
  }
}   