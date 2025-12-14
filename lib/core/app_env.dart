import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  static Future<AppEnv> init() async {
    await dotenv.load(fileName: '.env');
    return AppEnv();
  }

  String get apiUrl =>
      dotenv.env['API_URL'] ??
      (throw Exception('API_URL is not set in .env file'));

  double get rentDailyRatePercent {
    final raw = dotenv.env['RENT_DAILY_RATE_PERCENT'];
    final parsed = raw != null ? double.tryParse(raw) : null;
    return parsed ?? 0.02;
  }
}
