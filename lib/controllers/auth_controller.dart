import 'package:flutter/material.dart';
import 'package:vartaa/models/author.dart';
import 'package:vartaa/services/auth_service.dart';
import 'package:vartaa/screens/auth/login_screen.dart';
import 'package:vartaa/main.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;
  Author? _currentAuthor;
  bool _isProfileLoading = false;
  String? _profileErrorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;
  Author? get currentAuthor => _currentAuthor;

  bool get isProfileLoading => _isProfileLoading;
  String? get profileErrorMessage => _profileErrorMessage;

  // Inisialisasi: Periksa status autentikasi saat app pertama kali dibuka
  Future<void> checkAuthStatus() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final author =
          await _authService
              .getAuthenticatedAuthor(); // Panggil getAuthenticatedAuthor
      if (author != null) {
        _isAuthenticated = true;
        _currentAuthor = author;
        print('Author already authenticated: ${author.email}');
      } else {
        _isAuthenticated = false;
        _currentAuthor = null;
        print('No authenticated author found.');
      }
    } catch (e) {
      _isAuthenticated = false;
      _currentAuthor = null;
      _errorMessage = 'Failed to check auth status: ${e.toString()}';
      debugPrint('Error checking auth status: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _authService.login(email: email, password: password);
      // Data author sudah disimpan di AuthService, kita bisa ambil lagi
      _currentAuthor = await _authService.getAuthenticatedAuthor();
      _isAuthenticated = true;
      _errorMessage = null;
      print('Login successful for author: ${_currentAuthor?.email}');
    } catch (e) {
      _isAuthenticated = false;
      _currentAuthor = null;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      debugPrint('Login failed: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<void> register({
  //   required String name,
  //   required String email,
  //   required String password,
  // }) async {
  //   _isLoading = true;
  //   _errorMessage = null;
  //   notifyListeners();
  //   try {
  //     await _authService.register(name: name, email: email, password: password);
  //     _errorMessage = null;
  //     if (navigatorKey.currentContext != null) {
  //       ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
  //         const SnackBar(content: Text('Registrasi Berhasil! Silakan Login.')),
  //       );
  //     }
  //   } catch (e) {
  //     _errorMessage = e.toString().replaceFirst('Exception: ', '');
  //     debugPrint('Registration failed: $e');
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    await _authService.clearAuthData();
    _isAuthenticated = false;
    _currentAuthor = null;
    _isLoading = false;
    notifyListeners();
    if (navigatorKey.currentContext != null) {
      Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  Future<void> fetchAuthorProfile() async {
    _isProfileLoading = true;
    _profileErrorMessage = null;
    notifyListeners();
    try {
      final authorProfile = await _authService.fetchAuthorProfile();
      _currentAuthor = authorProfile; // Update currentAuthor with fresh data
      _isProfileLoading = false;
    } catch (e) {
      _profileErrorMessage = e.toString().replaceFirst('Exception: ', '');
      _isProfileLoading = false;
      debugPrint('Error fetching author profile: $e');
      // If token is invalid (e.g., 401 Unauthorized), force logout
      if (_profileErrorMessage!.toLowerCase().contains('unauthorized')) {
        logout();
      }
    } finally {
      notifyListeners();
    }
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
}
