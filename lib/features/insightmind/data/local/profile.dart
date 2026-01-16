import 'package:hive/hive.dart';

part 'profile.g.dart'; // Generated adapter file

@HiveType(typeId: 3) // Unique typeId for Profile model
class Profile extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  String email;

  @HiveField(2)
  String password; // Hashed password untuk profil

  @HiveField(3)
  String? phoneNumber;

  @HiveField(4)
  String? profilePicture; // URL atau path ke gambar profil

  @HiveField(5)
  DateTime updatedAt;

  Profile({
    required this.userId,
    required this.email,
    required this.password,
    this.phoneNumber,
    this.profilePicture,
    required this.updatedAt,
  });

  /// Create a copy with updated fields
  Profile copyWith({
    String? userId,
    String? email,
    String? password,
    String? phoneNumber,
    String? profilePicture,
    DateTime? updatedAt,
  }) {
    return Profile(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
