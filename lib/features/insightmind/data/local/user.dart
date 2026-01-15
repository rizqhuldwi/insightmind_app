import 'package:hive/hive.dart';

part 'user.g.dart'; // Generated adapter file

@HiveType(typeId: 2) // Unique typeId for User model
class User extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String password; // Hashed password

  @HiveField(3)
  final String role; // 'admin' atau 'user'

  @HiveField(4)
  final String name;

  @HiveField(5)
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
    required this.name,
    required this.createdAt,
  });

  /// Check if user is admin
  bool get isAdmin => role == 'admin';

  /// Check if user is regular user
  bool get isUser => role == 'user';

  /// Create a copy with updated fields
  User copyWith({
    String? id,
    String? username,
    String? password,
    String? role,
    String? name,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
