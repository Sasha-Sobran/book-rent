import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules/notifications_module/cubit.dart';
import 'package:library_kursach/api/notifications_api.dart';
import 'package:library_kursach/modules/notifications_module/widgets/notification_detail_dialog.dart';
import 'package:library_kursach/utils/date_utils.dart' as app_date;

class NotificationsPopup extends StatelessWidget {
  const NotificationsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = GetItService().instance<NotificationsCubit>();
    cubit.loadNotifications();
    return BlocProvider.value(
      value: cubit,
      child: _NotificationsPopupContent(),
    );
  }
}

class _NotificationsPopupContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationsCubit>();
    
    return Container(
      width: 360,
      constraints: const BoxConstraints(maxHeight: 500),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Header(cubit: cubit),
          const Divider(height: 1),
          Flexible(
            child: BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }
                if (state.notifications.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.notifications_none,
                            size: 48,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Немає сповіщень',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: state.notifications.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final notification = state.notifications[index];
                    return _NotificationItem(
                      notification: notification,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => NotificationDetailDialog(
                            notification: notification,
                            cubit: cubit,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final NotificationsCubit cubit;

  const _Header({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                'Сповіщення',
                style: AppTextStyles.h4,
              ),
              const Spacer(),
              if (state.unreadCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${state.unreadCount}',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (state.unreadCount > 0) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => cubit.markAllAsRead(),
                  child: const Text('Прочитати всі'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final UserNotification notification;
  final VoidCallback onTap;

  const _NotificationItem({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: notification.isRead
          ? Colors.transparent
          : AppColors.primary.withValues(alpha: 0.03),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.notifications,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: notification.isRead
                            ? FontWeight.normal
                            : FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      app_date.AppDateUtils.formatDateTime(notification.createdAt),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

