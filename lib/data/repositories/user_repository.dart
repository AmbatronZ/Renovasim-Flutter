import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/supabase_config.dart';
import '../models/user_model.dart';

class UserRepository {
  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'apikey': SupabaseConfig.anonKey,
    'Authorization': 'Bearer ${SupabaseConfig.anonKey}',
  };

  static Future<UserModel> getUserById(int userId) async {
    final uri = Uri.parse(
      '${SupabaseConfig.url}/rest/v1/users?id=eq.$userId&select=*',
    );
    final res = await http.get(uri, headers: _headers);

    if (res.statusCode != 200) {
      throw Exception('Gagal mengambil data pengguna');
    }

    final users = jsonDecode(res.body) as List<dynamic>;
    if (users.isEmpty) {
      throw Exception('Pengguna tidak ditemukan');
    }

    return UserModel.fromJson(users.first as Map<String, dynamic>);
  }

  static Future<UserModel> getUserByEmail(String email) async {
    final uri = Uri.parse(
      '${SupabaseConfig.url}/rest/v1/users?email=eq.${Uri.encodeComponent(email)}&select=*',
    );
    final res = await http.get(uri, headers: _headers);

    if (res.statusCode != 200) {
      throw Exception('Gagal mengambil data pengguna');
    }

    final users = jsonDecode(res.body) as List<dynamic>;
    if (users.isEmpty) {
      throw Exception('Pengguna tidak ditemukan');
    }

    return UserModel.fromJson(users.first as Map<String, dynamic>);
  }

  static Future<UserModel> updateProfile(int userId, Map<String, dynamic> data) async {
    final uri = Uri.parse('${SupabaseConfig.url}/rest/v1/users?id=eq.$userId');
    final res = await http.patch(
      uri,
      headers: {..._headers, 'Prefer': 'return=representation'},
      body: jsonEncode(data),
    );

    if (res.statusCode != 200) {
      throw Exception('Gagal memperbarui profil');
    }

    final result = jsonDecode(res.body) as List<dynamic>;
    return UserModel.fromJson(result.first as Map<String, dynamic>);
  }
}
