/// Model untuk data Pricing Plan dari Laravel API
/// Endpoint: GET /api/v1/pricing-plans
class PricingPlanModel {
  final int id;
  final String name;
  final String? description;
  final double priceMonthly;
  final double priceAnnual;
  final String? badge;
  final bool isPopular;
  final bool isActive;
  final List<PlanFeatureModel> features;

  PricingPlanModel({
    required this.id,
    required this.name,
    this.description,
    required this.priceMonthly,
    required this.priceAnnual,
    this.badge,
    this.isPopular = false,
    this.isActive = true,
    required this.features,
  });

  factory PricingPlanModel.fromJson(Map<String, dynamic> json) {
    return PricingPlanModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Plan',
      description: json['description'] as String?,
      priceMonthly: (json['price_monthly'] as num?)?.toDouble() ??
          (json['price'] as num?)?.toDouble() ??
          0,
      priceAnnual: (json['price_annual'] as num?)?.toDouble() ??
          ((json['price_monthly'] as num?)?.toDouble() ?? 0) * 0.85,
      badge: json['badge'] as String?,
      isPopular: json['is_popular'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      features: (json['features'] as List<dynamic>? ?? [])
          .map((e) => PlanFeatureModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PlanFeatureModel {
  final int id;
  final String text;
  final bool isHighlight;

  PlanFeatureModel({
    required this.id,
    required this.text,
    this.isHighlight = false,
  });

  factory PlanFeatureModel.fromJson(Map<String, dynamic> json) {
    return PlanFeatureModel(
      id: json['id'] as int? ?? 0,
      text: json['text'] as String? ??
          json['feature'] as String? ??
          json['name'] as String? ??
          '',
      isHighlight: json['is_highlight'] as bool? ?? false,
    );
  }
}
