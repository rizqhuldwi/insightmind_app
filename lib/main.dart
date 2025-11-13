import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';// Import Hive [cite: 79]
import 'package:pam_teori/src/app.dart';
import 'features/insightmind/data/local/screening_record.dart';// Import Model Hive (adapter) [cite: 78]

void main() async { // Tambahkan 'async' [cite: 79]
  WidgetsFlutterBinding.ensureInitialized();

// WEEK6: Inisialisasi Hive untuk Flutter (buat direktori penyimpanan) [cite: 77]
  await Hive.initFlutter();// Aktifkan Hive saat aplikasi boot [cite: 61]
  
// WEEK6: Registrasi adapter agar Hive tahu cara serialisasi ScreeningRecord [cite: 78]
  Hive.registerAdapter(ScreeningRecordAdapter());// Adapter wajib didaftarkan [cite: 78]

// WEEK6: Buka "box" (database kecil) tempat menyimpan record screening [cite: 67]
  await Hive.openBox<ScreeningRecord>('screening_records'); 

// Riverpod root scope tetap sama seperti M2-M [cite: 327]
  runApp(const ProviderScope(child: InsightMindApp()));
}