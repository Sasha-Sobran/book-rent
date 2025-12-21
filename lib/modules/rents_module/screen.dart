import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/common_cubit/app_cubit/cubit.dart';
import 'package:library_kursach/models/rent.dart';
import 'package:library_kursach/modules/rents_module/cubit.dart';
import 'package:library_kursach/modules/rents_module/utils/rent_calculations.dart';
import 'package:library_kursach/modules/rents_module/widgets/rent_status_chip.dart';
import 'package:library_kursach/modules/rents_module/widgets/rent_info_chip.dart';
import 'package:library_kursach/modules/rents_module/widgets/rent_return_row.dart';
import 'package:library_kursach/utils/date_utils.dart' as app_date;
import 'package:library_kursach/utils/rent_status_utils.dart';
import 'package:library_kursach/utils/currency_utils.dart';

class RentsScreen extends StatelessWidget {
  static const path = '/rents';
  final int? readerId;

  const RentsScreen({super.key, this.readerId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = RentsCubit();
        cubit.init(context, readerId: readerId);
        return cubit;
      },
      child: Container(
        decoration: AppDecorations.backgroundGradient,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            children: const [
              _RentsHeader(),
              SizedBox(height: 12),
              Expanded(child: _RentsList()),
            ],
          ),
        ),
      ),
    );
  }
}

class _RentsHeader extends StatelessWidget {
  const _RentsHeader();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RentsCubit>();
    final appCubit = GetItService().instance<AppCubit>();
    final user = appCubit.state.user;
    final isRoot = user?.isRoot == true;
    
    return BlocBuilder<RentsCubit, RentsState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: AppDecorations.cardDecoration,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.assignment_outlined, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isRoot ? 'Ренти' : 'Ренти моєї бібліотеки', style: AppTextStyles.h3),
                    Text('${state.rents.length} записів', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (isRoot && state.libraries.isNotEmpty) ...[
                DropdownButton<int?>(
                  value: state.libraryFilter,
                  hint: const Text('Бібліотека'),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('Усі бібліотеки'),
                    ),
                    ...state.libraries.map((lib) {
                      final label = '${lib.name}${lib.cityName != null ? ' • ${lib.cityName}' : ''}';
                      return DropdownMenuItem<int?>(
                        value: lib.id,
                        child: Text(label),
                      );
                    }),
                  ],
                  onChanged: (v) => cubit.setLibrary(v),
                ),
                const SizedBox(width: 12),
              ],
              if (state.readers.isNotEmpty || state.readerFilter != null) ...[
                Builder(
                  builder: (context) {
                    final readerExists = state.readerFilter == null || 
                        state.readers.any((r) => r.id == state.readerFilter);
                    return DropdownButton<int?>(
                      value: readerExists ? state.readerFilter : null,
                      hint: const Text('Читач'),
                      items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text('Усі читачі'),
                        ),
                        ...state.readers.map((reader) {
                          return DropdownMenuItem<int?>(
                            value: reader.id,
                            child: Text(reader.fullName),
                          );
                        }),
                      ],
                      onChanged: (v) => cubit.setReader(v),
                    );
                  },
                ),
                const SizedBox(width: 12),
              ],
              DropdownButton<String?>(
                value: state.statusFilter,
                hint: const Text('Статус'),
                items: RentStatusUtils.buildDropdownItems(),
                onChanged: (v) => cubit.setStatus(v),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => cubit.loadRents(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RentsList extends StatelessWidget {
  const _RentsList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RentsCubit, RentsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.rents.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.assignment_outlined, size: 64, color: AppColors.textMuted),
                const SizedBox(height: 12),
                Text('Поки немає рентів', style: AppTextStyles.h4.copyWith(color: AppColors.textMuted)),
              ],
            ),
          );
        }
        return ListView.separated(
          itemCount: state.rents.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final rent = state.rents[index];
            return _RentCard(rent: rent);
          },
        );
      },
    );
  }
}

class _RentCard extends StatelessWidget {
  const _RentCard({required this.rent});

  final Rent rent;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RentsCubit>();
    final calculation = RentCalculations.calculateRentAmounts(rent);
    
    return BlocBuilder<RentsCubit, RentsState>(
      buildWhen: (p, c) => p.actionInProgressId != c.actionInProgressId,
      builder: (context, state) {
        final isBusy = state.actionInProgressId == rent.id;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: calculation.isOverdue ? AppColors.error : AppColors.border,
              width: calculation.isOverdue ? 2 : 1,
            ),
            boxShadow: calculation.isOverdue
                ? [
                    BoxShadow(
                      color: AppColors.error.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(rent.bookTitle, style: AppTextStyles.h4),
                            ),
                            if (calculation.isOverdue)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.error.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.error),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Прострочено',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.error,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('Читач: ${rent.readerName}', style: AppTextStyles.bodySmall),
                        Text(
                          'Очікувана дата повернення: ${app_date.AppDateUtils.formatDate(rent.expectedReturnDate)}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: calculation.isOverdue ? AppColors.error : null,
                            fontWeight: calculation.isOverdue ? FontWeight.w600 : null,
                          ),
                        ),
                        Text('Фактична дата повернення: ${app_date.AppDateUtils.formatDateNullable(rent.returnDate)}', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  RentStatusChip(status: rent.status),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 6,
                children: [
                  RentInfoChip(icon: Icons.calendar_today_outlined, label: 'Старт: ${app_date.AppDateUtils.formatDate(rent.rentDate)}'),
                  RentInfoChip(icon: Icons.payments_outlined, label: 'Оренда: ${CurrencyUtils.formatCurrency(calculation.actualRentAmount)}'),
                  RentInfoChip(icon: Icons.price_change_outlined, label: 'Штрафи: ${CurrencyUtils.formatCurrency(calculation.actualPenaltyAmount)}'),
                  RentInfoChip(icon: Icons.summarize_outlined, label: 'Разом: ${CurrencyUtils.formatCurrency(calculation.actualTotalAmount)}'),
                  RentInfoChip(icon: Icons.safety_check_outlined, label: 'Застава: ${rent.depositPrice}'),
                  if (rent.returnDate != null) RentInfoChip(icon: Icons.event_available_outlined, label: 'Повернено: ${app_date.AppDateUtils.formatDate(rent.returnDate!)}'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (rent.status == RentStatusNames.pending) ...[
                    ElevatedButton.icon(
                      icon: const Icon(Icons.done, size: 18),
                      label: const Text('Видати'),
                      style: AppButtons.primary(),
                      onPressed: isBusy ? null : () => cubit.issue(rent.id),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Відхилити'),
                      onPressed: isBusy ? null : () => cubit.decline(rent.id),
                    ),
                  ] else if (rent.status == RentStatusNames.active) ...[
                    ElevatedButton.icon(
                      icon: const Icon(Icons.reply, size: 18),
                      label: const Text('Повернути книгу'),
                      style: AppButtons.primary(),
                      onPressed: isBusy ? null : () => _showReturnDialog(context, cubit, rent),
                    ),
                  ],
                  if (isBusy) ...[
                    const SizedBox(width: 12),
                    const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

}

void _showReturnDialog(BuildContext context, RentsCubit cubit, Rent rent) {
  showDialog(
    context: context,
    builder: (_) => _ReturnDialog(cubit: cubit, rent: rent),
  );
}

class _ReturnDialog extends StatefulWidget {
  const _ReturnDialog({required this.cubit, required this.rent});

  final RentsCubit cubit;
  final Rent rent;

  @override
  State<_ReturnDialog> createState() => _ReturnDialogState();
}

class _ReturnDialogState extends State<_ReturnDialog> {
  bool _isSubmitting = false;
  bool _addManualPenalty = false;
  String _manualType = 'damage'; // damage, lost, manual
  final _damageRateCtrl = TextEditingController(text: '0.3');
  final _manualAmountCtrl = TextEditingController();

  @override
  void dispose() {
    _damageRateCtrl.dispose();
    _manualAmountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final calculation = RentCalculations.calculateReturnDialogAmounts(widget.rent);
    double rentAmount = calculation.rentAmount;
    double penaltyOverdue = calculation.penaltyOverdue;
    double extraPenalty = 0;

    final isLost = _addManualPenalty && _manualType == 'lost';
    if (_addManualPenalty) {
      if (_manualType == 'damage') {
        final rate = double.tryParse(_damageRateCtrl.text);
        if (rate != null && rate >= 0) {
          extraPenalty = rate * widget.rent.depositPrice;
        }
      } else if (_manualType == 'lost') {
        extraPenalty = widget.rent.depositPrice.toDouble();
        rentAmount = 0;
        penaltyOverdue = 0;
      } else if (_manualType == 'manual') {
        final amt = double.tryParse(_manualAmountCtrl.text);
        if (amt != null && amt >= 0) {
          extraPenalty = amt;
        }
      }
    }
    final total = rentAmount + penaltyOverdue + extraPenalty;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: const Text('Повернення книги'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RentReturnRow(title: 'Днів у користуванні', value: '${calculation.daysInUse}'),
            RentReturnRow(title: 'Очікувалося днів', value: '${calculation.plannedDays}'),
            RentReturnRow(title: 'Днів прострочки', value: '${calculation.overdueDays}'),
            const SizedBox(height: 8),
            RentReturnRow(title: 'Денна оренда (зі знижкою)', value: calculation.dailyRentRate.toStringAsFixed(2)),
            RentReturnRow(title: 'Оренда до сплати', value: rentAmount.toStringAsFixed(2)),
            RentReturnRow(title: 'Штраф за прострочку', value: penaltyOverdue.toStringAsFixed(2)),
            if (extraPenalty > 0)
              RentReturnRow(title: isLost ? 'Штраф за втрату (застава)' : 'Додатковий штраф', value: extraPenalty.toStringAsFixed(2)),
            const Divider(height: 20),
            RentReturnRow(title: 'Разом до сплати', value: total.toStringAsFixed(2), isEmph: true),
            const SizedBox(height: 12),
            CheckboxListTile(
              value: _addManualPenalty,
              onChanged: (v) => setState(() => _addManualPenalty = v ?? false),
              title: const Text('Додати інший штраф'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            if (_addManualPenalty) ...[
              DropdownButtonFormField<String>(
                value: _manualType,
                decoration: const InputDecoration(labelText: 'Тип штрафу'),
                items: const [
                  DropdownMenuItem(value: 'damage', child: Text('Пошкодження')),
                  DropdownMenuItem(value: 'lost', child: Text('Втрата')),
                  DropdownMenuItem(value: 'manual', child: Text('Ручний')),
                ],
                onChanged: (v) => setState(() => _manualType = v ?? 'damage'),
              ),
              const SizedBox(height: 8),
              if (_manualType == 'damage')
                TextField(
                  controller: _damageRateCtrl,
                  decoration: const InputDecoration(labelText: 'Частка від ціни (0-1)'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => setState(() {}),
                ),
              if (_manualType == 'manual')
                TextField(
                  controller: _manualAmountCtrl,
                  decoration: const InputDecoration(labelText: 'Сума'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => setState(() {}),
                ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: _isSubmitting ? null : () => Navigator.pop(context), child: const Text('Скасувати')),
        ElevatedButton(
          onPressed: _isSubmitting
              ? null
              : () async {
                  setState(() => _isSubmitting = true);
                  final penaltyToCreate = calculation.overdueDays > 0;
                  await widget.cubit.returnRent(widget.rent.id);
                  if (penaltyToCreate) {
                    await widget.cubit.createPenalty(
                      rentId: widget.rent.id,
                      penaltyType: 'overdue',
                      daysOverdue: calculation.overdueDays,
                    );
                  }
                  if (_addManualPenalty) {
                    if (_manualType == 'damage') {
                      final rate = double.tryParse(_damageRateCtrl.text);
                      await widget.cubit.createPenalty(
                        rentId: widget.rent.id,
                        penaltyType: 'damage',
                        damageRate: rate,
                      );
                    } else if (_manualType == 'lost') {
                      await widget.cubit.createPenalty(
                        rentId: widget.rent.id,
                        penaltyType: 'lost',
                      );
                    } else if (_manualType == 'manual') {
                      final amt = double.tryParse(_manualAmountCtrl.text);
                      await widget.cubit.createPenalty(
                        rentId: widget.rent.id,
                        penaltyType: 'manual',
                        manualAmount: amt,
                      );
                    }
                  }
                  if (context.mounted) Navigator.pop(context);
                },
          style: AppButtons.primary(),
          child: _isSubmitting
              ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Підтвердити'),
        ),
      ],
    );
  }
}


