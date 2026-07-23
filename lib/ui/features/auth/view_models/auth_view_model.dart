import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../data/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository authRepository;
  bool _isLoading = false;
  String? _errorMessage;

  String? _emailForReset;
  String? _otpForReset;

  String _currentLanguage = 'id';

  AuthViewModel({required this.authRepository}) {
    _loadLanguage();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => authRepository.isAuthenticated;

  String? get emailForReset => _emailForReset;
  String? get otpForReset => _otpForReset;
  String get currentLanguage => _currentLanguage;

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('app_lang') ?? 'id';
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _currentLanguage = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_lang', lang);
    notifyListeners();
  }

  String translate(String key) {
    if (_currentLanguage == 'en') {
      return _translations['en']?[key] ?? key;
    }
    return key;
  }

  static const Map<String, Map<String, String>> _translations = {
    'en': {
      'Masuk': 'Login',
      'Daftar': 'Register',
      'Lupa Password': 'Forgot Password',
      'Lupa Kata Sandi?': 'Forgot Password?',
      'Kata Sandi': 'Password',
      'Kata Sandi Baru': 'New Password',
      'Nama Pengguna': 'Username',
      'Kamu lupa password? klik disini': 'Forgot password? click here',
      'Belum punya akun? Yuk Daftar': "Don't have an account? Register",
      'Sudah punya akun? Masuk disini': 'Already have an account? Login here',
      'Kamu lupa password? ': 'Forgot password? ',
      'klik disini': 'click here',
      'Belum punya akun? ': "Don't have an account? ",
      'Yuk Daftar': 'Register',
      'Sudah punya akun? ': 'Already have an account? ',
      'Sudah ingat kata sandi? ': 'Remember password? ',
      'Masuk disini': 'Login here',
      'Atau masuk dengan': 'Or login with',
      'Atau daftar dengan': 'Or register with',
      'Bahasa': 'Language',
      'Keamanan': 'Security',
      'Keluar': 'Logout',
      'Edit Profil': 'Edit Profile',
      'Riwayat Pesanan': 'Order History',
      'Ketentuan': 'Terms of Service',
      'Daftar Akun': 'Register Account',
      'Kode Khusus Karyawan': 'Employee Code',
      'Verifikasi': 'Verify',
      'Kirim': 'Send',
      'Kirim Kode Verifikasi': 'Send Verification Code',
      'Masukkan alamat email Anda': 'Enter your email address',
      'Masukkan alamat email terdaftar Anda untuk menerima kode verifikasi OTP.': 'Enter your registered email address to receive the OTP verification code.',
      'Email terdaftar': 'Registered Email',
      'Nama': 'Name',
      'Simpan': 'Save',
      'Layanan Kami': 'Our Services',
      'Cabang Terdekat': 'Closest Branches',
      'Pesanan Aktif': 'Active Order',
      'Hubungi Kurir': 'Contact Courier',
      'Hubungi Pelanggan': 'Contact Customer',
      'Kembalikan Cucian': 'Return Laundry',
      'Detail Pesanan': 'Order Details',
      'Total Pembayaran': 'Total Payment',
      'Metode Pembayaran': 'Payment Method',
      'Pilih Metode Pembayaran': 'Select Payment Method',
      'Bayar': 'Pay',
      'Pencucian': 'Washing',
      'Penyetrikaan': 'Ironing',
      'Cuci & Setrika': 'Wash & Iron',
      'Dry Cleaning': 'Dry Cleaning',
      'Sedang mencari kurir': 'Looking for a courier',
      'Kurir dalam perjalanan': 'Courier is on the way',
      'Kurir telah sampai': 'Courier has arrived',
      'Pesanan sedang diproses': 'Order is being processed',
      'Menunggu pembayaran': 'Waiting for payment',
      'Kurir dalam perjalanan mengantar pakaianmu': 'Courier is on the way to deliver your clothes',
      'Pesanan diproses': 'Order is processed',
      'Yuk gunakan promo #BersihTanpaPusing': "Let's use the #CleanWithoutHeadache promo",
      'Selamat Bekerja,': 'Happy Working,',
      'Siap Bekerja': 'Ready to Work',
      'Istirahat': 'On Break',
      'Status Operasional': 'Operational Status',
      'Pesanan Baru': 'New Orders',
      'Terima Pesanan': 'Accept Order',
      'Penjemputan': 'Pick-up',
      'Pengantaran': 'Delivery',
      'Tugas': 'Tasks',
      'Info': 'Info',
      'Notifikasi Kurir': 'Courier Notifications',
      'Konfirmasi Penjemputan': 'Confirm Pick-up',
      'Konfirmasi Pengantaran': 'Confirm Delivery',
      'Tugas Penjemputan Pakaian': 'Laundry Pick-up Task',
      'Tugas Pengantaran Pakaian': 'Laundry Delivery Task',
      'Konfirmasi Keluar': 'Logout Confirmation',
      'Apakah kamu yakin ingin keluar dari akun Kurir?\nPastikan tidak ada tugas penjemputan aktif.': 'Are you sure you want to log out of Courier account?\nMake sure there are no active pickup tasks.',
      'Batal': 'Cancel',
      'Ya, Keluar': 'Yes, Logout',
      'Tandai dibaca': 'Mark as read',
      'Belum ada notifikasi': 'No notifications yet',
      'Notifikasi tugas kurir akan muncul di sini': 'Courier task notifications will appear here',
      'Baru saja': 'Just now',
      'Profil Kurir': 'Courier Profile',
      'Semua': 'All',
      'Pusat Bantuan': 'Help Center',
      'Beranda': 'Home',
      'Profil': 'Profile',
    }
  };

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _translateError(String err) {
    final lower = err.toLowerCase();
    if (lower.contains('uppercase')) {
      return translate('Kata sandi harus mengandung minimal 1 huruf besar (A-Z)');
    }
    if (lower.contains('lowercase')) {
      return translate('Kata sandi harus mengandung minimal 1 huruf kecil (a-z)');
    }
    if (lower.contains('number') || lower.contains('digit')) {
      return translate('Kata sandi harus mengandung minimal 1 angka (0-9)');
    }
    if (lower.contains('special character')) {
      return translate('Kata sandi harus mengandung minimal 1 karakter spesial (!, @, #, \$, dll.)');
    }
    if (lower.contains('at least 8 characters') || lower.contains('minimal 8')) {
      return translate('Kata sandi minimal harus 8 karakter');
    }
    if (lower.contains('invalid email or password') || lower.contains('invalid credentials') || lower.contains('unauthorized')) {
      return translate('Email atau kata sandi tidak sesuai');
    }
    if (lower.contains('user not found') || lower.contains('record not found')) {
      return translate('Pengguna tidak ditemukan');
    }
    if (lower.contains('already exists') || lower.contains('already registered')) {
      return translate('Email sudah terdaftar');
    }
    if (lower.contains('otp')) {
      return translate('Kode OTP tidak valid atau sudah kadaluarsa');
    }
    return translate(err);
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
      _errorMessage = _translateError(e.toString().replaceAll('Exception: ', ''));
      _isLoading = false;
      notifyListeners();
      return false;
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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (username.isEmpty || email.isEmpty || phoneNumber.isEmpty || password.isEmpty || employeeCode.isEmpty) {
        throw Exception('Semua kolom wajib diisi.');
      }
      if (password != confirmPassword) {
        throw Exception('Konfirmasi kata sandi tidak cocok.');
      }
      await authRepository.register(
        username: username,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        confirmPassword: confirmPassword,
        employeeCode: employeeCode,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _translateError(e.toString().replaceAll('Exception: ', ''));
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
      _errorMessage = _translateError(e.toString().replaceAll('Exception: ', ''));
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
      if (otp.length != 6) {
        throw Exception('Kode verifikasi harus 6 digit.');
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
      _errorMessage = _translateError(e.toString().replaceAll('Exception: ', ''));
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
      _errorMessage = _translateError(e.toString().replaceAll('Exception: ', ''));
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

  Future<bool> signInWithGoogle({String role = 'courier'}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final googleSignIn = GoogleSignIn(
        clientId: '283643492359-mpbkb6sbjor6frhdt6u082ssj8as48ok.apps.googleusercontent.com',
        scopes: ['email', 'profile'],
      );
      final account = await googleSignIn.signIn();
      if (account == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final auth = await account.authentication;
      final idToken = auth.idToken ?? auth.accessToken;
      if (idToken == null || idToken.isEmpty) {
        throw Exception('Gagal mendapatkan token dari Google.');
      }

      final user = await authRepository.googleLogin(idToken, role: role);
      _isLoading = false;
      notifyListeners();
      return user != null;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
