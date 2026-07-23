import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/user.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService authService;
  User? _currentUser;
  String? _token;

  AuthRepository({required this.authService});

  User? get currentUser => _currentUser;
  String? get token => _token;
  bool get isAuthenticated => _token != null;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    final userJson = prefs.getString('auth_user');
    if (userJson != null) {
      try {
        _currentUser = User.fromJson(jsonDecode(userJson));
      } catch (_) {
        _currentUser = null;
      }
    }
  }

  Future<User?> login(String email, String password) async {
    final response = await authService.login(email, password);
    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      final data = body['data'];
      _token = data['token'];
      
      // Save token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);

      // Load user profile
      final user = await getMe();
      if (user != null) {
        if (user.role != 'courier') {
          // Reject if not courier
          await logout();
          throw Exception('Hanya akun kurir yang diperbolehkan masuk.');
        }
        _currentUser = user;
        await prefs.setString('auth_user', jsonEncode(user.toJson()));
      }
      return _currentUser;
    } else {
      final msg = body['message'] ?? 'Email atau password salah';
      throw Exception(msg);
    }
  }

  Future<bool> register({
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
    required String employeeCode,
  }) async {
    final response = await authService.register(
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      confirmPassword: confirmPassword,
      employeeCode: employeeCode,
    );
    final body = jsonDecode(response.body);

    if (response.statusCode == 201 || (response.statusCode == 200 && body['success'] == true)) {
      return true;
    } else {
      final msg = body['message'] ?? 'Pendaftaran gagal';
      throw Exception(msg);
    }
  }

  Future<User?> getMe() async {
    if (_token == null) return null;

    final response = await authService.getMe(_token!);
    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && (body['status'] == 'success' || body['success'] == true)) {
      final data = body['data'];
      return User.fromJson(data);
    } else {
      throw Exception(body['message'] ?? 'Gagal mengambil data profil');
    }
  }

  Future<void> logout() async {
    _token = null;
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_user');
  }

  Future<bool> forgotPassword(String email) async {
    final response = await authService.forgotPassword(email);
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 && body['success'] == true) {
      return true;
    } else {
      final msg = body['message'] ?? 'Gagal mengirim email pemulihan sandi.';
      throw Exception(msg);
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    final response = await authService.verifyOtp(email, otp);
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 && body['success'] == true) {
      return true;
    } else {
      final msg = body['message'] ?? 'Kode verifikasi tidak valid.';
      throw Exception(msg);
    }
  }

  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await authService.resetPassword(
      email: email,
      otp: otp,
      password: password,
      confirmPassword: confirmPassword,
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200 && body['success'] == true) {
      return true;
    } else {
      final msg = body['message'] ?? 'Gagal mengganti kata sandi.';
      throw Exception(msg);
    }
  }

  Future<User?> updateCourier({
    required String username,
    required String email,
    String? password,
  }) async {
    if (_token == null || _currentUser == null) {
      throw Exception('Sesi masuk tidak ditemukan.');
    }

    final response = await authService.updateCourier(
      id: _currentUser!.id,
      username: username,
      email: email,
      password: password,
      token: _token!,
    );
    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final updatedUser = await getMe();
      if (updatedUser != null) {
        _currentUser = updatedUser;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_user', jsonEncode(updatedUser.toJson()));
      }
      return _currentUser;
    } else {
      final msg = body['message'] ?? 'Gagal memperbaharui profil kurir.';
      throw Exception(msg);
    }
  }

  Future<User?> googleLogin(String idToken, {String role = 'courier'}) async {
    final response = await authService.googleLogin(idToken, role: role);
    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && (body['status'] == 'success' || body['success'] == true)) {
      final data = body['data'];
      _token = data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);

      final user = await getMe();
      if (user != null) {
        _currentUser = user;
        await prefs.setString('auth_user', jsonEncode(user.toJson()));
      }
      return _currentUser;
    } else {
      final msg = body['message'] ?? 'Google Login gagal';
      throw Exception(msg);
    }
  }
}
