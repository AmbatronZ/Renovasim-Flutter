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
  final String? imagePath;

  RoomModel({
    required this.id,
    required this.userId,
    this.name,
    this.description,
    required this.width,
    required this.length,
    required this.height,
    this.layoutData,
    required this.createdAt,
    required this.updatedAt,
    this.imagePath,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['user_id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String?,
      description: json['description'] as String?,
      width: (json['width'] as num?)?.toDouble() ?? 4,
      length: (json['length'] as num?)?.toDouble() ?? 5,
      height: (json['height'] as num?)?.toDouble() ?? 3,
      layoutData: json['layout_data'] as Map<String, dynamic>?,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
      imagePath: json['image_path'] as String?,
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
