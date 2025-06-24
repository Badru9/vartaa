// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:vartaa/controllers/auth_controller.dart';
import 'package:vartaa/screens/author/author_dashboard_screen.dart'; // Untuk navigasi ke dashboard CRUD

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Pastikan data profil Author dimuat saat halaman Profile dibuka
      Provider.of<AuthController>(context, listen: false).fetchAuthorProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Background cerah
      appBar: AppBar(
        title: const Text('Profil Penulis'),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: PhosphorIcon(PhosphorIcons.signOut()), // Ikon Logout
            onPressed: () {
              Provider.of<AuthController>(context, listen: false).logout();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Consumer<AuthController>(
        builder: (context, authController, child) {
          if (authController.isProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (authController.profileErrorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal memuat profil: ${authController.profileErrorMessage}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        authController.fetchAuthorProfile(); // Coba lagi
                      },
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          } else if (authController.currentAuthor == null) {
            return const Center(
              child: Text(
                'Data profil tidak ditemukan. Silakan login ulang.',
                textAlign: TextAlign.center,
              ),
            );
          }

          final author = authController.currentAuthor!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage:
                            (author.avatarUrl != null &&
                                    author.avatarUrl!.isNotEmpty)
                                ? NetworkImage(author.avatarUrl!)
                                : null,
                        child:
                            (author.avatarUrl == null ||
                                    author.avatarUrl!.isEmpty)
                                ? Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey[600],
                                )
                                : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        author.fullName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        author.email,
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 16),
                      if (author.bio != null && author.bio!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withAlpha(20),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Bio:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                author.bio!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Tombol untuk mengelola berita (CRUD)
                ListTile(
                  leading: PhosphorIcon(PhosphorIcons.articleNyTimes()),
                  title: const Text('Kelola Berita Saya'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AuthorDashboardScreen(),
                      ),
                    );
                  },
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                const SizedBox(height: 16),
                // Contoh lain: Pengaturan Akun
                ListTile(
                  leading: PhosphorIcon(PhosphorIcons.gear()),
                  title: const Text('Pengaturan Akun'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pengaturan Akun - Fitur Belum Tersedia'),
                      ),
                    );
                  },
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
