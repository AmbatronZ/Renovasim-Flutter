class RoomModel {
  final int id;
  final int userId;
  final String? name;
  final String? description;
  final double width;
  final double length;
  final double height;
  final Map<String, dynamic>? layoutData;
  final DateTime createdAt;
  final DateTime updatedAt;

  RoomModel({
    required this.id,
    required this.userId,
    this.name,
    this.description,
    this.width = 4,
    this.length = 5,
    this.height = 3,
    this.layoutData,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      name: json['name'] as String?,
      description: json['description'] as String?,
      width: (json['width'] as num?)?.toDouble() ?? 4,
      length: (json['length'] as num?)?.toDouble() ?? 5,
      height: (json['height'] as num?)?.toDouble() ?? 3,
      layoutData: json['layout_data'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'name': name,
    'description': description,
    'width': width,
    'length': length,
    'height': height,
    'layout_data': layoutData,
  };
}
