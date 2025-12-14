import 'package:library_kursach/core/get_it.dart';
import 'package:library_kursach/core/http_client.dart';

class ImageUtils {
  static String buildImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return '';
    }
    if (imageUrl.startsWith('http')) {
      return imageUrl;
    }
    final httpClient = GetItService().instance<HttpClient>();
    final baseUrl = httpClient.env.apiUrl;
    return '$baseUrl$imageUrl';
  }
}

