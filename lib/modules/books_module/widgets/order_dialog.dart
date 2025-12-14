import 'package:flutter/material.dart';
import 'package:library_kursach/common_widgets/app_snackbar.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/app_env.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/models/book.dart';
import 'package:library_kursach/api/rents_api.dart';
import 'package:library_kursach/utils/currency_utils.dart';

class OrderDialog extends StatefulWidget {
  const OrderDialog({super.key, required this.book});

  final Book book;

  @override
  State<OrderDialog> createState() => _OrderDialogState();
}

class _OrderDialogState extends State<OrderDialog> {
  final _daysController = TextEditingController(text: '14');
  bool _isSubmitting = false;

  double get _dailyPercent => GetItService().instance<AppEnv>().rentDailyRatePercent;
  int get _deposit => widget.book.price.round();

  int _loanDays() => int.tryParse(_daysController.text.trim()) ?? 0;

  double _dailyRate() => widget.book.price * _dailyPercent;
  double _total() => _dailyRate() * _loanDays();

  @override
  void dispose() {
    _daysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.shopping_cart_checkout_outlined, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Замовити "${widget.book.title}"', style: AppTextStyles.h4),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text('Кількість днів', style: AppTextStyles.caption),
              const SizedBox(height: 6),
              TextField(
                controller: _daysController,
                keyboardType: TextInputType.number,
                decoration: AppDecorations.inputWithIcon(Icons.calendar_today_outlined, 'Напр. 14'),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  _chip('Ціна/день: ${CurrencyUtils.formatCurrency(_dailyRate())}'),
                  _chip('За дні: ${CurrencyUtils.formatCurrency(_total())}'),
                  _chip('Застава: $_deposit ₴'),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                    child: const Text('Скасувати'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _isSubmitting
                        ? null
                        : () async {
                            final days = _loanDays();
                            if (days <= 0) {
                              AppSnackbar.error(context, 'Вкажіть коректну тривалість');
                              return;
                            }
                            setState(() => _isSubmitting = true);
                            try {
                              final api = GetItService().instance<RentsApi>();
                              await api.createRentOrder(bookId: widget.book.id, loanDays: days);
                              if (!context.mounted) return;
                              AppSnackbar.success(context, 'Замовлення створено');
                              Navigator.of(context).pop(true);
                            } catch (_) {
                              if (mounted) AppSnackbar.error(context, 'Помилка створення замовлення');
                            } finally {
                              if (mounted) setState(() => _isSubmitting = false);
                            }
                          },
                    icon: _isSubmitting
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.check, size: 18),
                    label: const Text('Підтвердити'),
                    style: AppButtons.primary(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Text(text, style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
    );
  }
}

