import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'user.dart';

/// Repository untuk autentikasi dan manajemen user
class AuthRepository {
  static const String userBoxName = 'users';
  static const String sessionBoxName = 'auth_session';

  // Default admin credentials
  static const String defaultAdminUsername = 'admin';
  static const String defaultAdminPassword = 'admin123';
  static const String defaultAdminName = 'Administrator';

  /// Simple hash function untuk password (dalam produksi gunakan bcrypt/argon2)
  String _hashPassword(String password) {
    // Simple hash menggunakan base64 encoding
    // Untuk keamanan lebih baik, gunakan package crypto
    final bytes = utf8.encode(password + 'insightmind_salt');
    return base64Encode(bytes);
  }

  /// Buka box users
  Future<Box<User>> _openUserBox() async {
    if (!Hive.isBoxOpen(userBoxName)) {
      return await Hive.openBox<User>(userBoxName);
    }
    return Hive.box<User>(userBoxName);
  }

  /// Buka box session
  Future<Box<dynamic>> _openSessionBox() async {
    if (!Hive.isBoxOpen(sessionBoxName)) {
      return await Hive.openBox(sessionBoxName);
    }
    return Hive.box(sessionBoxName);
  }

  /// Inisialisasi admin default jika belum ada
  Future<void> initDefaultAdmin() async {
    final box = await _openUserBox();
    
    // Cek apakah admin sudah ada
    final existingAdmin = box.values.where((u) => u.username == defaultAdminUsername).toList();
    if (existingAdmin.isEmpty) {
      final adminUser = User(
        id: const Uuid().v4(),
        username: defaultAdminUsername,
        password: _hashPassword(defaultAdminPassword),
        role: 'admin',
        name: defaultAdminName,
        createdAt: DateTime.now(),
      );
      await box.put(adminUser.id, adminUser);
    }
  }

  /// Register user baru
  Future<({bool success, String message})> register({
    required String name,
    required String username,
    required String password,
  }) async {
    final box = await _openUserBox();

    // Cek apakah username sudah ada
    final existing = box.values.where((u) => u.username == username).toList();
    if (existing.isNotEmpty) {
      return (success: false, message: 'Username sudah digunakan');
    }

    // Buat user baru
    final newUser = User(
      id: const Uuid().v4(),
      username: username,
      password: _hashPassword(password),
      role: 'user', // Default role adalah user biasa
      name: name,
      createdAt: DateTime.now(),
    );

    await box.put(newUser.id, newUser);
    return (success: true, message: 'Registrasi berhasil!');
  }

  /// Login user
  Future<({bool success, String message, User? user})> login({
    required String username,
    required String password,
  }) async {
    final box = await _openUserBox();
    final hashedPassword = _hashPassword(password);

    // Cari user berdasarkan username dan password
    final users = box.values.where(
      (u) => u.username == username && u.password == hashedPassword
    ).toList();

    if (users.isEmpty) {
      return (success: false, message: 'Username atau password salah', user: null);
    }

    final user = users.first;

    // Simpan session
    final sessionBox = await _openSessionBox();
    await sessionBox.put('current_user_id', user.id);
    await sessionBox.put('is_logged_in', true);

    return (success: true, message: 'Login berhasil!', user: user);
  }

  /// Logout user
  Future<void> logout() async {
    final sessionBox = await _openSessionBox();
    await sessionBox.delete('current_user_id');
    await sessionBox.put('is_logged_in', false);
  }

  /// Cek apakah sudah login
  Future<bool> isLoggedIn() async {
    final sessionBox = await _openSessionBox();
    return sessionBox.get('is_logged_in', defaultValue: false) ?? false;
  }

  /// Ambil user yang sedang login
  Future<User?> getCurrentUser() async {
    final sessionBox = await _openSessionBox();
    final isLoggedIn = sessionBox.get('is_logged_in', defaultValue: false) ?? false;
    
    if (!isLoggedIn) return null;

    final userId = sessionBox.get('current_user_id');
    if (userId == null) return null;

    final userBox = await _openUserBox();
    return userBox.get(userId);
  }

  /// Ambil semua user (untuk admin)
  Future<List<User>> getAllUsers() async {
    final box = await _openUserBox();
    final users = box.values.toList();
    // Urutkan berdasarkan tanggal dibuat (terbaru dulu)
    users.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return users;
  }

  /// Ambil user berdasarkan ID
  Future<User?> getUserById(String userId) async {
    final box = await _openUserBox();
    return box.get(userId);
  }

  /// Hapus user (untuk admin)
  Future<void> deleteUser(String userId) async {
    final box = await _openUserBox();
    await box.delete(userId);
  }
}
