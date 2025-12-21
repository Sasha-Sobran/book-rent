import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_kursach/core/theme/theme.dart';
import 'package:library_kursach/models/rent.dart';
import 'package:library_kursach/modules/my_rents_module/cubit.dart';
import 'package:library_kursach/modules/rents_module/utils/rent_calculations.dart';
import 'package:library_kursach/utils/date_utils.dart' as app_date;
import 'package:library_kursach/utils/rent_status_utils.dart';
import 'package:library_kursach/utils/currency_utils.dart';
import 'package:library_kursach/common_widgets/info_chip.dart';

class MyRentsScreen extends StatelessWidget {
  static const path = '/my-rents';

  const MyRentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyRentsCubit()..init(context),
      child: Container(
        decoration: AppDecorations.backgroundGradient,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            children: const [
              _Header(),
              SizedBox(height: 12),
              Expanded(child: _List()),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MyRentsCubit>();
    return BlocBuilder<MyRentsCubit, MyRentsState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: AppDecorations.cardDecoration,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.assignment_ind_outlined, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Мої ренти', style: AppTextStyles.h3),
                    Text('${state.rents.length} записів', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              const SizedBox(width: 12),
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

class _List extends StatelessWidget {
  const _List();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyRentsCubit, MyRentsState>(
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
                Text('Рентів немає', style: AppTextStyles.h4.copyWith(color: AppColors.textMuted)),
              ],
            ),
          );
        }
        return ListView.separated(
          itemCount: state.rents.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final rent = state.rents[index];
            return _Card(rent: rent);
          },
        );
      },
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.rent});

  final Rent rent;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MyRentsCubit>();
    final calculation = RentCalculations.calculateRentAmounts(rent);
    
    return BlocBuilder<MyRentsCubit, MyRentsState>(
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
                        Text('Статус: ${_statusLabel(rent.status)}', style: AppTextStyles.bodySmall),
                        Text(
                          'Очікувана дата повернення: ${app_date.AppDateUtils.formatDate(rent.expectedReturnDate)}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: calculation.isOverdue ? AppColors.error : null,
                            fontWeight: calculation.isOverdue ? FontWeight.w600 : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _StatusChip(status: rent.status),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 6,
                children: [
                  InfoChip.icon(icon: Icons.calendar_today_outlined, label: 'Старт: ${app_date.AppDateUtils.formatDate(rent.rentDate)}'),
                  InfoChip.icon(icon: Icons.payments_outlined, label: 'Оренда: ${CurrencyUtils.formatCurrency(rent.rentPrice)}'),
                  InfoChip.icon(icon: Icons.safety_check_outlined, label: 'Застава: ${rent.depositPrice}'),
                  if (rent.returnDate != null) InfoChip.icon(icon: Icons.event_available_outlined, label: 'Повернено: ${app_date.AppDateUtils.formatDate(rent.returnDate!)}'),
                ],
              ),
              const SizedBox(height: 12),
              if (rent.status == RentStatusNames.pending)
                Row(
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.cancel, size: 18),
                      label: const Text('Скасувати'),
                      onPressed: isBusy ? null : () => cubit.cancel(rent.id),
                    ),
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


  String _statusLabel(String status) => RentStatusUtils.getLabel(status);
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = RentStatusUtils.getColor(status);
    final label = RentStatusUtils.getLabel(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
    );
  }
}



