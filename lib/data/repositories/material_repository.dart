import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/supabase_config.dart';
import '../models/material_model.dart';

class MaterialRepository {
  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'apikey': SupabaseConfig.anonKey,
    'Authorization': 'Bearer ${SupabaseConfig.anonKey}',
  };

  static Future<List<MaterialModel>> getAllMaterials({bool activeOnly = true}) async {
    final query = activeOnly ? '&is_active=eq.true' : '';
    final uri = Uri.parse(
      '${SupabaseConfig.url}/rest/v1/materials?order=category.asc,name.asc$query',
    );
    final res = await http.get(uri, headers: _headers);

    if (res.statusCode != 200) {
      throw Exception('Gagal mengambil material');
    }

    final materials = jsonDecode(res.body) as List<dynamic>;
    return materials.map((m) => MaterialModel.fromJson(m as Map<String, dynamic>)).toList();
  }

  static Future<List<MaterialModel>> getMaterialsByCategory(String category) async {
    final uri = Uri.parse(
      '${SupabaseConfig.url}/rest/v1/materials?category=eq.$category&is_active=eq.true&order=name.asc',
    );
    final res = await http.get(uri, headers: _headers);

    if (res.statusCode != 200) {
      throw Exception('Gagal mengambil material');
    }

    final materials = jsonDecode(res.body) as List<dynamic>;
    return materials.map((m) => MaterialModel.fromJson(m as Map<String, dynamic>)).toList();
  }

  static Future<MaterialModel> getMaterialById(int materialId) async {
    final uri = Uri.parse(
      '${SupabaseConfig.url}/rest/v1/materials?id=eq.$materialId&select=*',
    );
    final res = await http.get(uri, headers: _headers);

    if (res.statusCode != 200) {
      throw Exception('Gagal mengambil material');
    }

    final materials = jsonDecode(res.body) as List<dynamic>;
    if (materials.isEmpty) {
      throw Exception('Material tidak ditemukan');
    }

    return MaterialModel.fromJson(materials.first as Map<String, dynamic>);
  }
}
