import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'package:vartaa/constants/api_constants.dart';
import 'package:vartaa/models/news.dart';

class NewsController with ChangeNotifier {
  NewsModel? _newsModel;
  bool _isLoading = false;
  String? _errorMessage;

  NewsModel? get newsModel => _newsModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchEverything({required String query}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final uri = Uri.parse(
        '${ApiConstant.baseUrl}${ApiConstant.everythingEndpoint}?q=$query&pageSize=${ApiConstant.defaultParams['pageSize']}',
      );

      print('Mengambil berita dari URL: $uri');

      final Response response = await http.get(
        uri,
        headers: ApiConstant.headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print('Data respons berhasil diterima.');

        _newsModel = NewsModel.fromJson(data);
        _errorMessage = null;
      } else {
        _errorMessage =
            'Gagal memuat berita: ${response.statusCode}. Respons: ${response.body}';
        _newsModel = null;
      }
    } catch (e) {
      _errorMessage =
          'Terjadi kesalahan saat mengambil berita: ${e.toString()}';
      _newsModel = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
