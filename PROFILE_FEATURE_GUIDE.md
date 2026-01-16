# Fitur Profil di Halaman Utama - Dokumentasi

## Ringkasan
Telah berhasil mengimplementasikan fitur profil pengguna di halaman utama (home page) dengan kemampuan untuk menyimpan dan mengelola email dan password login.

## Komponen yang Ditambahkan

### 1. Profile Card Widget
**File:** `lib/features/insightmind/presentation/widgets/profile_card_widget.dart`

Widget yang menampilkan kartu profil pengguna dengan fitur:
- ✅ Menampilkan email pengguna
- ✅ Menampilkan password dengan toggle visibility
- ✅ Menampilkan nomor telepon (opsional)
- ✅ Mode edit untuk mengubah data profil
- ✅ Tombol simpan untuk menyimpan perubahan
- ✅ Tampilan responsif untuk dark mode dan light mode
- ✅ Pesan sukses dan error
- ✅ Loading indicator saat menyimpan

### 2. Integrasi di Home Page
**File:** `lib/features/insightmind/presentation/pages/home_page.dart`

- ✅ Menambahkan import ProfileCardWidget
- ✅ Menampilkan ProfileCardWidget di bawah Quick Actions section

### 3. Update Auth Provider
**File:** `lib/features/insightmind/presentation/providers/auth_provider.dart`

Menambahkan fitur otomatis pembuatan profil saat login:
- ✅ Saat pengguna login, profile otomatis dibuat dengan email dan password
- ✅ Saat register, profile otomatis dibuat dengan informasi yang sama
- ✅ Menambahkan `authStateProvider` untuk akses state autentikasi
- ✅ Error handling untuk proses pembuatan profile

### 4. Hive Setup
**File:** `lib/main.dart`

- ✅ Menambahkan import Profile model
- ✅ Registrasi ProfileAdapter untuk Hive
- ✅ Buka box 'profiles' untuk penyimpanan data

### 5. Generate Adapter
**File:** `lib/features/insightmind/data/local/profile.g.dart`

- ✅ Membuat TypeAdapter untuk Profile model (ProfileAdapter)
- ✅ Implementasi read/write untuk serialisasi Hive

## Flow Kerja

```
1. User Login/Register
   ↓
2. AuthNotifier.login() atau .register()
   ↓
3. Otomatis membuat Profile dengan email & password
   ↓
4. User masuk ke Home Page
   ↓
5. ProfileCardWidget ditampilkan dengan data tersimpan
   ↓
6. User bisa klik Edit untuk mengubah email/password/phone
   ↓
7. Data disimpan ke Hive local database
```

## Fitur Utama

### Penyimpanan Data
- Email login disimpan di Profile
- Password disimpan dengan hashing (simple base64 encoding)
- Nomor telepon (opsional)
- Timestamp update

### User Interface
- Card design dengan gradient background
- Dark mode support
- Password field dengan visibility toggle
- Loading state dan feedback message
- Edit/Cancel/Save buttons

### Data Persistence
- Semua data disimpan di Hive local database
- Otomatis dibuat saat first login/register
- Bisa diupdate kapan saja dari home page

## Testing

Untuk menguji fitur ini:

1. Login/Register dengan username dan password
2. Lihat ProfileCardWidget di halaman utama
3. Klik tombol Edit (pensil icon)
4. Ubah email, password, atau nomor telepon
5. Klik Simpan
6. Lihat pesan sukses
7. Data sudah tersimpan dan persisten

## Catatan Keamanan

⚠️ Password disimpan dengan simple base64 encoding. Untuk production:
- Gunakan bcrypt atau Argon2 untuk hashing
- Implementasikan encryption untuk data sensitif
- Jangan simpan password plaintext

## File yang Dimodifikasi

1. `lib/features/insightmind/presentation/widgets/profile_card_widget.dart` - Created
2. `lib/features/insightmind/presentation/pages/home_page.dart` - Modified
3. `lib/features/insightmind/presentation/providers/auth_provider.dart` - Modified
4. `lib/features/insightmind/data/local/profile.g.dart` - Created
5. `lib/main.dart` - Modified
6. `lib/features/insightmind/presentation/pages/profile_page.dart` - Fixed

## Dependency
- flutter_riverpod (sudah ada)
- hive_flutter (sudah ada)
