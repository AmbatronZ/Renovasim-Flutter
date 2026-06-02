class ProjectModel {
  final int id;
  final int userId;
  final String name;
  final String roomType;
  final double areaSize;
  final double totalCost;
  final String status; // draft, estimated, completed
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imagePath; // optional for UI

  ProjectModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.roomType,
    required this.areaSize,
    this.totalCost = 0,
    this.status = 'draft',
    required this.createdAt,
    required this.updatedAt,
    this.imagePath,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      name: json['name'] as String,
      roomType: json['room_type'] as String,
      areaSize: (json['area_size'] as num).toDouble(),
      totalCost: (json['total_cost'] as num?)?.toDouble() ?? 0,
      status: json['status'] as String? ?? 'draft',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      imagePath: json['image_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'name': name,
    'room_type': roomType,
    'area_size': areaSize,
    'total_cost': totalCost,
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  bool get isInProgress => status == 'estimated' || status == 'completed';
}