import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../../data/local/user.dart';
import '../../data/local/screening_record.dart';
import 'login_page.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allUsersAsync = ref.watch(allUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _showLogoutDialog(context, ref),
          ),
        ],
      ),
      body: allUsersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (users) {
          // Filter hanya user biasa (bukan admin)
          final regularUsers = users.where((u) => u.role != 'admin').toList();

          if (regularUsers.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(allUsersProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: regularUsers.length + 1, // +1 untuk header
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildHeader(regularUsers.length);
                }
                return _UserCard(user: regularUsers[index - 1]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Belum ada user terdaftar',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'User yang mendaftar akan muncul di sini',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(int userCount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daftar User Terdaftar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$userCount user terdaftar',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

/// Widget card untuk setiap user
class _UserCard extends ConsumerStatefulWidget {
  final User user;

  const _UserCard({required this.user});

  @override
  ConsumerState<_UserCard> createState() => _UserCardState();
}

class _UserCardState extends ConsumerState<_UserCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // User Info Header
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    backgroundColor: Colors.indigo.withAlpha(30),
                    radius: 24,
                    child: Text(
                      widget.user.name.isNotEmpty 
                          ? widget.user.name[0].toUpperCase() 
                          : '?',
                      style: const TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // User Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '@${widget.user.username}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Expand Icon
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),

          // Expanded Screening Details
          if (_isExpanded) _buildScreeningDetails(),
        ],
      ),
    );
  }

  Widget _buildScreeningDetails() {
    final screeningAsync = ref.watch(userScreeningRecordsProvider(widget.user.id));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: screeningAsync.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (e, st) => Text('Error: $e'),
        data: (records) {
          if (records.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange[700]),
                  const SizedBox(width: 8),
                  const Text('Belum melakukan screening'),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Total Screening', '${records.length}'),
                    _buildStatItem('Score Terakhir', '${records.first.score}'),
                    _buildStatItem('Level', records.first.riskLevel),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Recent Screenings
              const Text(
                'Riwayat Screening:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ...records.take(5).map((record) => _buildScreeningItem(record)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildScreeningItem(ScreeningRecord record) {
    Color riskColor;
    switch (record.riskLevel.toLowerCase()) {
      case 'rendah':
        riskColor = Colors.green;
        break;
      case 'sedang':
        riskColor = Colors.orange;
        break;
      case 'tinggi':
        riskColor = Colors.red;
        break;
      default:
        riskColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withAlpha(50)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: riskColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(record.timestamp),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  'Score: ${record.score} • ${record.riskLevel}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Hari ini, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Kemarin, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
