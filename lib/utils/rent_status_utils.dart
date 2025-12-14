import 'package:flutter/material.dart';

class RentStatusNames {
  static const String active = 'active';
  static const String pending = 'pending';
  static const String returned = 'returned';
  static const String declined = 'declined';
  static const String cancelled = 'cancelled';
  static const String issued = 'issued';
  static const String overdue = 'overdue';
}

class RentStatusUtils {
  static String getLabel(String status) {
    switch (status) {
      case RentStatusNames.pending:
        return 'Очікує';
      case RentStatusNames.active:
        return 'Активна';
      case RentStatusNames.returned:
        return 'Повернена';
      case RentStatusNames.declined:
        return 'Відхилена';
      case RentStatusNames.cancelled:
        return 'Скасована';
      case RentStatusNames.issued:
        return 'Видана';
      case RentStatusNames.overdue:
        return 'Прострочена';
      default:
        return status;
    }
  }

  static Color getColor(String status) {
    switch (status) {
      case RentStatusNames.pending:
        return Colors.orange;
      case RentStatusNames.active:
        return Colors.blue;
      case RentStatusNames.returned:
        return Colors.green;
      case RentStatusNames.declined:
        return Colors.red;
      case RentStatusNames.cancelled:
        return Colors.grey;
      case RentStatusNames.issued:
        return Colors.blue;
      case RentStatusNames.overdue:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  static List<DropdownMenuItem<String?>> buildDropdownItems({bool includeAll = true}) {
    final items = <DropdownMenuItem<String?>>[];
    if (includeAll) {
      items.add(const DropdownMenuItem(value: null, child: Text('Усі')));
    }
    items.addAll([
      DropdownMenuItem(value: RentStatusNames.pending, child: Text(getLabel(RentStatusNames.pending))),
      const DropdownMenuItem(value: RentStatusNames.active, child: Text('Активні')),
      const DropdownMenuItem(value: RentStatusNames.returned, child: Text('Повернені')),
      const DropdownMenuItem(value: RentStatusNames.declined, child: Text('Відхилені')),
    ]);
    return items;
  }
}

