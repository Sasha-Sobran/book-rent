import 'dart:math' as math;
import 'package:library_kursach/models/rent.dart';
import 'package:library_kursach/utils/date_utils.dart';
import 'package:library_kursach/utils/rent_status_utils.dart';

class RentCalculations {
  static RentCalculationResult calculateRentAmounts(Rent rent) {
    final now = DateTime.now();
    final nowDate = AppDateUtils.dateOnly(now);
    final rentDate = AppDateUtils.dateOnly(rent.rentDate);
    final expectedReturnDate = AppDateUtils.dateOnly(rent.expectedReturnDate);

    double actualRentAmount = rent.rentPrice;
    double actualPenaltyAmount = rent.penaltiesAmount;
    double actualTotalAmount = rent.totalAmount;

    if (rent.returnDate == null &&
        (rent.status == RentStatusNames.active || rent.status == RentStatusNames.issued || rent.status == RentStatusNames.overdue)) {
      final daysInUse = math.max(AppDateUtils.daysBetween(rentDate, nowDate), 1);
      final overdueDays = AppDateUtils.isDateAfter(nowDate, expectedReturnDate)
          ? AppDateUtils.daysBetween(expectedReturnDate, nowDate)
          : 0;
      final plannedDays = math.max(AppDateUtils.daysBetween(rentDate, expectedReturnDate), 1);
      final dailyRentRate = plannedDays > 0 ? rent.rentPrice / plannedDays : rent.rentPrice;

      actualRentAmount = dailyRentRate * daysInUse;
      actualPenaltyAmount = rent.penaltiesAmount;
      if (overdueDays > 0) {
        actualPenaltyAmount += dailyRentRate * 1.2 * overdueDays;
      }
      actualTotalAmount = actualRentAmount + actualPenaltyAmount;

      return RentCalculationResult(
        daysInUse: daysInUse,
        overdueDays: overdueDays,
        plannedDays: plannedDays,
        dailyRentRate: dailyRentRate,
        actualRentAmount: actualRentAmount,
        actualPenaltyAmount: actualPenaltyAmount,
        actualTotalAmount: actualTotalAmount,
        isOverdue: overdueDays > 0,
      );
    }

    return RentCalculationResult(
      daysInUse: 0,
      overdueDays: 0,
      plannedDays: 0,
      dailyRentRate: 0,
      actualRentAmount: actualRentAmount,
      actualPenaltyAmount: actualPenaltyAmount,
      actualTotalAmount: actualTotalAmount,
      isOverdue: false,
    );
  }

  static ReturnDialogCalculationResult calculateReturnDialogAmounts(Rent rent) {
    final now = DateTime.now();
    final nowDate = AppDateUtils.dateOnly(now);
    final rentDate = AppDateUtils.dateOnly(rent.rentDate);
    final expectedReturnDate = AppDateUtils.dateOnly(rent.expectedReturnDate);

    final daysInUse = math.max(AppDateUtils.daysBetween(rentDate, nowDate), 1);
    final overdueDays = AppDateUtils.isDateAfter(nowDate, expectedReturnDate)
        ? AppDateUtils.daysBetween(expectedReturnDate, nowDate)
        : 0;
    final plannedDays = math.max(AppDateUtils.daysBetween(rentDate, expectedReturnDate), 1);
    final dailyRentRate = plannedDays > 0 ? rent.rentPrice / plannedDays : rent.rentPrice;
    final rentAmount = dailyRentRate * daysInUse;
    final penaltyOverdue = overdueDays > 0 ? dailyRentRate * 1.2 * overdueDays : 0;

    return ReturnDialogCalculationResult(
      daysInUse: daysInUse,
      overdueDays: overdueDays,
      plannedDays: plannedDays,
      dailyRentRate: dailyRentRate,
      rentAmount: rentAmount,
      penaltyOverdue: penaltyOverdue.toDouble(),
    );
  }
}

class RentCalculationResult {
  final int daysInUse;
  final int overdueDays;
  final int plannedDays;
  final double dailyRentRate;
  final double actualRentAmount;
  final double actualPenaltyAmount;
  final double actualTotalAmount;
  final bool isOverdue;

  RentCalculationResult({
    required this.daysInUse,
    required this.overdueDays,
    required this.plannedDays,
    required this.dailyRentRate,
    required this.actualRentAmount,
    required this.actualPenaltyAmount,
    required this.actualTotalAmount,
    required this.isOverdue,
  });
}

class ReturnDialogCalculationResult {
  final int daysInUse;
  final int overdueDays;
  final int plannedDays;
  final double dailyRentRate;
  final double rentAmount;
  final double penaltyOverdue;

  ReturnDialogCalculationResult({
    required this.daysInUse,
    required this.overdueDays,
    required this.plannedDays,
    required this.dailyRentRate,
    required this.rentAmount,
    required this.penaltyOverdue,
  });
}

