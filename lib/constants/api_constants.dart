// const bool development = false;

class ApiConstant {
  static const String baseUrl = 'http://45.149.187.204:3000';
  static const String apiKey =
      'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIyMTQ0MmEyNy03NzRhLTQwMmItOTliYi00ZmY3OGE0MTllOTciLCJlbWFpbCI6Im5ld3NAaXRnLmFjLmlkIiwiaWF0IjoxNzUwMzMwMDMyLCJleHAiOjE3NTA0MTY0MzJ9.BwAOhKQcutHPuPy5XHBsVawwCHVntjvskVJ7HV6QFs0';

  static const String loginEndpoint = '/api/auth/login';

  static const String everythingEndpoint = '/everything';
  static const String topHeadlineCountryEndpoint = '/top-headlines';
  static const String sourceEndpoint = '/top-headlines/sources';

  static const Map<String, String> defaultParams = {
    'country': 'us',
    'pageSize': '20',
  };

  static Map<String, String> get headers {
    return {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };
  }

  static Map<String, String> get authHeader {
    return {'Authorization': apiKey, 'Content-Type': 'application/json'};
  }
}
