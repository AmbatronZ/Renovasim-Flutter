import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/laravel_api_config.dart';
import '../models/room_model.dart';

import '../../core/supabase_config.dart';

class RoomRepository {
  static final Map<String, String> _supabaseHeaders = {
    'Content-Type': 'application/json',
    'apikey': SupabaseConfig.anonKey,
    'Authorization': 'Bearer ${SupabaseConfig.anonKey}',
  };

  static Future<List<RoomModel>> getRoomsByUserId(int userId) async {
    // Fetching from Supabase 'rooms' table
    final uri = Uri.parse(
      '${SupabaseConfig.url}/rest/v1/rooms?user_id=eq.$userId&order=created_at.desc',
    );
    final res = await http.get(uri, headers: _supabaseHeaders);

    if (res.statusCode != 200) {
      print('Supabase Fetch Rooms Error: ${res.statusCode} - ${res.body}');
      throw Exception('Gagal mengambil data 3D Design dari Supabase');
    }

    final dataList = jsonDecode(res.body) as List<dynamic>;
    return dataList.map((r) => RoomModel.fromJson(r as Map<String, dynamic>)).toList();
  }
}
