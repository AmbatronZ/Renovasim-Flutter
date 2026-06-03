/// Model untuk menampung response dari Laravel Estimation API
/// Endpoint: POST /api/v2/estimate atau /api/v2/estimate/ai
class EstimationResultModel {
  final String projectName;
  final String mode;
  final String location;
  final double totalEstimate;
  final ConfidenceInfo confidence;
  final String? preFraming;
  final TotalRange totalRange;
  final List<BreakdownItem> breakdown;
  final List<AssumptionItem> assumptions;
  final List<String> explanation;
  final List<String> warnings;
  final String? disclaimer;

  EstimationResultModel({
    required this.projectName,
    required this.mode,
    this.location = 'jakarta',
    this.totalEstimate = 0,
    required this.confidence,
    this.preFraming,
    required this.totalRange,
    required this.breakdown,
    required this.assumptions,
    required this.explanation,
    required this.warnings,
    this.disclaimer,
  });

  factory EstimationResultModel.fromJson(Map<String, dynamic> json) {
    return EstimationResultModel(
      projectName: json['project_name'] as String? ?? 'Estimasi',
      mode: json['mode'] as String? ?? 'ai',
      location: json['location'] as String? ?? 'jakarta',
      totalEstimate: (json['total_estimate'] as num?)?.toDouble() ?? 
                     (json['total_range']?['min'] as num?)?.toDouble() ?? 0,
      confidence: ConfidenceInfo.fromJson(
        json['confidence'] as Map<String, dynamic>? ?? {},
      ),
      preFraming: json['pre_framing'] as String?,
      totalRange: TotalRange.fromJson(
        json['total_range'] as Map<String, dynamic>? ?? {},
      ),
      breakdown: (json['breakdown'] as List<dynamic>? ?? [])
          .map((e) => BreakdownItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      assumptions: (json['assumptions'] as List<dynamic>? ?? [])
          .map((e) => AssumptionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      explanation: (json['explanation'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      warnings: (json['warnings'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      disclaimer: json['disclaimer'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'project_name': projectName,
      'mode': mode,
      'location': location,
      'total_estimate': totalEstimate,
      'confidence': {
        'score': confidence.score,
        'label': confidence.label,
        'message': confidence.message,
      },
      'pre_framing': preFraming,
      'total_range': {
        'min': totalRange.min,
        'max': totalRange.max,
        'display': totalRange.display,
      },
      'breakdown': breakdown.map((e) => {
        'job_type': e.jobType,
        'area': e.area,
        'min': e.min,
        'max': e.max,
      }).toList(),
      'assumptions': assumptions.map((e) => {
        'field': e.field,
        'value': e.value,
        'reason': e.reason,
        'needs_clarification': e.needsClarification,
      }).toList(),
      'explanation': explanation,
      'warnings': warnings,
      'disclaimer': disclaimer,
    };
  }
}

class ConfidenceInfo {
  final int score;
  final String label;
  final String message;

  ConfidenceInfo({
    required this.score,
    required this.label,
    required this.message,
  });

  factory ConfidenceInfo.fromJson(Map<String, dynamic> json) {
    return ConfidenceInfo(
      score: (json['score'] as num?)?.toInt() ?? 0,
      label: json['label'] as String? ?? '-',
      message: json['message'] as String? ?? '',
    );
  }
}

class TotalRange {
  final double min;
  final double max;
  final String display;

  TotalRange({
    required this.min,
    required this.max,
    required this.display,
  });

  factory TotalRange.fromJson(Map<String, dynamic> json) {
    return TotalRange(
      min: (json['min'] as num?)?.toDouble() ?? 0,
      max: (json['max'] as num?)?.toDouble() ?? 0,
      display: json['display'] as String? ?? '-',
    );
  }
}

class BreakdownItem {
  final String jobType;
  final double area;
  final double min;
  final double max;

  BreakdownItem({
    required this.jobType,
    required this.area,
    required this.min,
    required this.max,
  });

  factory BreakdownItem.fromJson(Map<String, dynamic> json) {
    return BreakdownItem(
      jobType: json['job_type'] as String? ?? 'unknown',
      area: (json['area'] as num?)?.toDouble() ?? 0,
      min: (json['min'] as num?)?.toDouble() ?? 0,
      max: (json['max'] as num?)?.toDouble() ?? 0,
    );
  }
}

class AssumptionItem {
  final String field;
  final String value;
  final String reason;
  final bool needsClarification;

  AssumptionItem({
    required this.field,
    required this.value,
    required this.reason,
    required this.needsClarification,
  });

  factory AssumptionItem.fromJson(Map<String, dynamic> json) {
    return AssumptionItem(
      field: json['field'] as String? ?? '',
      value: json['value'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      needsClarification: json['needs_clarification'] as bool? ?? false,
    );
  }
}
