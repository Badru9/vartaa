import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:newshive/constants/api_constants.dart';
import 'package:newshive/models/news.dart';
import 'package:http/http.dart';

class NewsController with ChangeNotifier {
  NewsModel? _newsModel;
  late bool _isLoading = false;
  String? _errorMessage;

  NewsModel? get newsModel => _newsModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchEverything({required String query}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final uri = Uri.parse(
        '${ApiConstant.baseUrl}${ApiConstant.everythingEndpoint}?q=$query&pageSize=${ApiConstant.defaultParams['pageSize']}',
      );

      final Response response = await http.get(
        uri,
        headers: ApiConstant.headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        _newsModel = NewsModel.fromJson(data);
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to load news:${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error fetching news: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
