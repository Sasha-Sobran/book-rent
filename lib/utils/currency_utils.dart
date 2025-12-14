class CurrencyUtils {
  static String formatCurrency(double amount, {int decimals = 2}) {
    return '${amount.toStringAsFixed(decimals)} ₴';
  }

  static String formatCurrencyNullable(double? amount, {int decimals = 2}) {
    return amount == null ? '-' : formatCurrency(amount, decimals: decimals);
  }
}

