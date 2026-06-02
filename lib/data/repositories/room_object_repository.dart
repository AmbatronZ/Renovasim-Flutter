import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/supabase_config.dart';
import '../models/room_object_model.dart';

class RoomObjectRepository {
  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'apikey': SupabaseConfig.anonKey,
    'Authorization': 'Bearer ${SupabaseConfig.anonKey}',
  };

  static Future<List<RoomObjectModel>> getObjectsByRoomId(int roomId) async {
    final uri = Uri.parse(
      '${SupabaseConfig.url}/rest/v1/room_objects?room_id=eq.$roomId&order=created_at.desc',
    );
    final res = await http.get(uri, headers: _headers);

    if (res.statusCode != 200) {
      throw Exception('Gagal mengambil objek ruangan');
    }

    final objects = jsonDecode(res.body) as List<dynamic>;
    return objects.map((o) => RoomObjectModel.fromJson(o as Map<String, dynamic>)).toList();
  }

  static Future<RoomObjectModel> createObject({
    required int roomId,
    required String type,
    required List<double> position,
    required List<double> rotation,
    required List<double> scale,
    double? confidence,
    Map<String, dynamic>? metadata,
  }) async {
    final uri = Uri.parse('${SupabaseConfig.url}/rest/v1/room_objects');
    final res = await http.post(
      uri,
      headers: {..._headers, 'Prefer': 'return=representation'},
      body: jsonEncode({
        'room_id': roomId,
        'type': type,
        'position': position,
        'rotation': rotation,
        'scale': scale,
        'confidence': confidence,
        'metadata': metadata,
      }),
    );

    if (res.statusCode != 201) {
      throw Exception('Gagal membuat objek ruangan');
    }

    final result = jsonDecode(res.body) as List<dynamic>;
    return RoomObjectModel.fromJson(result.first as Map<String, dynamic>);
  }

  static Future<RoomObjectModel> updateObject(
    int objectId,
    Map<String, dynamic> data,
  ) async {
    final uri = Uri.parse('${SupabaseConfig.url}/rest/v1/room_objects?id=eq.$objectId');
    final res = await http.patch(
      uri,
      headers: {..._headers, 'Prefer': 'return=representation'},
      body: jsonEncode(data),
    );

    if (res.statusCode != 200) {
      throw Exception('Gagal memperbarui objek ruangan');
    }

    final result = jsonDecode(res.body) as List<dynamic>;
    return RoomObjectModel.fromJson(result.first as Map<String, dynamic>);
  }

  static Future<void> deleteObject(int objectId) async {
    final uri = Uri.parse('${SupabaseConfig.url}/rest/v1/room_objects?id=eq.$objectId');
    final res = await http.delete(uri, headers: _headers);

    if (res.statusCode != 204) {
      throw Exception('Gagal menghapus objek ruangan');
    }
  }
}
