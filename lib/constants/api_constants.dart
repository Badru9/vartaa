class ApiConstant {
  static const String baseUrl = 'https://newsapi.org/v2';
  static const String apiKey = 'b56303cf23144f7db2a1e0c725900076';

  static const String everythingEndpoint = '/everything';
  static const String topHeadlineCountryEndpoint = '/top-headlines';
  static const String sourceEndpoint = '/top-headlines/sources';

  static const Map<String, String> defaultParams = {
    'country': 'us',
    'pageSize': '20',
  };

  static Map<String, String> get headers {
    return {'X-Api-Key': apiKey, 'Content-Type': 'application/json'};
  }

  static Map<String, String> get authHeader {
    return {'Authorization': apiKey, 'Content-Type': 'application/json'};
  }
}
