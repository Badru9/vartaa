// lib/controllers/news_controller.dart
import 'package:flutter/material.dart';
import 'package:vartaa/models/news_article.dart';
import 'package:vartaa/services/news_api_service.dart';

enum NewsStatus { initial, loading, loaded, error }

enum NewsDetailStatus { initial, loading, loaded, error }

class NewsController extends ChangeNotifier {
  final NewsApiService _apiService = NewsApiService();

  List<NewsArticle> _headlines = [];
  List<NewsArticle> _generalNews = [];
  NewsStatus _headlinesStatus = NewsStatus.initial;
  NewsStatus _generalNewsStatus = NewsStatus.initial;
  String _errorMessage = '';

  NewsArticle? _currentNewsDetail;
  NewsDetailStatus _newsDetailStatus = NewsDetailStatus.initial;
  String _newsDetailErrorMessage = '';

  List<NewsArticle> get headlines => _headlines;
  List<NewsArticle> get generalNews => _generalNews;
  NewsStatus get headlinesStatus => _headlinesStatus;
  NewsStatus get generalNewsStatus => _generalNewsStatus;
  String get errorMessage => _errorMessage;

  NewsArticle? get currentNewsDetail => _currentNewsDetail;
  NewsDetailStatus get newsDetailStatus => _newsDetailStatus;
  String get newsDetailErrorMessage => _newsDetailErrorMessage;

  Future<void> fetchHeadlines({int limit = 5}) async {
    _headlinesStatus = NewsStatus.loading;
    _errorMessage = '';
    notifyListeners();
    try {
      _headlines = await _apiService.fetchNews(limit: limit, page: 1);
      _headlinesStatus = NewsStatus.loaded;
    } catch (e) {
      _errorMessage = 'Failed to load headlines: ${e.toString()}';
      _headlinesStatus = NewsStatus.error;
      debugPrint('Error fetching headlines: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchGeneralNews({int page = 1, int limit = 10}) async {
    _generalNewsStatus = NewsStatus.loading;
    _errorMessage = '';
    notifyListeners();
    try {
      _generalNews = await _apiService.fetchNews(page: page, limit: limit);
      _generalNewsStatus = NewsStatus.loaded;
    } catch (e) {
      _errorMessage = 'Failed to load general news: ${e.toString()}';
      _generalNewsStatus = NewsStatus.error;
      debugPrint('Error fetching general news: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchNewsDetailBySlug(String slug) async {
    _newsDetailStatus = NewsDetailStatus.loading;
    _newsDetailErrorMessage = '';
    _currentNewsDetail = null; // Clear previous detail
    notifyListeners();
    try {
      _currentNewsDetail = await _apiService.getNewsBySlug(slug);
      _newsDetailStatus = NewsDetailStatus.loaded;
    } catch (e) {
      _newsDetailErrorMessage =
          'Failed to load news detail: ${e.toString().replaceFirst('Exception: ', '')}';
      _newsDetailStatus = NewsDetailStatus.error;
      debugPrint('Error fetching news detail for slug "$slug": $e');
    } finally {
      notifyListeners();
    }
  }
}
