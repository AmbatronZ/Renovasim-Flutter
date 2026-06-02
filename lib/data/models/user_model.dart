class UserModel {
  final int id;
  final String name;
  final String? firstName;
  final String? lastName;
  final String email;
  final String? phone;
  final String? avatarPath;
  final String role;
  final String accountStatus;
  final String? timezone;
  final String? language;
  final String? jobTitle;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    this.firstName,
    this.lastName,
    required this.email,
    this.phone,
    this.avatarPath,
    required this.role,
    required this.accountStatus,
    this.timezone,
    this.language,
    this.jobTitle,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      avatarPath: json['avatar_path'] as String?,
      role: json['role'] as String? ?? 'user',
      accountStatus: json['account_status'] as String? ?? 'active',
      timezone: json['timezone'] as String?,
      language: json['language'] as String?,
      jobTitle: json['job_title'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] as String? ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'phone': phone,
    'avatar_path': avatarPath,
    'role': role,
    'account_status': accountStatus,
    'timezone': timezone,
    'language': language,
    'job_title': jobTitle,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
