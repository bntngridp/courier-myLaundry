class User {
  final int id;
  final String username;
  final String email;
  final String role;
  final bool isAvailable;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.isAvailable = true,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      isAvailable: json['is_available'] ?? json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
      'is_available': isAvailable,
    };
  }
}
