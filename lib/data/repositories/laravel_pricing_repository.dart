import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/laravel_api_config.dart';
import '../models/pricing_plan_model.dart';

/// Repository untuk mengambil data Pricing Plans dari Laravel API
/// Endpoint: GET /api/v1/pricing-plans
class LaravelPricingRepository {
  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${LaravelApiConfig.apiKey}',
  };

  /// Ambil semua pricing plans beserta fiturnya
  static Future<List<PricingPlanModel>> getPricingPlans() async {
    final uri = Uri.parse(
      '${LaravelApiConfig.baseUrl}/api/v1/pricing-plans',
    );

    try {
      final res = await http.get(uri, headers: _headers).timeout(
        const Duration(seconds: 10),
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final dataList = body['data'] as List<dynamic>? ?? [];
        return dataList
            .map((e) =>
                PricingPlanModel.fromJson(e as Map<String, dynamic>))
            .where((p) => p.isActive)
            .toList();
      }
    } catch (_) {
      // Return empty list on failure — screen will use hardcoded fallback
    }

    return [];
  }
}
