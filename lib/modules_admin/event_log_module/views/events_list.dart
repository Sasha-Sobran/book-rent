import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules_admin/event_log_module/cubit.dart';
import 'package:library_kursach/modules_admin/event_log_module/widgets/event_item.dart';

class EventsList extends StatelessWidget {
  const EventsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventLogCubit, EventLogState>(
      builder: (context, state) {
        if (state.isLoading && state.events.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.events.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64, color: AppColors.textSecondary),
                const SizedBox(height: 16),
                Text('Немає подій', style: AppTextStyles.h4.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: AppDecorations.cardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.history, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Журнал подій', style: AppTextStyles.h4),
                        Text(
                          'Всього: ${state.totalCount}',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 20),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.events.length + (state.hasMore ? 1 : 0),
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index == state.events.length) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: state.isLoading
                            ? const CircularProgressIndicator()
                            : TextButton(
                                onPressed: () => context.read<EventLogCubit>().loadMore(),
                                child: const Text('Завантажити ще'),
                              ),
                      ),
                    );
                  }
                  return EventItem(event: state.events[index]);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

