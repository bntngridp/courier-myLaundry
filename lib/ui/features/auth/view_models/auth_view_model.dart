import 'package:flutter/material.dart';
import '../../../../data/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository authRepository;
  bool _isLoading = false;
  String? _errorMessage;

  String? _emailForReset;
  String? _otpForReset;

  AuthViewModel({required this.authRepository});

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => authRepository.isAuthenticated;

  String? get emailForReset => _emailForReset;
  String? get otpForReset => _otpForReset;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email dan Kata Sandi tidak boleh kosong.');
      }
      await authRepository.login(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required String employeeCode,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (username.isEmpty || email.isEmpty || password.isEmpty || employeeCode.isEmpty) {
        throw Exception('Semua kolom wajib diisi.');
      }
      if (password != confirmPassword) {
        throw Exception('Konfirmasi kata sandi tidak cocok.');
      }
      await authRepository.register(
        username: username,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        employeeCode: employeeCode,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await authRepository.logout();
    notifyListeners();
  }

  Future<bool> sendOtp(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (email.isEmpty) {
        throw Exception('Masukkan alamat email anda.');
      }
      await authRepository.forgotPassword(email);
      _emailForReset = email;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOtpCode(String otp) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (otp.length != 4) {
        throw Exception('Kode verifikasi harus 4 digit.');
      }
      if (_emailForReset == null) {
        throw Exception('Sesi pemulihan tidak valid.');
      }
      await authRepository.verifyOtp(_emailForReset!, otp);
      _otpForReset = otp;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPasswordSubmit(String password, String confirmPassword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (password.isEmpty || confirmPassword.isEmpty) {
        throw Exception('Semua kolom wajib diisi.');
      }
      if (password != confirmPassword) {
        throw Exception('Kata sandi baru tidak cocok dengan konfirmasi.');
      }
      if (_emailForReset == null || _otpForReset == null) {
        throw Exception('Sesi pemulihan tidak valid.');
      }
      await authRepository.resetPassword(
        email: _emailForReset!,
        otp: _otpForReset!,
        password: password,
        confirmPassword: confirmPassword,
      );
      // Clean temporary fields
      _emailForReset = null;
      _otpForReset = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile({
    required String username,
    required String email,
    String? password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (username.isEmpty || email.isEmpty) {
        throw Exception('Nama dan Email tidak boleh kosong.');
      }
      await authRepository.updateCourier(
        username: username,
        email: email,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
