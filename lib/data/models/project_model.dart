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
    // Helper to safely parse numbers from various formats (int, double, string)
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    }

    // Safely parse everything
    final id = parseInt(json['id']);
    final userId = parseInt(json['user_id']);
    
    final name = (json['name'] ?? json['project_name'])?.toString() ?? 'Unnamed Project';
    final roomType = (json['room_type'] ?? json['mode'])?.toString() ?? 'General';
    final status = (json['status'])?.toString() ?? 'draft';
    
    final areaSize = parseDouble(json['area_size'] ?? json['area']);
    final totalCost = parseDouble(json['total_cost'] ?? json['total_price']);

    // Date fields
    DateTime parseDate(dynamic dateStr) {
      if (dateStr == null) return DateTime.now();
      try {
        return DateTime.parse(dateStr.toString());
      } catch (_) {
        return DateTime.now();
      }
    }
    
    final createdAt = parseDate(json['created_at']);
    final updatedAt = parseDate(json['updated_at']);
    final imagePath = json['image_path']?.toString();

    return ProjectModel(
      id: id,
      userId: userId,
      name: name,
      roomType: roomType,
      areaSize: areaSize,
      totalCost: totalCost,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      imagePath: imagePath,
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