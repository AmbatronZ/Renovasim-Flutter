import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/supabase_config.dart';
import '../models/project_material_model.dart';

class ProjectMaterialRepository {
  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'apikey': SupabaseConfig.anonKey,
    'Authorization': 'Bearer ${SupabaseConfig.anonKey}',
  };

  static Future<List<ProjectMaterialModel>> getMaterialsByProjectId(int projectId) async {
    final uri = Uri.parse(
      '${SupabaseConfig.url}/rest/v1/project_materials?project_id=eq.$projectId&order=created_at.desc',
    );
    final res = await http.get(uri, headers: _headers);

    if (res.statusCode != 200) {
      throw Exception('Gagal mengambil material proyek');
    }

    final materials = jsonDecode(res.body) as List<dynamic>;
    return materials
        .map((m) => ProjectMaterialModel.fromJson(m as Map<String, dynamic>))
        .toList();
  }

  static Future<ProjectMaterialModel> addMaterialToProject({
    required int projectId,
    required int materialId,
    required double quantity,
    required double subtotal,
  }) async {
    final uri = Uri.parse('${SupabaseConfig.url}/rest/v1/project_materials');
    final res = await http.post(
      uri,
      headers: {..._headers, 'Prefer': 'return=representation'},
      body: jsonEncode({
        'project_id': projectId,
        'material_id': materialId,
        'quantity': quantity,
        'subtotal': subtotal,
      }),
    );

    if (res.statusCode != 201) {
      throw Exception('Gagal menambahkan material ke proyek');
    }

    final result = jsonDecode(res.body) as List<dynamic>;
    return ProjectMaterialModel.fromJson(result.first as Map<String, dynamic>);
  }

  static Future<ProjectMaterialModel> updateProjectMaterial(
    int projectMaterialId,
    Map<String, dynamic> data,
  ) async {
    final uri =
        Uri.parse('${SupabaseConfig.url}/rest/v1/project_materials?id=eq.$projectMaterialId');
    final res = await http.patch(
      uri,
      headers: {..._headers, 'Prefer': 'return=representation'},
      body: jsonEncode(data),
    );

    if (res.statusCode != 200) {
      throw Exception('Gagal memperbarui material proyek');
    }

    final result = jsonDecode(res.body) as List<dynamic>;
    return ProjectMaterialModel.fromJson(result.first as Map<String, dynamic>);
  }

  static Future<void> removeMaterialFromProject(int projectMaterialId) async {
    final uri =
        Uri.parse('${SupabaseConfig.url}/rest/v1/project_materials?id=eq.$projectMaterialId');
    final res = await http.delete(uri, headers: _headers);

    if (res.statusCode != 204) {
      throw Exception('Gagal menghapus material dari proyek');
    }
  }
}
