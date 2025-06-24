// lib/services/news_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vartaa/constants/api_constants.dart';
import 'package:vartaa/models/news_article.dart';
import 'package:vartaa/services/auth_service.dart'; // Import AuthService

class NewsApiService {
  final String _baseUrl = ApiConstant.baseUrl;
  final AuthService _authService = AuthService(); // Inisialisasi AuthService

  // Helper untuk mendapatkan headers dengan token dari AuthService
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _authService.getAuthToken();
    if (token == null) {
      throw Exception('Authentication token not found. Please login.');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<NewsArticle>> fetchNews({int page = 1, int limit = 10}) async {
    final Map<String, String> queryParameters = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    final uri = Uri.parse(
      _baseUrl + ApiConstant.newsPublicEndpoint,
    ).replace(queryParameters: queryParameters);

    print('Fetching news from URI: $uri');

    try {
      final response = await http.get(
        uri,
        headers: await _getAuthHeaders(), // Gunakan headers dengan token
      );

      print('API Response Status Code: ${response.statusCode}');
      print('API Raw Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> fullResponse = json.decode(response.body);
        final Map<String, dynamic>? responseBody = fullResponse['body'];

        if (responseBody == null) {
          throw Exception(
            'Failed to parse news data: "body" key not found or is null in response.',
          );
        }

        final List<dynamic>? articlesJson = responseBody['data'];

        if (articlesJson != null) {
          final List<NewsArticle> results =
              articlesJson
                  .map((jsonItem) {
                    if (jsonItem is Map<String, dynamic>) {
                      return NewsArticle.fromJson(jsonItem);
                    } else {
                      print(
                        'Warning: Found non-Map item in articles list. Skipping.',
                      );
                      return null;
                    }
                  })
                  .where((article) => article != null)
                  .cast<NewsArticle>()
                  .where(
                    (article) =>
                        article.featuredImageUrl != null &&
                        article.featuredImageUrl!.isNotEmpty,
                  )
                  .toList();

          print(
            'Data dari API berita berhasil dimuat: ${results.length} artikel',
          );
          return results;
        } else {
          throw Exception(
            'Failed to parse news data: "data" key not found or is null inside "body".',
          );
        }
      } else {
        String errorMessage =
            'Failed to load news. Status code: ${response.statusCode}.';
        try {
          final Map<String, dynamic> errorData = json.decode(response.body);
          if (errorData.containsKey('message')) {
            errorMessage += ' Message: ${errorData['message']}';
          }
        } catch (e) {
          errorMessage += ' Response body: ${response.body}';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Error in NewsApiService (network/parsing issue): $e');
      rethrow;
    }
  }

  Future<NewsArticle> getNewsBySlug(String slug) async {
    final uri = Uri.parse('$_baseUrl${ApiConstant.newsPublicEndpoint}/$slug');
    print('Fetching news by slug from URI: $uri');

    try {
      final response = await http.get(uri, headers: await _getAuthHeaders());

      print('API Response Status Code: ${response.statusCode}');
      print('API Raw Response Body (News Detail): ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> fullResponse = json.decode(response.body);
        final Map<String, dynamic>? responseBody = fullResponse['body'];

        if (responseBody == null) {
          throw Exception(
            'Failed to parse news detail: "body" key not found or is null in response.',
          );
        }

        final Map<String, dynamic>? articleJson = responseBody['data'];

        if (articleJson != null) {
          return NewsArticle.fromJson(articleJson);
        } else {
          throw Exception(
            'Failed to parse news detail: "data" key not found or is null inside "body".',
          );
        }
      } else if (response.statusCode == 404) {
        throw Exception('News with slug "$slug" not found.');
      } else {
        String errorMessage =
            'Failed to load news detail. Status code: ${response.statusCode}.';
        try {
          final Map<String, dynamic> errorData = json.decode(response.body);
          if (errorData.containsKey('message')) {
            errorMessage += ' Message: ${errorData['message']}';
          }
        } catch (e) {
          errorMessage += ' Response body: ${response.body}';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      print(
        'Error in NewsApiService (network/parsing issue for news detail): $e',
      );
      rethrow;
    }
  }
}
