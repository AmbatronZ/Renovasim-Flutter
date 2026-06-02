class ProjectMaterialModel {
  final int id;
  final int projectId;
  final int materialId;
  final double quantity;
  final double subtotal;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProjectMaterialModel({
    required this.id,
    required this.projectId,
    required this.materialId,
    required this.quantity,
    required this.subtotal,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProjectMaterialModel.fromJson(Map<String, dynamic> json) {
    return ProjectMaterialModel(
      id: json['id'] as int,
      projectId: json['project_id'] as int,
      materialId: json['material_id'] as int,
      quantity: (json['quantity'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'project_id': projectId,
    'material_id': materialId,
    'quantity': quantity,
    'subtotal': subtotal,
  };
}
