import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pam_teori/features/insightmind/data/local/profile.dart';
import 'package:pam_teori/features/insightmind/data/local/profile_repository.dart';
import 'package:pam_teori/features/insightmind/presentation/providers/auth_provider.dart';

/// Provider untuk akses ProfileRepository
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

/// Provider untuk mengambil profil user yang sedang login
final currentUserProfileProvider = FutureProvider.autoDispose<Profile?>((
  ref,
) async {
  // Get current user using authNotifier
  final authState = ref.watch(authNotifierProvider);

  if (authState.user == null) return null;

  final profileRepo = ref.watch(profileRepositoryProvider);
  return await profileRepo.getProfile(authState.user!.id);
});

/// State untuk form update profil
class ProfileUpdateState {
  final String? email;
  final String? password;
  final String? phoneNumber;
  final String? profilePicture;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  ProfileUpdateState({
    this.email,
    this.password,
    this.phoneNumber,
    this.profilePicture,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  ProfileUpdateState copyWith({
    String? email,
    String? password,
    String? phoneNumber,
    String? profilePicture,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return ProfileUpdateState(
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

/// Notifier untuk mengelola update profil
class ProfileUpdateNotifier extends StateNotifier<ProfileUpdateState> {
  final ProfileRepository _profileRepository;
  final String _userId;

  ProfileUpdateNotifier({
    required ProfileRepository profileRepository,
    required String userId,
  }) : _profileRepository = profileRepository,
       _userId = userId,
       super(ProfileUpdateState());

  /// Update profil user
  Future<void> updateProfile({
    String? email,
    String? password,
    String? phoneNumber,
    String? profilePicture,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final success = await _profileRepository.updateProfile(
        userId: _userId,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        profilePicture: profilePicture,
      );

      if (success) {
        state = state.copyWith(
          isLoading: false,
          email: email,
          password: password,
          phoneNumber: phoneNumber,
          profilePicture: profilePicture,
          successMessage: 'Profil berhasil diperbarui',
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Gagal memperbarui profil',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error: ${e.toString()}',
      );
    }
  }

  /// Update password profil
  Future<void> updatePassword(String newPassword) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final success = await _profileRepository.updatePassword(
        userId: _userId,
        newPassword: newPassword,
      );

      if (success) {
        state = state.copyWith(
          isLoading: false,
          password: newPassword,
          successMessage: 'Password berhasil diperbarui',
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Gagal memperbarui password',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error: ${e.toString()}',
      );
    }
  }

  /// Clear messages
  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}

/// Provider untuk update profil
final profileUpdateProvider =
    StateNotifierProvider.family<
      ProfileUpdateNotifier,
      ProfileUpdateState,
      String
    >((ref, userId) {
      final profileRepo = ref.watch(profileRepositoryProvider);
      return ProfileUpdateNotifier(
        profileRepository: profileRepo,
        userId: userId,
      );
    });
