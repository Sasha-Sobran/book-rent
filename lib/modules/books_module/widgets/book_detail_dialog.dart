import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/utils/image_utils.dart';
import 'package:library_kursach/utils/permission_utils.dart';
import 'package:library_kursach/common_widgets/info_chip.dart';
import 'package:library_kursach/common_widgets/confirmation_dialog.dart';
import 'package:library_kursach/models/book.dart';
import 'package:library_kursach/modules/books_module/cubit.dart';
import 'package:library_kursach/modules/books_module/widgets/book_form_dialog.dart';
import 'package:library_kursach/modules/books_module/widgets/rent_dialog.dart';
import 'package:library_kursach/modules/books_module/widgets/order_dialog.dart';
import 'package:library_kursach/api/books_api.dart';
import 'package:library_kursach/common_widgets/app_snackbar.dart';
import 'package:library_kursach/utils/currency_utils.dart';

class BookDetailDialog extends StatelessWidget {
  final Book book;

  const BookDetailDialog({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final appCubit = GetItService().instance<AppCubit>();
    final user = appCubit.state.user;
    final booksState = context.read<BooksCubit>().state;
    final librarianLibraryId = booksState.myLibraryId;
    final canManage = PermissionUtils.canManageBooks(user);
    final canEdit = PermissionUtils.canEditBook(
      user,
      librarianLibraryId,
      book.libraryId,
    );
    final isReader = user?.isReader == true;

    final imageUrl = ImageUtils.buildImageUrl(book.imageUrl);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 700),
        decoration: AppDecorations.modalDecoration,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child:
                        imageUrl.isNotEmpty
                            ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        const Center(
                                          child: Icon(
                                            Icons.menu_book,
                                            size: 80,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
                            )
                            : const Center(
                              child: Icon(
                                Icons.menu_book,
                                size: 80,
                                color: AppColors.primary,
                              ),
                            ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.9),
                        shape: const CircleBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(book.title, style: AppTextStyles.h2),
                    const SizedBox(height: 8),
                    Text(
                      book.author,
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        InfoChip.colored(
                          icon: Icons.attach_money,
                          label: CurrencyUtils.formatCurrency(book.price),
                          color: AppColors.primary,
                        ),
                        InfoChip.colored(
                          icon: Icons.calendar_today,
                          label: 'Рік: ${book.publishYear}',
                          color: AppColors.secondary,
                        ),
                        InfoChip.colored(
                          icon: Icons.inventory_2,
                          label: 'Кількість: ${book.quantity}',
                          color: AppColors.textSecondary,
                        ),
                        if (book.libraryName != null)
                          InfoChip.colored(
                            icon: Icons.location_city,
                            label:
                                book.libraryCityName != null
                                    ? '${book.libraryName!} • ${book.libraryCityName!}'
                                    : book.libraryName!,
                            color: AppColors.secondaryDark,
                          ),
                      ],
                    ),
                    if (book.genres.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text('Жанри', style: AppTextStyles.h4),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            book.genres
                                .map(
                                  (genre) => Chip(
                                    label: Text(genre),
                                    backgroundColor: AppColors.primary
                                        .withValues(alpha: 0.1),
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                    if (book.categories.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text('Категорії', style: AppTextStyles.h4),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            book.categories
                                .map(
                                  (category) => Chip(
                                    label: Text(category),
                                    backgroundColor: AppColors.secondary
                                        .withValues(alpha: 0.1),
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                    if (canManage || isReader) ...[
                      const SizedBox(height: 24),
                      Divider(color: AppColors.border),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (canEdit) ...[
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder:
                                      (_) => BlocProvider.value(
                                        value: context.read<BooksCubit>(),
                                        child: BookFormDialog(book: book),
                                      ),
                                );
                              },
                              icon: const Icon(Icons.edit_outlined),
                              label: const Text('Редагувати'),
                              style: AppButtons.secondary,
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: book.quantity > 0
                                  ? () {
                                      Navigator.of(context).pop();
                                      showDialog(
                                        context: context,
                                        builder: (_) => RentDialog(book: book),
                                      ).then((created) {
                                        if (created == true && context.mounted) {
                                          final cubit = context.read<BooksCubit>();
                                          cubit.getBooks(
                                            libraryId:
                                                cubit.state.selectedLibrary?.id,
                                          );
                                        }
                                      });
                                    }
                                  : null,
                              icon: const Icon(Icons.shopping_basket_outlined),
                              label: const Text('Оренда'),
                              style: AppButtons.primary(),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: () => _confirmDelete(context),
                              icon: const Icon(Icons.delete_outline),
                              label: const Text('Видалити'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.error,
                                side: BorderSide(color: AppColors.error),
                              ),
                            ),
                          ] else if (isReader) ...[
                            if (book.quantity > 0)
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (_) => OrderDialog(book: book),
                                  );
                                },
                                icon: const Icon(
                                  Icons.shopping_cart_checkout_outlined,
                                ),
                                label: const Text('Замовити'),
                                style: AppButtons.primary(),
                              )
                            else
                              _NotifyButton(book: book),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    ConfirmationDialog.show(
      context,
      title: 'Видалити книгу?',
      message: 'Ви впевнені, що хочете видалити "${book.title}"?',
      confirmText: 'Видалити',
      confirmColor: AppColors.error,
    ).then((confirmed) {
      if (confirmed == true && context.mounted) {
        Navigator.of(context).pop();
        context.read<BooksCubit>().deleteBook(context, book.id);
      }
    });
  }
}

class _NotifyButton extends StatefulWidget {
  final Book book;

  const _NotifyButton({required this.book});

  @override
  State<_NotifyButton> createState() => _NotifyButtonState();
}

class _NotifyButtonState extends State<_NotifyButton> {
  bool _isSubscribed = false;
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    try {
      final api = GetItService().instance<BooksApi>();
      final status = await api.getSubscriptionStatus(widget.book.id);
      if (mounted) {
        setState(() {
          _isSubscribed = status;
          _isInitialized = true;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isInitialized = true);
      }
    }
  }

  Future<void> _toggleSubscription() async {
    setState(() => _isLoading = true);
    try {
      final api = GetItService().instance<BooksApi>();
      if (_isSubscribed) {
        await api.unsubscribeNotification(widget.book.id);
        if (mounted) {
          AppSnackbar.success(context, 'Відписка виконана');
        }
      } else {
        await api.subscribeNotification(widget.book.id);
        if (mounted) {
          AppSnackbar.success(context, 'Повідомлення увімкнено');
        }
      }
      if (mounted) {
        setState(() {
          _isSubscribed = !_isSubscribed;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppSnackbar.error(context, 'Помилка');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _toggleSubscription,
      icon: Icon(_isSubscribed ? Icons.notifications_off : Icons.notifications),
      label: Text(_isSubscribed ? 'Відписатися' : 'Повідомити'),
      style: AppButtons.primary(),
    );
  }
}
