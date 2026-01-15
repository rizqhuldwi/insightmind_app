import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/insightmind/presentation/pages/home_page.dart';
import '../features/insightmind/presentation/pages/login_page.dart';
import '../features/insightmind/presentation/pages/admin_dashboard_page.dart';
import '../features/insightmind/presentation/providers/auth_provider.dart';
<<<<<<< HEAD
import '../features/insightmind/presentation/providers/theme_provider.dart';
import 'app_themes.dart';
=======
>>>>>>> 1d3a904c4797e8b816feaf9bd943964cad564fad

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
<<<<<<< HEAD
    final themeMode = ref.watch(themeProvider);
=======
>>>>>>> 1d3a904c4797e8b816feaf9bd943964cad564fad

    return MaterialApp(
      title: 'InsightMind',
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
=======
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Poppins', fontSize: 14),
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F8FC),
      ),
>>>>>>> 1d3a904c4797e8b816feaf9bd943964cad564fad
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
    return const HomePage();
  }
}
