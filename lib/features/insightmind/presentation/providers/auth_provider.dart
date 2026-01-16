import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/auth_repository.dart';
import '../../data/local/user.dart';
import '../../data/local/history_repository.dart';
import '../../data/local/screening_record.dart';
import '../../data/local/profile_repository.dart';

/// Provider untuk AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Provider untuk cek status login
final isLoggedInProvider = FutureProvider<bool>((ref) async {
  final repo = ref.read(authRepositoryProvider);
  return await repo.isLoggedIn();
});

/// Provider untuk user yang sedang login
final currentUserProvider = FutureProvider<User?>((ref) async {
  final repo = ref.read(authRepositoryProvider);
  return await repo.getCurrentUser();
});

/// Provider untuk semua user (untuk admin)
final allUsersProvider = FutureProvider<List<User>>((ref) async {
  final repo = ref.read(authRepositoryProvider);
  return await repo.getAllUsers();
});

/// Provider untuk screening records per user (untuk admin lihat detail)
final userScreeningRecordsProvider =
    FutureProvider.family<List<ScreeningRecord>, String>((ref, userId) async {
      final historyRepo = HistoryRepository();
      return await historyRepo.getByUserId(userId);
    });

/// Model untuk state autentikasi
class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final User? user;
  final String? errorMessage;

  const AuthState({
    this.isLoading = false,
    this.isLoggedIn = false,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

/// Notifier untuk mengelola state autentikasi
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  late final ProfileRepository _profileRepo;

  AuthNotifier(this._repo) : super(const AuthState()) {
    _profileRepo = ProfileRepository();
  }

  /// Cek status login saat aplikasi dibuka
  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    final isLoggedIn = await _repo.isLoggedIn();
    if (isLoggedIn) {
      final user = await _repo.getCurrentUser();
      state = AuthState(isLoggedIn: true, user: user);
    } else {
      state = const AuthState(isLoggedIn: false);
    }
  }

  /// Login
  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _repo.login(username: username, password: password);

    if (result.success && result.user != null) {
      // Automatically create/update profile with login credentials
      try {
        final existingProfile = await _profileRepo.getProfile(result.user!.id);
        if (existingProfile == null) {
          // Create new profile with login credentials
          await _profileRepo.createProfile(
            userId: result.user!.id,
            email: username, // Using username as email
            password: password,
          );
        }
      } catch (e) {
        // Profile creation failed, but login still successful
        print('Profile creation error: $e');
      }

      state = AuthState(isLoggedIn: true, user: result.user);
      return true;
    } else {
      state = state.copyWith(isLoading: false, errorMessage: result.message);
      return false;
    }
  }

  /// Register
  Future<bool> register(String name, String username, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _repo.register(
      name: name,
      username: username,
      password: password,
    );

    if (result.success) {
      // Auto-create profile after successful registration
      try {
        final user = await _repo.getCurrentUser();
        if (user != null) {
          await _profileRepo.createProfile(
            userId: user.id,
            email: username,
            password: password,
          );
        }
      } catch (e) {
        print('Profile creation error after registration: $e');
      }
    }

    state = state.copyWith(
      isLoading: false,
      errorMessage: result.success ? null : result.message,
    );
    return result.success;
  }

  /// Logout
  Future<void> logout() async {
    await _repo.logout();
    state = const AuthState(isLoggedIn: false);
  }
}

/// Provider untuk AuthNotifier
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  final repo = ref.read(authRepositoryProvider);
  return AuthNotifier(repo);
});

/// Provider untuk state auth (untuk kemudahan akses di widget lain)
final authStateProvider = FutureProvider<User?>((ref) async {
  final repo = ref.read(authRepositoryProvider);
  return await repo.getCurrentUser();
});
