class RoomObjectModel {
  final int id;
  final int roomId;
  final String type; // 'bed', 'chair', 'table', etc
  final List<double> position; // [x, y, z]
  final List<double> rotation; // [x, y, z]
  final List<double> scale; // [x, y, z]
  final double? confidence;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  RoomObjectModel({
    required this.id,
    required this.roomId,
    required this.type,
    required this.position,
    required this.rotation,
    required this.scale,
    this.confidence,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoomObjectModel.fromJson(Map<String, dynamic> json) {
    return RoomObjectModel(
      id: json['id'] as int,
      roomId: json['room_id'] as int,
      type: json['type'] as String,
      position: _parseList(json['position']),
      rotation: _parseList(json['rotation']),
      scale: _parseList(json['scale']),
      confidence: (json['confidence'] as num?)?.toDouble(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'room_id': roomId,
    'type': type,
    'position': position,
    'rotation': rotation,
    'scale': scale,
    'confidence': confidence,
    'metadata': metadata,
  };

  static List<double> _parseList(dynamic value) {
    if (value is List) {
      return value.map((e) => (e as num).toDouble()).toList();
    }
    return [0, 0, 0];
  }
}
