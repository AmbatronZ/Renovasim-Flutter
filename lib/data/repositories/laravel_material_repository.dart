import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/laravel_api_config.dart';
import '../models/material_model.dart';

/// Repository untuk mengambil data Materials dari Laravel API
/// Endpoint: GET /api/v1/materials
class LaravelMaterialRepository {
  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${LaravelApiConfig.apiKey}',
  };

  /// Ambil semua material dari database via Laravel
  static Future<List<MaterialModel>> getMaterials() async {
    final uri = Uri.parse(
      '${LaravelApiConfig.baseUrl}/api/v1/materials',
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
                MaterialModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Return empty list on failure
    }

    return [];
  }

  /// Ambil material berdasarkan kategori
  static Future<List<MaterialModel>> getMaterialsByCategory(
      String category) async {
    final all = await getMaterials();
    return all
        .where(
            (m) => m.category.toLowerCase() == category.toLowerCase())
        .toList();
  }
}
