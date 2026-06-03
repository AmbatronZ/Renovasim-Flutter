import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/laravel_api_config.dart';
import '../../core/supabase_config.dart';
import '../models/estimation_result_model.dart';

/// Repository untuk menghubungi Estimation API
class LaravelEstimationRepository {
  static final Map<String, String> _supabaseHeaders = {
    'Content-Type': 'application/json',
    'apikey': SupabaseConfig.anonKey,
    'Authorization': 'Bearer ${SupabaseConfig.anonKey}',
  };

  /**
   * Save Estimation Result to Supabase 'estimations' table
   */
  static Future<bool> saveToSupabase(int userId, EstimationResultModel result) async {
    try {
      final uri = Uri.parse('${SupabaseConfig.url}/rest/v1/estimations');
      final res = await http.post(
        uri,
        headers: _supabaseHeaders,
        body: jsonEncode({
          'user_id': userId,
          'project_name': result.projectName,
          'location': result.location,
          'total_cost': result.totalEstimate,
          'details': result.toJson(),
          'created_at': DateTime.now().toIso8601String(),
        }),
      );
      return res.statusCode == 201;
    } catch (e) {
      print('Supabase Save Estimation Error: $e');
      return false;
    }
  }

  /**
   * Fetch Recent Estimations from Supabase
   */
  static Future<List<EstimationResultModel>> getRecentEstimations(int userId) async {
    try {
      final uri = Uri.parse(
        '${SupabaseConfig.url}/rest/v1/estimations?user_id=eq.$userId&order=created_at.desc&limit=5',
      );
      final res = await http.get(uri, headers: _supabaseHeaders);

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        return data.map<EstimationResultModel>((item) {
          final details = item['details'];
          if (details is Map<String, dynamic>) {
            return EstimationResultModel.fromJson(details);
          }
          // Fallback if details is not properly stored
          return EstimationResultModel(
            projectName: item['project_name'] ?? 'Estimasi',
            mode: 'legacy',
            location: item['location'] ?? 'jakarta',
            totalEstimate: (item['total_cost'] as num?)?.toDouble() ?? 0,
            confidence: ConfidenceInfo(score: 0, label: '-', message: ''),
            totalRange: TotalRange(
              min: (item['total_cost'] as num?)?.toDouble() ?? 0,
              max: (item['total_cost'] as num?)?.toDouble() ?? 0,
              display: 'Rp ${item['total_cost'] ?? 0}',
            ),
            breakdown: [],
            assumptions: [],
            explanation: [],
            warnings: [],
          );
        }).toList();
      }
      return [];
    } catch (e) {
      print('Supabase Fetch Estimations Error: $e');
      return [];
    }
  }

  /// Estimasi mode AI — deskripsi bebas, dianalisa oleh AI
  /// POST /api/v2/estimate/ai
  static Future<EstimationResultModel> estimateAI({
    required String projectName,
    required String description,
    String? location,
    double? budget,
  }) async {
    // Note: AI Estimation still requires Laravel/Flask AI Server
    // but results will be saved to Supabase later
    return _postEstimation(
      endpoint: '/api/v2/estimate/ai',
      payload: {
        'project_name': projectName,
        'text': description.isNotEmpty
            ? description
            : 'Saya ingin merenovasi di kota ${location ?? 'Jakarta'}',
        if (budget != null && budget > 0) 'budget': budget,
        'location': location,
      },
    );
  }

  /// Estimasi mode Standard/Detailed — berdasarkan jenis pekerjaan & luas area
  /// POST /api/v2/estimate
  static Future<EstimationResultModel> estimateStandard({
    required String projectName,
    required String location,
    String? jobType,
    String quality = 'standar',
    double? area,
    String? description,
    double? budget,
  }) async {
    return _postEstimation(
      endpoint: '/api/v2/estimate',
      payload: {
        'project_name': projectName,
        'location': location.toLowerCase(),
        if (jobType != null) 'job_type': jobType,
        'quality': quality,
        if (area != null) 'area': area,
        if (description != null) 'description': description,
        if (budget != null && budget > 0) 'budget': budget,
      },
    );
  }

  static final Map<String, String> _laravelHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${LaravelApiConfig.apiKey}',
  };

  /// Internal: POST ke estimation endpoint dan parse response
  static Future<EstimationResultModel> _postEstimation({
    required String endpoint,
    required Map<String, dynamic> payload,
  }) async {
    final uri = Uri.parse('${LaravelApiConfig.baseUrl}$endpoint');

    final res = await http
        .post(uri, headers: _laravelHeaders, body: jsonEncode(payload))
        .timeout(const Duration(seconds: 15));

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      if (body is Map<String, dynamic>) {
        return EstimationResultModel.fromJson(body);
      }
    }

    // Jika API gagal, gunakan fallback lokal sederhana
    return _localFallback(
      projectName: payload['project_name'] as String? ?? 'Estimasi',
      location: payload['location'] as String? ?? 'jakarta',
      area: (payload['area'] as num?)?.toDouble() ?? 25,
    );
  }

  /// Fallback kalkulasi lokal jika API tidak tersedia
  /// Mengikuti logika yang sama dengan EstimationController Laravel
  static EstimationResultModel _localFallback({
    required String projectName,
    required String location,
    double area = 25,
  }) {
    const minBase = 150000.0;
    const maxBase = 250000.0;

    final multiplierMap = {
      'jakarta': 1.30,
      'surabaya': 1.15,
      'bandung': 1.10,
      'semarang': 1.05,
      'jogja': 0.90,
      'yogyakarta': 0.90,
    };
    final mult = multiplierMap[location.toLowerCase()] ?? 1.00;

    final totalMin = minBase * area * mult;
    final totalMax = maxBase * area * mult;
    final totalMid = (totalMin + totalMax) / 2;

    return EstimationResultModel(
      projectName: projectName,
      mode: 'fallback',
      location: location,
      totalEstimate: totalMid,
      confidence: ConfidenceInfo(
        score: 60,
        label: 'Sedang (Offline)',
        message:
            'Estimasi dihasilkan menggunakan kalkulasi lokal karena backend API tidak tersedia.',
      ),
      preFraming: 'Estimasi lokal standar pasar.',
      totalRange: TotalRange(
        min: totalMin,
        max: totalMax,
        display: 'Rp ${_formatNumber(totalMid)}',
      ),
      breakdown: [
        BreakdownItem(
          jobType: 'Renovasi Umum',
          area: area,
          min: totalMin,
          max: totalMax,
        ),
      ],
      assumptions: [
        AssumptionItem(
          field: 'Luas Area',
          value: '${area.toStringAsFixed(0)} m²',
          reason: 'Estimasi default',
          needsClarification: true,
        ),
        AssumptionItem(
          field: 'Lokasi',
          value: location,
          reason: 'Dari input pengguna',
          needsClarification: false,
        ),
        AssumptionItem(
          field: 'Kualitas',
          value: 'Standar',
          reason: 'Kualitas default',
          needsClarification: false,
        ),
      ],
      explanation: [
        'Menggunakan kalkulator lokal standar.',
        'Upah disesuaikan dengan tingkat regional kota $location.',
      ],
      warnings: [
        'Backend RAI sedang offline — hasil ini adalah perkiraan kasar.',
      ],
      disclaimer: 'Estimasi cadangan — hubungkan ke server untuk hasil akurat.',
    );
  }

  static String _formatNumber(double value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)} M';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)} Jt';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)} Rb';
    }
    return value.toStringAsFixed(0);
  }
}
