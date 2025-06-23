import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

// Import model dan konstanta API yang diperlukan
import 'package:vartaa/constants/api_constants.dart';
import 'package:vartaa/models/author.dart';

class AuthController with ChangeNotifier {
  Author? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Getter untuk mengakses state dari luar kelas
  Author? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  Future<void> login({required String email, required String password}) async {
    _isLoading = true; // Set status loading menjadi true
    _errorMessage = null; // Reset pesan error
    notifyListeners(); // Beri tahu listener bahwa state telah berubah (loading dimulai)

    try {
      final uri = Uri.parse(
        '${ApiConstant.baseUrl}${ApiConstant.loginEndpoint}',
      );

      print('Melakukan login dengan email: $email'); // Debugging

      final Response response = await http.post(
        uri,
        headers: ApiConstant.headers,
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('response.body ${response.statusCode}');

      if (response.statusCode == 200) {
        // Jika login sukses, dekode respons dan simpan data pengguna
        final data = jsonDecode(response.body);
        _currentUser = Author.fromJson(
          data,
        ); // Asumsikan respons berisi data pengguna
        _errorMessage = null; // Pastikan tidak ada pesan error
        print('Login berhasil untuk pengguna: ${_currentUser?.email}');
      } else {
        // Jika login gagal, set pesan error
        final errorData = jsonDecode(response.body);
        _errorMessage =
            'Login gagal: ${errorData['message'] ?? 'Status code: ${response.statusCode}'}';
        _currentUser = null; // Kosongkan pengguna saat ini jika gagal
        print('Login gagal: $_errorMessage');
      }
    } catch (e) {
      // Menangani error jaringan atau error lainnya
      _errorMessage = 'Terjadi kesalahan saat login: ${e.toString()}';
      _currentUser = null; // Kosongkan pengguna saat ini jika ada error
      print('Error saat login: $_errorMessage');
    } finally {
      _isLoading = false; // Set status loading menjadi false
      notifyListeners(); // Beri tahu listener bahwa state telah berubah (loading selesai)
    }
  }

  /// Metode ini menangani proses registrasi pengguna baru.
  /// Ini menerima [email] dan [password], melakukan panggilan API,
  /// memproses respons, dan memperbarui state.
  // Future<void> register({
  //   required String email,
  //   required String password,
  // }) async {
  //   _isLoading = true; // Set status loading menjadi true
  //   _errorMessage = null; // Reset pesan error
  //   notifyListeners(); // Beri tahu listener bahwa state telah berubah (loading dimulai)

  //   try {
  //     final uri = Uri.parse(
  //       '${ApiConstant.baseUrl}${ApiConstant.registerEndpoint}',
  //     );

  //     print('Melakukan registrasi dengan email: $email'); // Debugging

  //     final Response response = await http.post(
  //       uri,
  //       headers: ApiConstant.headers, // Menggunakan header standar
  //       body: jsonEncode({
  //         'email': email,
  //         'password': password,
  //       }), // Mengirim kredensial dalam body JSON
  //     );

  //     if (response.statusCode == 201) {
  //       // Asumsikan 201 Created untuk registrasi sukses
  //       // Jika registrasi sukses, dekode respons dan mungkin login otomatis
  //       final data = jsonDecode(response.body);
  //       _currentUser = Author.fromJson(
  //         data,
  //       ); // Asumsikan respons berisi data pengguna baru
  //       _errorMessage = null; // Pastikan tidak ada pesan error
  //       print('Registrasi berhasil untuk pengguna: ${_currentUser?.email}');
  //     } else {
  //       // Jika registrasi gagal, set pesan error
  //       final errorData = jsonDecode(response.body);
  //       _errorMessage =
  //           'Registrasi gagal: ${errorData['message'] ?? 'Status code: ${response.statusCode}'}';
  //       _currentUser = null; // Kosongkan pengguna saat ini jika gagal
  //       print('Registrasi gagal: $_errorMessage');
  //     }
  //   } catch (e) {
  //     // Menangani error jaringan atau error lainnya
  //     _errorMessage = 'Terjadi kesalahan saat registrasi: ${e.toString()}';
  //     _currentUser = null; // Kosongkan pengguna saat ini jika ada error
  //     print('Error saat registrasi: $_errorMessage');
  //   } finally {
  //     _isLoading = false; // Set status loading menjadi false
  //     notifyListeners(); // Beri tahu listener bahwa state telah berubah (loading selesai)
  //   }
  // }

  /// Metode ini menangani proses logout pengguna.
  /// Ini hanya membersihkan state pengguna saat ini.
  Future<void> logout() async {
    _isLoading = true; // Set status loading
    notifyListeners();

    // Dalam aplikasi nyata, Anda mungkin ingin memanggil API logout ke backend
    // dan menghapus token dari penyimpanan lokal (misalnya SharedPreferences).
    // Untuk contoh ini, kita hanya membersihkan state lokal.
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulasi penundaan API

    _currentUser = null; // Hapus pengguna yang sedang login
    _errorMessage = null; // Reset pesan error
    _isLoading = false; // Set status loading
    notifyListeners(); // Beri tahu listener bahwa state telah berubah (logout selesai)
    print('Pengguna berhasil logout.');
  }

  /// Metode ini bisa digunakan untuk menginisialisasi status autentikasi,
  /// misalnya dengan memeriksa token yang tersimpan di penyimpanan lokal.
  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Di sini Anda akan memeriksa apakah ada token autentikasi yang tersimpan
      // Misalnya: final storedToken = await SharedPreferences.getInstance().getString('user_token');
      // Jika ada, Anda bisa mencoba memvalidasinya atau mengambil ulang data pengguna.
      await Future.delayed(const Duration(seconds: 1)); // Simulasi pengecekan

      // Jika token valid dan bisa mendapatkan data pengguna:
      // _currentUser = Author.fromJson(data);
      // Jika tidak ada atau tidak valid:
      _currentUser = null;
    } catch (e) {
      _errorMessage = 'Gagal memeriksa status autentikasi: ${e.toString()}';
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
