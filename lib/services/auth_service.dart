// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vartaa/constants/api_constants.dart';
import 'package:vartaa/models/author.dart';

class AuthService {
  final String _baseUrl = ApiConstant.baseUrl;
  static const String _authTokenKey = 'auth_token';
  static const String _authorDataKey = 'author_data';

  // Metode untuk menyimpan token dan data Author
  Future<void> saveAuthData({
    required String token,
    required Author author,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
    await prefs.setString(_authorDataKey, json.encode(author.toJson()));
    print('Auth token saved: $token');
    print('Author data saved: ${author.toJson()}');
  }

  // Metode untuk mendapatkan token dari SharedPreferences
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  // Metode untuk mendapatkan data Author dari SharedPreferences
  Future<Author?> getAuthenticatedAuthor() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_authTokenKey);
    final authorDataJson = prefs.getString(_authorDataKey);

    if (token != null && authorDataJson != null) {
      try {
        final Map<String, dynamic> authorMap = json.decode(authorDataJson);
        return Author.fromJson(authorMap);
      } catch (e) {
        print('Error decoding author data from SharedPreferences: $e');
        await clearAuthData(); // Hapus data jika corrupt
        return null;
      }
    }
    return null;
  }

  // Metode untuk menghapus token dan data Author
  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
    await prefs.remove(_authorDataKey);
    print('Auth token and author data cleared.');
  }

  // Metode login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse(_baseUrl + ApiConstant.loginEndpoint);
    print('Logging in to URI: $uri');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    print('Login API Response Status Code: ${response.statusCode}');
    print('Login API Raw Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> fullResponse = json.decode(response.body);

      // Ambil objek 'body' terlebih dahulu
      final Map<String, dynamic>? responseBody = fullResponse['body'];

      if (responseBody == null) {
        throw Exception(
          'Invalid login response: "body" key not found in response.',
        );
      }

      // Token dan data author keduanya berada di dalam responseBody['data']
      // dan objek data ini memiliki kunci 'token' dan 'author'
      final Map<String, dynamic>? dataInsideBody = responseBody['data'];

      if (dataInsideBody == null) {
        throw Exception(
          'Invalid login response: "data" key not found inside "body".',
        );
      }

      // Ambil token dari dalam 'data'
      final String? token = dataInsideBody['token'];

      // Ambil data author dari dalam 'data'
      final Map<String, dynamic>? authorDataFromResponse =
          dataInsideBody['author'];

      print(
        'check full response token: $token, authorDataFromResponse: $authorDataFromResponse',
      ); // Baris print untuk debugging

      if (token != null && authorDataFromResponse != null) {
        final author = Author.fromJson(authorDataFromResponse);
        await saveAuthData(token: token, author: author);
        return fullResponse; // Kembalikan full response jika ada informasi lain yang dibutuhkan
      } else {
        throw Exception(
          'Invalid login response: Missing token or author data structure inside "data" object.',
        );
      }
    } else {
      String errorMessage =
          'Failed to login. Status code: ${response.statusCode}.';
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
  }

  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getAuthToken();
    if (token == null) {
      throw Exception(
        'Authentication token not found. Please login to get a token.',
      );
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Author> fetchAuthorProfile() async {
    final uri = Uri.parse(_baseUrl + ApiConstant.profileMeEndpoint);
    print('Fetching author profile from URI: $uri');

    final response = await http.get(uri, headers: await getAuthHeaders());

    print('Author Profile API Response Status Code: ${response.statusCode}');
    print('Author Profile API Raw Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> fullResponse = json.decode(response.body);
      final Map<String, dynamic>? responseBody = fullResponse['body'];

      if (responseBody == null) {
        throw Exception(
          'Failed to parse author profile: "body" key not found in response.',
        );
      }
      final Map<String, dynamic>? authorData = responseBody['data'];

      if (authorData != null) {
        return Author.fromJson(authorData);
      } else {
        throw Exception(
          'Failed to parse author profile: "data" key not found or is null inside "body".',
        );
      }
    } else if (response.statusCode == 401) {
      await clearAuthData();
      throw Exception('Unauthorized. Please login again.');
    } else {
      String errorMessage =
          'Failed to fetch author profile. Status code: ${response.statusCode}.';
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
  }
}
