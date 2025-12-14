import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/models/event_log.dart';
import 'package:library_kursach/modules_admin/event_log_module/utils/event_log_utils.dart';
import 'package:library_kursach/modules_admin/event_log_module/widgets/event_detail_dialog.dart';

class EventItem extends StatelessWidget {
  final EventLog event;

  const EventItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm:ss');
    final actionColor = EventLogUtils.getActionTypeColor(event.actionType);
    final backgroundColor = actionColor.withValues(alpha: 0.05);

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => EventDetailDialog(event: event),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: actionColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            // Іконка
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: actionColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                EventLogUtils.getActionTypeIcon(event.actionType),
                color: actionColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Метод та тип сутності
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: actionColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                EventLogUtils.getActionTypeLabel(event.actionType),
                style: AppTextStyles.bodySmall.copyWith(
                  color: actionColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                EventLogUtils.getEntityTypeLabel(event.entityType),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                event.description,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
            if (event.userName != null) ...[
              Icon(Icons.person_outline, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                event.userName!,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(width: 16),
            ],
            Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              dateFormat.format(event.timestamp),
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, size: 20, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

