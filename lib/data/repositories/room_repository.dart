import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/supabase_config.dart';
import '../models/room_model.dart';

class RoomRepository {
  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'apikey': SupabaseConfig.anonKey,
    'Authorization': 'Bearer ${SupabaseConfig.anonKey}',
  };

  static Future<List<RoomModel>> getRoomsByUserId(int userId) async {
    final uri = Uri.parse(
      '${SupabaseConfig.url}/rest/v1/rooms?user_id=eq.$userId&order=created_at.desc',
    );
    final res = await http.get(uri, headers: _headers);

    if (res.statusCode != 200) {
      throw Exception('Gagal mengambil ruangan');
    }

    final rooms = jsonDecode(res.body) as List<dynamic>;
    return rooms.map((r) => RoomModel.fromJson(r as Map<String, dynamic>)).toList();
  }

  static Future<RoomModel> getRoomById(int roomId) async {
    final uri = Uri.parse(
      '${SupabaseConfig.url}/rest/v1/rooms?id=eq.$roomId&select=*',
    );
    final res = await http.get(uri, headers: _headers);

    if (res.statusCode != 200) {
      throw Exception('Gagal mengambil ruangan');
    }

    final rooms = jsonDecode(res.body) as List<dynamic>;
    if (rooms.isEmpty) {
      throw Exception('Ruangan tidak ditemukan');
    }

    return RoomModel.fromJson(rooms.first as Map<String, dynamic>);
  }

  static Future<RoomModel> createRoom({
    required int userId,
    String? name,
    String? description,
    double width = 4,
    double length = 5,
    double height = 3,
  }) async {
    final uri = Uri.parse('${SupabaseConfig.url}/rest/v1/rooms');
    final res = await http.post(
      uri,
      headers: {..._headers, 'Prefer': 'return=representation'},
      body: jsonEncode({
        'user_id': userId,
        'name': name,
        'description': description,
        'width': width,
        'length': length,
        'height': height,
      }),
    );

    if (res.statusCode != 201) {
      throw Exception('Gagal membuat ruangan');
    }

    final result = jsonDecode(res.body) as List<dynamic>;
    return RoomModel.fromJson(result.first as Map<String, dynamic>);
  }

  static Future<RoomModel> updateRoom(int roomId, Map<String, dynamic> data) async {
    final uri = Uri.parse('${SupabaseConfig.url}/rest/v1/rooms?id=eq.$roomId');
    final res = await http.patch(
      uri,
      headers: {..._headers, 'Prefer': 'return=representation'},
      body: jsonEncode(data),
    );

    if (res.statusCode != 200) {
      throw Exception('Gagal memperbarui ruangan');
    }

    final result = jsonDecode(res.body) as List<dynamic>;
    return RoomModel.fromJson(result.first as Map<String, dynamic>);
  }

  static Future<void> deleteRoom(int roomId) async {
    final uri = Uri.parse('${SupabaseConfig.url}/rest/v1/rooms?id=eq.$roomId');
    final res = await http.delete(uri, headers: _headers);

    if (res.statusCode != 204) {
      throw Exception('Gagal menghapus ruangan');
    }
  }
}
