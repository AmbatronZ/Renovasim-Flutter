import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bcrypt/bcrypt.dart';
import 'supabase_config.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthService {
  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'apikey': SupabaseConfig.anonKey,
    'Authorization': 'Bearer ${SupabaseConfig.anonKey}',
  };

  static Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse(
      '${SupabaseConfig.url}/rest/v1/users'
      '?email=eq.${Uri.encodeComponent(email)}&select=*',
    );
    final res = await http.get(uri, headers: _headers);

    if (res.statusCode != 200) {
      throw AuthException('Gagal terhubung ke server.');
    }

    final users = jsonDecode(res.body) as List<dynamic>;
    if (users.isEmpty) {
      throw AuthException('Email tidak terdaftar.');
    }

    final user = users.first as Map<String, dynamic>;
    final storedHash = user['password'] as String? ?? '';

    if (!BCrypt.checkpw(password, storedHash)) {
      throw AuthException('Password salah.');
    }

    return user;
  }

  static Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    // Cek apakah email sudah ada
    final checkRes = await http.get(
      Uri.parse(
        '${SupabaseConfig.url}/rest/v1/users'
        '?email=eq.${Uri.encodeComponent(email)}&select=id',
      ),
      headers: _headers,
    );
    if (checkRes.statusCode == 200) {
      final existing = jsonDecode(checkRes.body) as List;
      if (existing.isNotEmpty) {
        throw AuthException('Email sudah terdaftar.');
      }
    }

    final firstName = data?['first_name'] as String? ?? '';
    final lastName = data?['last_name'] as String? ?? '';
    final name = '$firstName $lastName'.trim();

    final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

    final insertRes = await http.post(
      Uri.parse('${SupabaseConfig.url}/rest/v1/users'),
      headers: {
        ..._headers,
        'Prefer': 'return=representation',
      },
      body: jsonEncode({
        if (name.isNotEmpty) 'name': name,
        'email': email,
        'password': hashedPassword,
        'role': 'user',
      }),
    );

    if (insertRes.statusCode != 201) {
      final body = jsonDecode(insertRes.body) as Map<String, dynamic>;
      throw AuthException(
        body['message'] ?? body['details'] ?? 'Registrasi gagal.',
      );
    }

    final result = jsonDecode(insertRes.body);
    return result is List ? result.first as Map<String, dynamic> : result;
  }
}
