import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/api/notifications_api.dart';
import 'package:library_kursach/api/books_api.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/modules/books_module/widgets/book_detail_dialog.dart';
import 'package:library_kursach/modules/books_module/cubit.dart';
import 'package:library_kursach/modules/notifications_module/cubit.dart';
import 'package:library_kursach/utils/date_utils.dart' as app_date;

class NotificationDetailDialog extends StatelessWidget {
  final UserNotification notification;
  final NotificationsCubit cubit;

  const NotificationDetailDialog({
    super.key,
    required this.notification,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    if (!notification.isRead) {
      cubit.markAsRead(notification.id);
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: AppTextStyles.h4,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          app_date.AppDateUtils.formatDateTime(notification.createdAt),
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.message,
                    style: AppTextStyles.body,
                  ),
                  if (notification.bookId != null) ...[
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          final booksApi = GetItService().instance<BooksApi>();
                          final book = await booksApi.getBook(notification.bookId!);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (_) => BlocProvider(
                                  create: (_) => BooksCubit()..init(),
                                  child: BookDetailDialog(book: book),
                                ),
                              );
                            }
                          }
                        } catch (_) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Не вдалося завантажити книгу'),
                              ),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.menu_book),
                      label: const Text('Переглянути книгу'),
                      style: AppButtons.primary(),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Закрити'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

