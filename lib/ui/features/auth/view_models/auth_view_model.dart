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

  Future<void> toggleCourierStatus(bool isAvailable) async {
    _isLoading = true;
    notifyListeners();
    final success = await authRepository.updateCourierStatus(isAvailable);
    _isLoading = false;
    notifyListeners();
    if (!success) {
      throw Exception('Gagal memperbarui status keberadaan kurir.');
    }
  }

  String translate(String key) {
    if (_currentLanguage == 'en') {
      return _translations['en']?[key] ?? key;
    }
    return key;
  }

  static const Map<String, Map<String, String>> _translations = {
    'en': {
      // Auth & Common
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
      
      // Home & Metrics
      'Selamat Bekerja,': 'Happy Working,',
      'Status: Available / Siap Tugas': 'Status: Available / On Duty',
      'Status: Offline / Istirahat': 'Status: Offline / Off Duty',
      'Status: Menjemput Order #': 'Status: Picking up Order #',
      'Status: Mengantar Order #': 'Status: Delivering Order #',
      'Status bertugas diaktifkan (Available)': 'Duty status activated (Available)',
      'Status bertugas dinonaktifkan (Offline)': 'Duty status deactivated (Offline)',
      'Jemput': 'Pick-up',
      'Antar': 'Deliver',
      'Pesanan': 'Order',
      'Cari & Jemput Pesanan': 'Search & Pick Up Orders',
      'Siap Bekerja Hari Ini?': 'Ready to Work Today?',
      'Aktifkan mode ambil pesanan dan jemput pakaian kotor pelanggan sekarang.': 'Activate order pickup mode and collect dirty laundry from customers now.',
      'Ringkasan Performa Hari Ini': "Today's Performance Summary",
      'Selesai': 'Completed',
      'Pendapatan': 'Earnings',
      'Rating': 'Rating',
      'Pastikan GPS dan koneksi internet selalu aktif agar lokasi terdeteksi akurat saat kurir bertugas.': 'Ensure GPS and internet connection are active so location is accurately detected while on duty.',
      
      // Take Order / Tasks
      'Ambil Pesanan': 'Pick Up Orders',
      'Mencari Pesanan': 'Searching for Orders',
      'Pesanan Tersedia': 'Available Orders',
      'Aktifkan Mode Bertugas': 'Activate Duty Mode',
      'Tekan tombol power atau switch di atas untuk mulai menerima order penjemputan terdekat.': 'Press the power button or switch above to start receiving nearest pickup orders.',
      'SIAP TERIMA PESANAN': 'READY TO ACCEPT ORDERS',
      'Memindai area sekitar...': 'Scanning surrounding area...',
      'Mencari pesanan penjemputan pakaian laundry di sekitar lokasimu.': 'Searching for laundry pickup orders near your location.',
      'Daftar Pesanan Siap Dijemput': 'List of Orders Ready for Pickup',
      'Pilih pesanan yang ingin kamu ambil sekarang:': 'Select the order you want to pick up now:',
      'Terima Pesanan Ini': 'Accept This Order',
      'Dalam Perjalanan Menuju Pelanggan': 'On the Way to Customer',
      'Sudah Sampai di Lokasi Pelanggan': 'Arrived at Customer Location',
      'Peta Lokasi Penjemputan': 'Pickup Location Map',
      'Input Rincian Cucian Pelanggan': 'Input Customer Laundry Details',
      'Kategori Cucian': 'Laundry Category',
      'Pilih Jenis Layanan': 'Select Service Type',
      'Jumlah (Kg / Pcs)': 'Quantity (Kg / Pcs)',
      'Tambah Ke Rincian': 'Add To Details',
      'Daftar Rincian Cucian': 'Laundry Details List',
      'Total Biaya': 'Total Cost',
      'Lanjut Ke Pembayaran': 'Continue To Payment',
      'Proses Pembayaran Tunai': 'Process Cash Payment',
      'Terima Pembayaran Tunai': 'Accept Cash Payment',
      'Konfirmasi Pembayaran': 'Confirm Payment',
      'Pesanan Berhasil Dijemput!': 'Order Successfully Picked Up!',
      'Pakaian pelanggan akan segera diproses di outlet laundry.': 'Customer clothes will be processed at the laundry outlet soon.',
      'Kembali ke Beranda': 'Back to Home',
      
      // Delivery
      'Pengantaran Pakaian': 'Laundry Delivery',
      'Mulai Antar Kembali': 'Start Returning Delivery',
      'Selesaikan Pengantaran': 'Complete Delivery',
      'Pesanan Berhasil Diselesaikan!': 'Order Successfully Completed!',
      'Terima kasih telah memberikan pelayanan terbaik untuk pelanggan!': 'Thank you for providing the best service for customers!',
      
      // Profile & Settings
      'Profil': 'Profile',
      'Informasi Akun': 'Account Information',
      'Nomor Telepon': 'Phone Number',
      'Email': 'Email',
      'Kode Kurir': 'Courier ID',
      'Tanggal Bergabung': 'Join Date',
      'Pilih Bahasa': 'Select Language',
      'Ubah Password': 'Change Password',
      'Password Lama': 'Old Password',
      'Password Baru': 'New Password',
      'Konfirmasi Password Baru': 'Confirm New Password',
      'Konfirmasi Keluar': 'Logout Confirmation',
      'Apakah kamu yakin ingin keluar dari akun Kurir?\nPastikan tidak ada tugas penjemputan aktif.': 'Are you sure you want to log out of Courier account?\nMake sure there are no active pickup tasks.',
      'Batal': 'Cancel',
      'Ya, Keluar': 'Yes, Logout',
      
      // History & Notifications
      'Pesanan Sedang Berjalan': 'Order In Progress',
      'Lanjutkan Pesanan Terakhir': 'Continue Active Order',
      'Tidak ada pesanan yang siap diantarkan kembali.': 'No orders ready for returning delivery.',
      'Belum ada riwayat pesanan': 'No order history yet',
      'Pesanan yang sudah kamu selesaikan akan muncul di sini': 'Orders you have completed will appear here',
      'Notifikasi': 'Notifications',
      'Belum ada notifikasi': 'No notifications yet',
      'Tandai dibaca': 'Mark as read',
      'Semua': 'All',
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
    if (err.contains('sudah terdaftar') || err.contains('sudah digunakan')) {
      return translate(err);
    }
    if (lower.contains('already exists') || lower.contains('already registered')) {
      return translate('Email atau nomor telepon sudah terdaftar, silakan gunakan data lain atau login');
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
    String? oldPassword,
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
        oldPassword: oldPassword,
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
