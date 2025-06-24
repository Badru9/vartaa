import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vartaa/models/news_article.dart';
import 'package:vartaa/services/news_api_service.dart'; // Untuk mengambil detail berita

enum BookmarkStatus { initial, loading, loaded, error }

class BookmarkController extends ChangeNotifier {
  static const String _bookmarkKey = 'bookmarked_news_slugs';

  final NewsApiService _newsApiService = NewsApiService();

  Set<String> _bookmarkedSlugs = {}; // Hanya menyimpan slug
  List<NewsArticle> _bookmarkedArticles = []; // Menyimpan objek berita lengkap
  BookmarkStatus _status = BookmarkStatus.initial;
  String _errorMessage = '';

  Set<String> get bookmarkedSlugs => _bookmarkedSlugs;
  List<NewsArticle> get bookmarkedArticles => _bookmarkedArticles;
  BookmarkStatus get status => _status;
  String get errorMessage => _errorMessage;

  BookmarkController() {
    _loadBookmarkedSlugs(); // Muat slugs saat controller diinisialisasi
  }

  Future<void> _loadBookmarkedSlugs() async {
    _status = BookmarkStatus.loading;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      _bookmarkedSlugs = prefs.getStringList(_bookmarkKey)?.toSet() ?? {};
      await _fetchBookmarkedArticles(); // Setelah slugs dimuat, fetch detailnya
      _status = BookmarkStatus.loaded;
    } catch (e) {
      _errorMessage = 'Failed to load bookmarks: ${e.toString()}';
      _status = BookmarkStatus.error;
      debugPrint('Error loading bookmarked slugs: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> _saveBookmarkedSlugs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_bookmarkKey, _bookmarkedSlugs.toList());
  }

  // Fetch detailed articles for saved slugs
  Future<void> _fetchBookmarkedArticles() async {
    _status = BookmarkStatus.loading;
    _errorMessage = ''; // Clear previous errors
    notifyListeners();
    if (_bookmarkedSlugs.isEmpty) {
      _bookmarkedArticles = [];
      _status = BookmarkStatus.loaded;
      notifyListeners();
      return;
    }

    List<NewsArticle> fetchedArticles = [];
    List<String> validSlugs = []; // Untuk menyimpan slug yang berhasil di-fetch

    for (String slug in _bookmarkedSlugs) {
      try {
        final article = await _newsApiService.getNewsBySlug(slug);
        fetchedArticles.add(article);
        validSlugs.add(slug); // Hanya tambahkan ke validSlugs jika berhasil
      } catch (e) {
        debugPrint('Failed to fetch bookmarked article for slug $slug: $e');
        // Jika gagal fetch (misal artikel sudah dihapus), kita tidak akan menyimpannya kembali
      }
    }
    _bookmarkedArticles = fetchedArticles;
    _bookmarkedSlugs = validSlugs.toSet(); // Perbarui slugs yang tersimpan
    await _saveBookmarkedSlugs(); // Simpan slugs yang sudah divalidasi
    _status = BookmarkStatus.loaded;
    notifyListeners();
  }

  bool isBookmarked(String slug) {
    return _bookmarkedSlugs.contains(slug);
  }

  Future<void> toggleBookmark(NewsArticle article) async {
    if (article.slug == null || article.slug!.isEmpty) {
      _errorMessage = 'Cannot bookmark article without a slug.';
      notifyListeners();
      return;
    }

    final String slug = article.slug!;

    if (_bookmarkedSlugs.contains(slug)) {
      _bookmarkedSlugs.remove(slug);
      _bookmarkedArticles.removeWhere((a) => a.slug == slug);
      print('Removed bookmark: $slug');
    } else {
      _bookmarkedSlugs.add(slug);
      _bookmarkedArticles.add(article); // Tambahkan langsung artikel lengkap
      print('Added bookmark: $slug');
    }
    await _saveBookmarkedSlugs();
    notifyListeners();
  }

  // Muat ulang bookmark (misal setelah pull-to-refresh)
  Future<void> refreshBookmarks() async {
    await _loadBookmarkedSlugs(); // Ini akan memicu _fetchBookmarkedArticles
  }
}
