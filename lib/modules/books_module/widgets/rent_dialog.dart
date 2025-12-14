import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/common_widgets/app_snackbar.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/models/book.dart';
import 'package:library_kursach/models/reader.dart';
import 'package:library_kursach/modules/books_module/rent_cubit.dart';
import 'package:library_kursach/modules/books_module/widgets/rent_info_chip.dart';
import 'package:library_kursach/utils/currency_utils.dart';

class RentDialog extends StatefulWidget {
  const RentDialog({super.key, required this.book});

  final Book book;

  @override
  State<RentDialog> createState() => _RentDialogState();
}

class _RentDialogState extends State<RentDialog> {
  final _loanDaysController = TextEditingController(text: '14');

  @override
  void dispose() {
    _loanDaysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RentCubit(book: widget.book)..init(),
      child: BlocBuilder<RentCubit, RentState>(
        builder: (context, state) {
          final cubit = context.read<RentCubit>();
          final expectedText = state.loanDays.toString();
          if (_loanDaysController.text != expectedText) {
            _loanDaysController.text = expectedText;
          }

          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: 420,
                child: state.isLoading
                    ? const SizedBox(height: 160, child: Center(child: CircularProgressIndicator()))
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.shopping_basket_outlined, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text('Видати книгу "${widget.book.title}"', style: AppTextStyles.h4),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text('Читач', style: AppTextStyles.caption),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<Reader>(
                            value: state.selectedReader,
                            items: state.readers
                                .map((r) => DropdownMenuItem<Reader>(
                                      value: r,
                                      child: Text(r.fullName),
                                    ))
                                .toList(),
                            onChanged: cubit.selectReader,
                            decoration: AppDecorations.inputWithIcon(Icons.person_outline, 'Оберіть читача'),
                          ),
                          const SizedBox(height: 12),
                          Text('Кількість днів', style: AppTextStyles.caption),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _loanDaysController,
                            keyboardType: TextInputType.number,
                            decoration: AppDecorations.inputWithIcon(Icons.calendar_today_outlined, 'Напр. 14'),
                            onChanged: (v) {
                              final parsed = int.tryParse(v.trim());
                              if (parsed != null) cubit.setLoanDays(parsed);
                            },
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 10,
                            runSpacing: 8,
                            children: [
                              RentInfoChip(text: 'Ціна/день: ${CurrencyUtils.formatCurrency(state.dailyRate)}'),
                              RentInfoChip(text: 'За дні: ${CurrencyUtils.formatCurrency(state.totalPrice)}'),
                              RentInfoChip(text: 'Знижка категорії: ${state.discount}%'),
                              RentInfoChip(text: 'Застава: ${state.deposit} ₴'),
                            ],
                          ),
                          if (state.error != null) ...[
                            const SizedBox(height: 8),
                            Text(state.error!, style: AppTextStyles.caption.copyWith(color: AppColors.error)),
                          ],
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: state.isSubmitting ? null : () => Navigator.of(context).pop(),
                                child: const Text('Скасувати'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                onPressed: state.isSubmitting
                                    ? null
                                    : () async {
                                        final error = await cubit.submit();
                                        if (!mounted) return;
                                        if (error != null && context.mounted) {
                                          AppSnackbar.error(context, error);
                                        } else if (context.mounted) {
                                          AppSnackbar.success(context, 'Рент створено');
                                          Navigator.of(context).pop(true);
                                        }
                                      },
                                icon: state.isSubmitting
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                    : const Icon(Icons.check, size: 18),
                                label: const Text('Підтвердити'),
                                style: AppButtons.primary(),
                              ),
                            ],
                          )
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}


