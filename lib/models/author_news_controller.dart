// lib/controllers/author_news_controller.dart
import 'package:flutter/material.dart';
import 'package:vartaa/models/news_article.dart';
import 'package:vartaa/services/author_news_api_service.dart';

enum AuthorNewsStatus { initial, loading, loaded, error }

class AuthorNewsController extends ChangeNotifier {
  final AuthorNewsApiService _apiService = AuthorNewsApiService();

  List<NewsArticle> _authorArticles = [];
  AuthorNewsStatus _status = AuthorNewsStatus.initial;
  String _errorMessage = '';

  List<NewsArticle> get authorArticles => _authorArticles;
  AuthorNewsStatus get status => _status;
  String get errorMessage => _errorMessage;

  // Fetch all news articles by the current author
  Future<void> fetchAuthorNews({int page = 1, int limit = 10}) async {
    _status = AuthorNewsStatus.loading;
    _errorMessage = '';
    notifyListeners();
    try {
      _authorArticles = await _apiService.getAuthorNewsList(
        page: page,
        limit: limit,
      );
      _status = AuthorNewsStatus.loaded;
    } catch (e) {
      _errorMessage = 'Failed to load author news: ${e.toString()}';
      _status = AuthorNewsStatus.error;
      debugPrint('Error fetching author news: $e');
    } finally {
      notifyListeners();
    }
  }

  // Create a new news article
  Future<bool> createNews({
    required String title,
    required String summary,
    required String content,
    String? featuredImageUrl,
    required String category,
    required List<String> tags,
    required bool isPublished,
  }) async {
    _status = AuthorNewsStatus.loading;
    _errorMessage = '';
    notifyListeners();
    try {
      final newArticle = await _apiService.createNews(
        title: title,
        summary: summary,
        content: content,
        featuredImageUrl: featuredImageUrl,
        category: category,
        tags: tags,
        isPublished: isPublished,
      );
      _authorArticles.insert(0, newArticle); // Tambahkan ke daftar di awal
      _status = AuthorNewsStatus.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to create news: ${e.toString()}';
      _status = AuthorNewsStatus.error;
      notifyListeners();
      return false;
    }
  }

  // Update an existing news article
  Future<bool> updateNews(
    String newsId, {
    required String title,
    required String summary,
    required String content,
    String? featuredImageUrl,
    required String category,
    required List<String> tags,
    required bool isPublished,
  }) async {
    _status = AuthorNewsStatus.loading;
    _errorMessage = '';
    notifyListeners();
    try {
      final updatedArticle = await _apiService.updateNews(
        newsId,
        title: title,
        summary: summary,
        content: content,
        featuredImageUrl: featuredImageUrl,
        category: category,
        tags: tags,
        isPublished: isPublished,
      );
      // Update article in the list
      final index = _authorArticles.indexWhere(
        (article) => article.id == newsId,
      );
      if (index != -1) {
        _authorArticles[index] = updatedArticle;
      }
      _status = AuthorNewsStatus.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update news: ${e.toString()}';
      _status = AuthorNewsStatus.error;
      notifyListeners();
      return false;
    }
  }

  // Delete a news article
  Future<bool> deleteNews(String newsId) async {
    _status = AuthorNewsStatus.loading;
    _errorMessage = '';
    notifyListeners();
    try {
      await _apiService.deleteNews(newsId);
      _authorArticles.removeWhere(
        (article) => article.id == newsId,
      ); // Hapus dari daftar
      _status = AuthorNewsStatus.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete news: ${e.toString()}';
      _status = AuthorNewsStatus.error;
      notifyListeners();
      return false;
    }
  }

  // Get specific news article by ID (e.g., for editing form pre-fill)
  Future<NewsArticle?> getNewsDetail(String newsId) async {
    _status = AuthorNewsStatus.loading;
    _errorMessage = '';
    notifyListeners();
    try {
      final article = await _apiService.getNewsById(newsId);
      _status = AuthorNewsStatus.loaded;
      notifyListeners();
      return article;
    } catch (e) {
      _errorMessage = 'Failed to fetch news detail: ${e.toString()}';
      _status = AuthorNewsStatus.error;
      notifyListeners();
      return null;
    }
  }
}
