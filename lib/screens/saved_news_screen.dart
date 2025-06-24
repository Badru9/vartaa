// lib/screens/saved_news_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vartaa/controllers/bookmark_controller.dart';
import 'package:vartaa/screens/home_screen.dart';
import 'package:vartaa/screens/news_detail_screen.dart';

class SavedNewsScreen extends StatefulWidget {
  const SavedNewsScreen({super.key});

  @override
  State<SavedNewsScreen> createState() => _SavedNewsScreenState();
}

class _SavedNewsScreenState extends State<SavedNewsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Memuat ulang daftar bookmark saat halaman Saved dibuka
      Provider.of<BookmarkController>(
        context,
        listen: false,
      ).refreshBookmarks();
    });
  }

  Future<void> _handleRefresh() async {
    await Provider.of<BookmarkController>(
      context,
      listen: false,
    ).refreshBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Berita Tersimpan'),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Consumer<BookmarkController>(
        builder: (context, bookmarkController, child) {
          if (bookmarkController.status == BookmarkStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (bookmarkController.status == BookmarkStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Gagal memuat bookmark: ${bookmarkController.errorMessage}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _handleRefresh,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          } else if (bookmarkController.bookmarkedArticles.isEmpty) {
            return const Center(
              child: Text(
                'Anda belum menyimpan berita apa pun.\nTambahkan bookmark dari halaman detail berita!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _handleRefresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: bookmarkController.bookmarkedArticles.length,
              itemBuilder: (context, index) {
                final article = bookmarkController.bookmarkedArticles[index];
                return NewsCard(newsItem: article); // Re-use NewsCard
              },
            ),
          );
        },
      ),
    );
  }
}
