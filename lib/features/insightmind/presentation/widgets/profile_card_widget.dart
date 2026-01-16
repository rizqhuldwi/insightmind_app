import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';
import '../providers/auth_provider.dart';
import '../../../../src/app_themes.dart';
import '../../data/local/profile.dart';

/// Widget untuk menampilkan dan mengedit profil user di halaman utama
class ProfileCardWidget extends ConsumerStatefulWidget {
  const ProfileCardWidget({super.key});

  @override
  ConsumerState<ProfileCardWidget> createState() => _ProfileCardWidgetState();
}

class _ProfileCardWidgetState extends ConsumerState<ProfileCardWidget> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _phoneController;
  bool _showPassword = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _loadProfileData(Profile? profile) {
    if (profile != null) {
      _emailController.text = profile.email;
      _passwordController.text = profile.password;
      _phoneController.text = profile.phoneNumber ?? '';
    }
  }

  void _saveProfile(String userId) {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email tidak boleh kosong')));
      return;
    }

    final notifier = ref.read(profileUpdateProvider(userId).notifier);
    notifier.updateProfile(
      email: _emailController.text,
      password: _passwordController.text.isNotEmpty
          ? _passwordController.text
          : null,
      phoneNumber: _phoneController.text.isNotEmpty
          ? _phoneController.text
          : null,
    );

    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final currentProfile = ref.watch(currentUserProfileProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (authState.user == null) {
      return const SizedBox.shrink();
    }

    final user = authState.user!;

    return currentProfile.when(
      data: (profile) {
        // Load data only once
        if (!_isEditing && profile != null && _emailController.text.isEmpty) {
          _loadProfileData(profile);
        }

        final updateState = ref.watch(profileUpdateProvider(user.id));

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          elevation: 2,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: isDark
                  ? LinearGradient(
                      colors: [
                        const Color(0xFF1E1E2E),
                        const Color(0xFF2A2A3E),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [Colors.white, Colors.blue.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with title and edit button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Profil Saya',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : AppColors.primaryBlueDark,
                        ),
                      ),
                      if (!_isEditing)
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            color: Colors.white,
                            onPressed: () => setState(() => _isEditing = true),
                            tooltip: 'Edit Profil',
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  _buildFormField(
                    label: 'Email',
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    enabled: _isEditing,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),

                  // Password Field
                  _buildPasswordField(isDark),
                  const SizedBox(height: 12),

                  // Phone Field
                  _buildFormField(
                    label: 'Nomor Telepon',
                    controller: _phoneController,
                    icon: Icons.phone_outlined,
                    enabled: _isEditing,
                    isDark: isDark,
                    isOptional: true,
                  ),

                  if (updateState.successMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                updateState.successMessage ?? '',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  if (updateState.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                updateState.errorMessage ?? '',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Action Buttons
                  if (_isEditing) ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.close),
                            label: const Text('Batal'),
                            onPressed: () {
                              setState(() => _isEditing = false);
                              _loadProfileData(profile);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: updateState.isLoading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.save),
                            label: Text(
                              updateState.isLoading ? 'Menyimpan...' : 'Simpan',
                            ),
                            onPressed: updateState.isLoading
                                ? null
                                : () => _saveProfile(user.id),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
      loading: () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Profil Saya',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.primaryBlueDark,
                  ),
                ),
                const SizedBox(height: 16),
                const CircularProgressIndicator(),
                const SizedBox(height: 8),
                const Text('Memuat profil...'),
              ],
            ),
          ),
        ),
      ),
      error: (_, __) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Gagal memuat profil',
              style: TextStyle(
                color: isDark ? Colors.red.shade300 : Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build form field
  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool enabled,
    required bool isDark,
    bool isOptional = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${label}${isOptional ? ' (Opsional)' : ''}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.grey[300] : Colors.grey[700],
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primaryBlue,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: enabled
                ? (isDark ? Colors.grey[800] : Colors.white)
                : (isDark ? Colors.grey[900]! : Colors.grey[100]!),
          ),
        ),
      ],
    );
  }

  /// Build password field with visibility toggle
  Widget _buildPasswordField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.grey[300] : Colors.grey[700],
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _passwordController,
          enabled: _isEditing,
          obscureText: !_showPassword,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: _isEditing
                ? IconButton(
                    icon: Icon(
                      _showPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () =>
                        setState(() => _showPassword = !_showPassword),
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primaryBlue,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: _isEditing
                ? (isDark ? Colors.grey[800] : Colors.white)
                : (isDark ? Colors.grey[900]! : Colors.grey[100]!),
          ),
        ),
      ],
    );
  }
}
