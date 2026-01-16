// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/auth_provider.dart';

// class ProfilePage extends ConsumerStatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   ConsumerState<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends ConsumerState<ProfilePage> {
//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authNotifierProvider);
//     final user = authState.user;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profil Saya'),
//         backgroundColor: Colors.indigo,
//         foregroundColor: Colors.white,
//         centerTitle: true,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           // Avatar dan Info User
//           Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             elevation: 2,
//             child: Padding(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 children: [
//                   // Avatar
//                   Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.indigo.withAlpha(25),
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.person,
//                       size: 60,
//                       color: Colors.indigo,
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // Nama
//                   Text(
//                     user?.name ?? 'User',
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),

//                   // Username
//                   Text(
//                     '@${user?.username ?? ''}',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   const SizedBox(height: 8),

//                   // Role badge
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 4,
//                     ),
//                     decoration: BoxDecoration(
//                       color: user?.isAdmin == true
//                           ? Colors.amber.withAlpha(50)
//                           : Colors.indigo.withAlpha(25),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       user?.isAdmin == true ? '👑 Admin' : '👤 User',
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                         color: user?.isAdmin == true
//                             ? Colors.amber[800]
//                             : Colors.indigo,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           const SizedBox(height: 24),

//           // Section: Pengaturan Akun
//           const Text(
//             'Pengaturan Akun',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(height: 12),

//           // Ubah Nama
//           Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: ListTile(
//               leading: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.withAlpha(25),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(Icons.edit, color: Colors.blue),
//               ),
//               title: const Text('Ubah Nama'),
//               subtitle: Text(user?.name ?? ''),
//               trailing: const Icon(Icons.chevron_right),
//               onTap: () => _showChangeNameDialog(context),
//             ),
//           ),

//           const SizedBox(height: 8),

//           // Ubah Password
//           Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: ListTile(
//               leading: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.orange.withAlpha(25),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Icon(Icons.lock, color: Colors.orange),
//               ),
//               title: const Text('Ubah Password'),
//               subtitle: const Text('Ganti password akun Anda'),
//               trailing: const Icon(Icons.chevron_right),
//               onTap: () => _showChangePasswordDialog(context),
//             ),
//           ),

//           const SizedBox(height: 24),

//           // Info Section
//           Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             color: Colors.grey[50],
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   Icon(Icons.info_outline, color: Colors.grey[600]),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       'Username tidak dapat diubah setelah registrasi.',
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Dialog untuk mengubah nama
//   void _showChangeNameDialog(BuildContext context) {
//     final authState = ref.read(authNotifierProvider);
//     final nameController = TextEditingController(text: authState.user?.name ?? '');
//     final formKey = GlobalKey<FormState>();
//     bool isLoading = false;

//     showDialog(
//       context: context,
//       builder: (ctx) => StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           title: const Text('Ubah Nama'),
//           content: Form(
//             key: formKey,
//             child: TextFormField(
//               controller: nameController,
//               autofocus: true,
//               textCapitalization: TextCapitalization.words,
//               decoration: InputDecoration(
//                 labelText: 'Nama Baru',
//                 hintText: 'Masukkan nama baru',
//                 prefixIcon: const Icon(Icons.person_outline),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               validator: (value) {
//                 if (value == null || value.trim().isEmpty) {
//                   return 'Nama tidak boleh kosong';
//                 }
//                 if (value.trim().length < 2) {
//                   return 'Nama minimal 2 karakter';
//                 }
//                 return null;
//               },
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: isLoading ? null : () => Navigator.pop(ctx),
//               child: const Text('Batal'),
//             ),
//             FilledButton(
//               onPressed: isLoading
//                   ? null
//                   : () async {
//                       if (!formKey.currentState!.validate()) return;

//                       setState(() => isLoading = true);

//                       final result = await ref
//                           .read(authNotifierProvider.notifier)
//                           .updateName(nameController.text.trim());

//                       setState(() => isLoading = false);

//                       if (context.mounted) {
//                         Navigator.pop(ctx);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(result.message),
//                             backgroundColor:
//                                 result.success ? Colors.green : Colors.red,
//                           ),
//                         );
//                       }
//                     },
//               child: isLoading
//                   ? const SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: Colors.white,
//                       ),
//                     )
//                   : const Text('Simpan'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Dialog untuk mengubah password
//   void _showChangePasswordDialog(BuildContext context) {
//     final currentPasswordController = TextEditingController();
//     final newPasswordController = TextEditingController();
//     final confirmPasswordController = TextEditingController();
//     final formKey = GlobalKey<FormState>();
//     bool isLoading = false;
//     bool obscureCurrent = true;
//     bool obscureNew = true;
//     bool obscureConfirm = true;

//     showDialog(
//       context: context,
//       builder: (ctx) => StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           title: const Text('Ubah Password'),
//           content: Form(
//             key: formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Password Saat Ini
//                   TextFormField(
//                     controller: currentPasswordController,
//                     obscureText: obscureCurrent,
//                     decoration: InputDecoration(
//                       labelText: 'Password Saat Ini',
//                       prefixIcon: const Icon(Icons.lock_outline),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           obscureCurrent
//                               ? Icons.visibility_off
//                               : Icons.visibility,
//                         ),
//                         onPressed: () =>
//                             setState(() => obscureCurrent = !obscureCurrent),
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Masukkan password saat ini';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),

//                   // Password Baru
//                   TextFormField(
//                     controller: newPasswordController,
//                     obscureText: obscureNew,
//                     decoration: InputDecoration(
//                       labelText: 'Password Baru',
//                       prefixIcon: const Icon(Icons.lock),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           obscureNew ? Icons.visibility_off : Icons.visibility,
//                         ),
//                         onPressed: () =>
//                             setState(() => obscureNew = !obscureNew),
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Masukkan password baru';
//                       }
//                       if (value.length < 6) {
//                         return 'Password minimal 6 karakter';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),

//                   // Konfirmasi Password Baru
//                   TextFormField(
//                     controller: confirmPasswordController,
//                     obscureText: obscureConfirm,
//                     decoration: InputDecoration(
//                       labelText: 'Konfirmasi Password Baru',
//                       prefixIcon: const Icon(Icons.lock_clock),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           obscureConfirm
//                               ? Icons.visibility_off
//                               : Icons.visibility,
//                         ),
//                         onPressed: () =>
//                             setState(() => obscureConfirm = !obscureConfirm),
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Konfirmasi password baru';
//                       }
//                       if (value != newPasswordController.text) {
//                         return 'Password tidak cocok';
//                       }
//                       return null;
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: isLoading ? null : () => Navigator.pop(ctx),
//               child: const Text('Batal'),
//             ),
//             FilledButton(
//               onPressed: isLoading
//                   ? null
//                   : () async {
//                       if (!formKey.currentState!.validate()) return;

//                       setState(() => isLoading = true);

//                       final result = await ref
//                           .read(authNotifierProvider.notifier)
//                           .updatePassword(
//                             currentPassword: currentPasswordController.text,
//                             newPassword: newPasswordController.text,
//                           );

//                       setState(() => isLoading = false);

//                       if (context.mounted) {
//                         Navigator.pop(ctx);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(result.message),
//                             backgroundColor:
//                                 result.success ? Colors.green : Colors.red,
//                           ),
//                         );
//                       }
//                     },
//               child: isLoading
//                   ? const SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: Colors.white,
//                       ),
//                     )
//                   : const Text('Simpan'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
