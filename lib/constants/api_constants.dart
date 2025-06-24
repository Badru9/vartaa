class ApiConstant {
  static const String baseUrl = 'http://45.149.187.204:3000';

  // --- API Endpoints ---
  static const String loginEndpoint = '/api/auth/login';
  static const String profileMeEndpoint = '/api/auth/me';

  // Endpoints untuk berita publik (jika ada, sesuaikan)
  static const String newsPublicEndpoint = '/api/news';

  // Endpoints untuk Author News Management
  static const String authorNewsBaseEndpoint = '/api/author/news';
  static const Map<String, String> defaultParams = {'limit': '20'};
}
