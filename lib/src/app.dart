import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/insightmind/presentation/pages/home_page.dart';
import '../features/insightmind/presentation/pages/login_page.dart';
import '../features/insightmind/presentation/pages/admin_dashboard_page.dart';
import '../features/insightmind/presentation/providers/auth_provider.dart';
import '../features/insightmind/presentation/providers/theme_provider.dart';
import 'app_themes.dart';

class InsightMindApp extends ConsumerStatefulWidget {
  const InsightMindApp({super.key});

  @override
  ConsumerState<InsightMindApp> createState() => _InsightMindAppState();
}

class _InsightMindAppState extends ConsumerState<InsightMindApp> {
  @override
  void initState() {
    super.initState();
    // Cek status autentikasi saat app dimulai
    Future.microtask(() {
      ref.read(authNotifierProvider.notifier).checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final themeSettings = ref.watch(themeProvider);

    return MaterialApp(
      title: 'InsightMind',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.createTheme(false, themeSettings.palette),
      darkTheme: AppTheme.createTheme(true, themeSettings.palette),
      themeMode: themeSettings.mode,
      home: _buildHome(authState),
    );
  }

  Widget _buildHome(AuthState authState) {
    // Loading state saat cek auth
    if (authState.isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.indigo),
              SizedBox(height: 16),
              Text('Memuat...'),
            ],
          ),
        ),
      );
    }

    // Jika belum login, tampilkan login page
    if (!authState.isLoggedIn || authState.user == null) {
      return const LoginPage();
    }

    // Jika admin, tampilkan admin dashboard
    if (authState.user!.isAdmin) {
      return const AdminDashboardPage();
    }

    // Jika user biasa, tampilkan home page
    return const MainPage();
  }
}
