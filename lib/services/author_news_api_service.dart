// lib/services/author_news_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vartaa/constants/api_constants.dart';
import 'package:vartaa/models/news_article.dart';
import 'package:vartaa/services/auth_service.dart';

class AuthorNewsApiService {
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
      'Authorization': 'Bearer $token', // Format Bearer Token
    };
  }

  // GET /api/author/news/{id} - Get news by ID
  Future<NewsArticle> getNewsById(String newsId) async {
    final uri = Uri.parse(
      '$_baseUrl${ApiConstant.authorNewsBaseEndpoint}/$newsId',
    );
    print('Fetching news by ID from URI: $uri');

    final response = await http.get(uri, headers: await _getAuthHeaders());

    print('API Response Status Code: ${response.statusCode}');
    print('API Raw Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> fullResponse = json.decode(response.body);
      final Map<String, dynamic>? responseBody = fullResponse['body'];

      if (responseBody != null &&
          responseBody['data'] is Map<String, dynamic>) {
        return NewsArticle.fromJson(
          responseBody['data'] as Map<String, dynamic>,
        );
      } else {
        throw Exception(
          'Failed to parse news detail: "data" not found or invalid type inside "body".',
        );
      }
    } else {
      throw Exception(
        'Failed to load news detail. Status code: ${response.statusCode}. Body: ${response.body}',
      );
    }
  }

  // GET /api/author/news - Get list of author's news
  Future<List<NewsArticle>> getAuthorNewsList({
    int page = 1,
    int limit = 10,
  }) async {
    final uri = Uri.parse(
      _baseUrl + ApiConstant.authorNewsBaseEndpoint,
    ).replace(
      queryParameters: {'page': page.toString(), 'limit': limit.toString()},
    );
    print('Fetching author news list from URI: $uri');

    final response = await http.get(uri, headers: await _getAuthHeaders());

    print('API Response Status Code: ${response.statusCode}');
    print('API Raw Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> fullResponse = json.decode(response.body);
      final Map<String, dynamic>? responseBody = fullResponse['body'];

      if (responseBody == null) {
        throw Exception(
          'Failed to parse author news list: "body" key not found in response.',
        );
      }

      final List<dynamic>? articlesJson = responseBody['data'];

      if (articlesJson != null) {
        return articlesJson
            .map(
              (jsonItem) =>
                  NewsArticle.fromJson(jsonItem as Map<String, dynamic>),
            )
            .where(
              (article) =>
                  article.featuredImageUrl != null &&
                  article.featuredImageUrl!.isNotEmpty,
            )
            .toList();
      } else {
        throw Exception(
          'Failed to parse author news list: "data" key not found or is null inside "body".',
        );
      }
    } else {
      throw Exception(
        'Failed to load author news list. Status code: ${response.statusCode}. Body: ${response.body}',
      );
    }
  }

  // POST /api/author/news - Create new news article
  Future<NewsArticle> createNews({
    required String title,
    required String summary,
    required String content,
    String? featuredImageUrl,
    required String category,
    required List<String> tags,
    required bool isPublished,
  }) async {
    final uri = Uri.parse(_baseUrl + ApiConstant.authorNewsBaseEndpoint);
    print('Creating news on URI: $uri');

    final Map<String, dynamic> body = {
      'title': title,
      'summary': summary,
      'content': content,
      'featured_image_url': featuredImageUrl,
      'category': category,
      'tags': tags,
      'isPublished': isPublished,
    };
    print('Request Body: ${json.encode(body)}');

    final response = await http.post(
      uri,
      headers: await _getAuthHeaders(),
      body: json.encode(body),
    );

    print('API Response Status Code: ${response.statusCode}');
    print('API Raw Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> fullResponse = json.decode(response.body);
      final Map<String, dynamic>? responseBody = fullResponse['body'];
      if (responseBody != null &&
          responseBody['data'] is Map<String, dynamic>) {
        return NewsArticle.fromJson(
          responseBody['data'] as Map<String, dynamic>,
        );
      } else {
        throw Exception(
          'Failed to parse created news data: "data" not found or invalid type inside "body".',
        );
      }
    } else {
      throw Exception(
        'Failed to create news. Status code: ${response.statusCode}. Body: ${response.body}',
      );
    }
  }

  // PUT /api/author/news/{id} - Update news article
  Future<NewsArticle> updateNews(
    String newsId, {
    required String title,
    required String summary,
    required String content,
    String? featuredImageUrl,
    required String category,
    required List<String> tags,
    required bool isPublished,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl${ApiConstant.authorNewsBaseEndpoint}/$newsId',
    );
    print('Updating news on URI: $uri');

    final Map<String, dynamic> body = {
      'title': title,
      'summary': summary,
      'content': content,
      'featured_image_url': featuredImageUrl,
      'category': category,
      'tags': tags,
      'isPublished': isPublished,
    };
    print('Request Body: ${json.encode(body)}');

    final response = await http.put(
      uri,
      headers: await _getAuthHeaders(),
      body: json.encode(body),
    );

    print('API Response Status Code: ${response.statusCode}');
    print('API Raw Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> fullResponse = json.decode(response.body);
      final Map<String, dynamic>? responseBody = fullResponse['body'];
      if (responseBody != null &&
          responseBody['data'] is Map<String, dynamic>) {
        return NewsArticle.fromJson(
          responseBody['data'] as Map<String, dynamic>,
        );
      } else {
        throw Exception(
          'Failed to parse updated news data: "data" not found or invalid type inside "body".',
        );
      }
    } else {
      throw Exception(
        'Failed to update news. Status code: ${response.statusCode}. Body: ${response.body}',
      );
    }
  }

  // DELETE /api/author/news/{id} - Delete news article
  Future<void> deleteNews(String newsId) async {
    final uri = Uri.parse(
      '$_baseUrl${ApiConstant.authorNewsBaseEndpoint}/$newsId',
    );
    print('Deleting news from URI: $uri');

    final response = await http.delete(uri, headers: await _getAuthHeaders());

    print('API Response Status Code: ${response.statusCode}');
    print('API Raw Response Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to delete news. Status code: ${response.statusCode}. Body: ${response.body}',
      );
    }
  }
}
