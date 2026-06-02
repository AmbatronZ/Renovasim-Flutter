class MaterialModel {
  final int id;
  final String name;
  final String category;
  final double pricePerUnit;
  final String unit;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  MaterialModel({
    required this.id,
    required this.name,
    required this.category,
    required this.pricePerUnit,
    this.unit = 'm²',
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      pricePerUnit: (json['price_per_unit'] as num).toDouble(),
      unit: json['unit'] as String? ?? 'm²',
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'category': category,
    'price_per_unit': pricePerUnit,
    'unit': unit,
    'is_active': isActive,
  };
}
