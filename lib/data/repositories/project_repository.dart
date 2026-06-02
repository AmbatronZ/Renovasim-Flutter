import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/supabase_config.dart';
import '../models/project_model.dart';

class ProjectRepository {
  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'apikey': SupabaseConfig.anonKey,
    'Authorization': 'Bearer ${SupabaseConfig.anonKey}',
  };

  static Future<List<ProjectModel>> getProjectsByUserId(int userId) async {
    final uri = Uri.parse(
      '${SupabaseConfig.url}/rest/v1/projects?user_id=eq.$userId&order=created_at.desc',
    );
    final res = await http.get(uri, headers: _headers);

    if (res.statusCode != 200) {
      throw Exception('Gagal mengambil proyek');
    }

    final projects = jsonDecode(res.body) as List<dynamic>;
    return projects.map((p) => ProjectModel.fromJson(p as Map<String, dynamic>)).toList();
  }

  static Future<ProjectModel> getProjectById(int projectId) async {
    final uri = Uri.parse(
      '${SupabaseConfig.url}/rest/v1/projects?id=eq.$projectId&select=*',
    );
    final res = await http.get(uri, headers: _headers);

    if (res.statusCode != 200) {
      throw Exception('Gagal mengambil proyek');
    }

    final projects = jsonDecode(res.body) as List<dynamic>;
    if (projects.isEmpty) {
      throw Exception('Proyek tidak ditemukan');
    }

    return ProjectModel.fromJson(projects.first as Map<String, dynamic>);
  }

  static Future<ProjectModel> createProject({
    required int userId,
    required String name,
    required String roomType,
    required double areaSize,
  }) async {
    final uri = Uri.parse('${SupabaseConfig.url}/rest/v1/projects');
    final res = await http.post(
      uri,
      headers: {..._headers, 'Prefer': 'return=representation'},
      body: jsonEncode({
        'user_id': userId,
        'name': name,
        'room_type': roomType,
        'area_size': areaSize,
        'status': 'draft',
        'total_cost': 0,
      }),
    );

    if (res.statusCode != 201) {
      throw Exception('Gagal membuat proyek');
    }

    final result = jsonDecode(res.body) as List<dynamic>;
    return ProjectModel.fromJson(result.first as Map<String, dynamic>);
  }

  static Future<ProjectModel> updateProject(int projectId, Map<String, dynamic> data) async {
    final uri = Uri.parse('${SupabaseConfig.url}/rest/v1/projects?id=eq.$projectId');
    final res = await http.patch(
      uri,
      headers: {..._headers, 'Prefer': 'return=representation'},
      body: jsonEncode(data),
    );

    if (res.statusCode != 200) {
      throw Exception('Gagal memperbarui proyek');
    }

    final result = jsonDecode(res.body) as List<dynamic>;
    return ProjectModel.fromJson(result.first as Map<String, dynamic>);
  }

  static Future<void> deleteProject(int projectId) async {
    final uri = Uri.parse('${SupabaseConfig.url}/rest/v1/projects?id=eq.$projectId');
    final res = await http.delete(uri, headers: _headers);

    if (res.statusCode != 204) {
      throw Exception('Gagal menghapus proyek');
    }
  }
}
