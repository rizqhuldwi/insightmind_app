import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'profile.dart';

/// Repository untuk manajemen profil user
class ProfileRepository {
  static const String profileBoxName = 'profiles';

  /// Simple hash function untuk password (dalam produksi gunakan bcrypt/argon2)
  String _hashPassword(String password) {
    final bytes = utf8.encode('${password}insightmind_profile_salt');
    return base64Encode(bytes);
  }

  /// Buka box profiles
  Future<Box<Profile>> _openProfileBox() async {
    if (!Hive.isBoxOpen(profileBoxName)) {
      return await Hive.openBox<Profile>(profileBoxName);
    }
    return Hive.box<Profile>(profileBoxName);
  }

  /// Ambil profil user berdasarkan userId
  Future<Profile?> getProfile(String userId) async {
    final box = await _openProfileBox();

    final profiles = box.values.where((p) => p.userId == userId).toList();
    return profiles.isNotEmpty ? profiles.first : null;
  }

  /// Buat profil baru
  Future<bool> createProfile({
    required String userId,
    required String email,
    required String password,
    String? phoneNumber,
    String? profilePicture,
  }) async {
    final box = await _openProfileBox();

    // Cek apakah profil sudah ada
    final existing = box.values.where((p) => p.userId == userId).toList();
    if (existing.isNotEmpty) {
      return false; // Profil sudah ada
    }

    final profile = Profile(
      userId: userId,
      email: email,
      password: _hashPassword(password),
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
      updatedAt: DateTime.now(),
    );

    await box.add(profile);
    return true;
  }

  /// Update profil user
  Future<bool> updateProfile({
    required String userId,
    String? email,
    String? password,
    String? phoneNumber,
    String? profilePicture,
  }) async {
    final box = await _openProfileBox();

    final profiles = box.values.where((p) => p.userId == userId).toList();
    if (profiles.isEmpty) {
      return false; // Profil tidak ditemukan
    }

    final profile = profiles.first;
    final index = box.values.toList().indexOf(profile);

    final updatedProfile = profile.copyWith(
      email: email ?? profile.email,
      password: password != null ? _hashPassword(password) : profile.password,
      phoneNumber: phoneNumber ?? profile.phoneNumber,
      profilePicture: profilePicture ?? profile.profilePicture,
      updatedAt: DateTime.now(),
    );

    await box.putAt(index, updatedProfile);
    return true;
  }

  /// Verifikasi password profil
  Future<bool> verifyPassword({
    required String userId,
    required String password,
  }) async {
    final profile = await getProfile(userId);
    if (profile == null) return false;

    final hashedPassword = _hashPassword(password);
    return profile.password == hashedPassword;
  }

  /// Update password profil
  Future<bool> updatePassword({
    required String userId,
    required String newPassword,
  }) async {
    return updateProfile(userId: userId, password: newPassword);
  }

  /// Hapus profil user
  Future<bool> deleteProfile(String userId) async {
    final box = await _openProfileBox();

    final profiles = box.values.where((p) => p.userId == userId).toList();
    if (profiles.isEmpty) {
      return false; // Profil tidak ditemukan
    }

    final profile = profiles.first;
    final index = box.values.toList().indexOf(profile);

    await box.deleteAt(index);
    return true;
  }

  /// Get all profiles (admin only)
  Future<List<Profile>> getAllProfiles() async {
    final box = await _openProfileBox();
    return box.values.toList();
  }
}
