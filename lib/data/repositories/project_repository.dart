import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/laravel_api_config.dart';
import '../../core/supabase_config.dart';
import '../models/project_model.dart';

class ProjectRepository {
  static final Map<String, String> _supabaseHeaders = {
    'Content-Type': 'application/json',
    'apikey': SupabaseConfig.anonKey,
    'Authorization': 'Bearer ${SupabaseConfig.anonKey}',
    'X-Client-Info': 'renovasim-flutter',
  };

  static final Map<String, String> _laravelHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${LaravelApiConfig.apiKey}',
  };

  static Future<List<ProjectModel>> getProjectsByUserId(int userId) async {
    // Migrated to Supabase 'projects' table
    final uri = Uri.parse(
      '${SupabaseConfig.url}/rest/v1/projects?user_id=eq.$userId&order=created_at.desc',
    );
    final res = await http.get(uri, headers: _supabaseHeaders);

    if (res.statusCode != 200) {
      print('Supabase Fetch Projects Error: ${res.statusCode} - ${res.body}');
      throw Exception('Gagal mengambil proyek dari Supabase (Status: ${res.statusCode})');
    }

    final dataList = jsonDecode(res.body) as List<dynamic>;
    return dataList.map((p) => ProjectModel.fromJson(p as Map<String, dynamic>)).toList();
  }

  static Future<ProjectModel> getProjectById(int projectId) async {
    // Migrated to Supabase 'projects' table
    final uri = Uri.parse(
      '${SupabaseConfig.url}/rest/v1/projects?id=eq.$projectId',
    );
    final res = await http.get(uri, headers: _supabaseHeaders);

    if (res.statusCode != 200) {
      print('Supabase Fetch Project Error: ${res.statusCode} - ${res.body}');
      throw Exception('Gagal mengambil detail proyek dari Supabase');
    }

    final dataList = jsonDecode(res.body) as List<dynamic>;
    if (dataList.isEmpty) {
      throw Exception('Proyek tidak ditemukan');
    }

    return ProjectModel.fromJson(dataList.first as Map<String, dynamic>);
  }

  /**
   * Create Project directly via Supabase Rest API
   */
  static Future<ProjectModel> createProject({
    required int userId,
    required String name,
    required String roomType,
    required double areaSize,
    double totalCost = 0,
    String status = 'draft',
  }) async {
    final uri = Uri.parse('${SupabaseConfig.url}/rest/v1/projects');
    
    final res = await http.post(
      uri,
      headers: {
        ..._supabaseHeaders,
        'Prefer': 'return=representation', // To get the created object back
      },
      body: jsonEncode({
        'user_id': userId,
        'name': name,
        'room_type': roomType,
        'area_size': areaSize,
        'status': status,
        'total_cost': totalCost,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }),
    );

    if (res.statusCode != 201) {
      print('Supabase Create Project Error: ${res.statusCode} - ${res.body}');
      throw Exception('Gagal membuat proyek di Supabase: ${res.statusCode}');
    }

    final dataList = jsonDecode(res.body) as List<dynamic>;
    if (dataList.isEmpty) {
      throw Exception('Gagal memproses data proyek baru');
    }

    return ProjectModel.fromJson(dataList.first as Map<String, dynamic>);
  }

  /**
   * Update Project via Laravel API (to bypass Supabase RLS)
   */
  static Future<ProjectModel> updateProject(int projectId, Map<String, dynamic> data) async {
    final uri = Uri.parse('${LaravelApiConfig.baseUrl}/api/v1/projects/$projectId');
    final res = await http.patch(
      uri,
      headers: _laravelHeaders,
      body: jsonEncode(data),
    );

    if (res.statusCode != 200) {
      print('Laravel Update Project Error: ${res.statusCode} - ${res.body}');
      throw Exception('Gagal memperbarui proyek via API');
    }

    final responseData = jsonDecode(res.body);
    final result = responseData['data'];
    
    if (result is List && result.isNotEmpty) {
      return ProjectModel.fromJson(result.first as Map<String, dynamic>);
    } else if (result is Map) {
      return ProjectModel.fromJson(result as Map<String, dynamic>);
    }
    
    throw Exception('Gagal memproses data update proyek');
  }

  static Future<void> deleteProject(int projectId) async {
    final uri = Uri.parse('${LaravelApiConfig.baseUrl}/api/v1/projects/$projectId');
    final res = await http.delete(
      uri,
      headers: _laravelHeaders,
    );

    if (res.statusCode != 200) {
      throw Exception('Gagal menghapus proyek: ${res.statusCode}');
    }
  }
}
