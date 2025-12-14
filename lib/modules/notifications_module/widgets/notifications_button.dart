import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules/notifications_module/cubit.dart';
import 'package:library_kursach/modules/notifications_module/widgets/notifications_popup.dart';

class NotificationsButton extends StatelessWidget {
  const NotificationsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = GetItService().instance<NotificationsCubit>();
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      bloc: cubit,
      builder: (context, state) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, size: 22),
              onPressed: () => _showNotificationsPopup(context),
              tooltip: 'Сповіщення',
            ),
            if (state.unreadCount > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Center(
                    child: Text(
                      state.unreadCount > 9 ? '9+' : '${state.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _showNotificationsPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 60, right: 16),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            shadowColor: Colors.black.withValues(alpha: 0.2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.border),
                ),
                child: const NotificationsPopup(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

