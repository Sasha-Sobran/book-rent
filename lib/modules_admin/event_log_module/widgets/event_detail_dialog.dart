import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/models/event_log.dart';
import 'package:library_kursach/modules_admin/event_log_module/utils/event_log_utils.dart';

class EventDetailDialog extends StatelessWidget {
  final EventLog event;

  const EventDetailDialog({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm:ss');
    final actionColor = EventLogUtils.getActionTypeColor(event.actionType);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: AppDecorations.modalDecoration,
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: actionColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      EventLogUtils.getActionTypeIcon(event.actionType),
                      color: actionColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: actionColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                EventLogUtils.getActionTypeLabel(event.actionType),
                                style: AppTextStyles.h4.copyWith(
                                  color: actionColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                EventLogUtils.getEntityTypeLabel(event.entityType),
                                style: AppTextStyles.h4.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 24),
              
              _buildInfoRow('Опис', event.description),
              const SizedBox(height: 16),
              
              if (event.userName != null) ...[
                _buildInfoRow('Користувач', event.userName!),
                const SizedBox(height: 16),
              ],
              
              _buildInfoRow('Час', dateFormat.format(event.timestamp)),
              const SizedBox(height: 16),
              
              if (event.ipAddress != null) ...[
                _buildInfoRow('IP адреса', event.ipAddress!),
                const SizedBox(height: 16),
              ],

              _buildInfoRow('ID події', event.id.toString()),
              const SizedBox(height: 16),
              
              if (event.entityId != null) ...[
                _buildInfoRow('ID сутності', event.entityId.toString()),
                const SizedBox(height: 16),
              ],
              
              if (event.metadata != null && event.metadata!.isNotEmpty) ...[
                Divider(color: AppColors.border, height: 1),
                const SizedBox(height: 16),
                Text(
                  'Метадані:',
                  style: AppTextStyles.h4,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    EventLogUtils.formatMetadata(event.metadata!),
                    style: AppTextStyles.body.copyWith(
                      fontFamily: 'monospace',
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: AppButtons.primary(),
                  child: const Text('Закрити'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: AppTextStyles.label.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.body,
          ),
        ),
      ],
    );
  }
}

