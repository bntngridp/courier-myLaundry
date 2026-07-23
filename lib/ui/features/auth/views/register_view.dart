import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';
import 'register_success_view.dart';
import 'terms_conditions_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _employeeCodeController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _employeeCodeController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      final viewModel = Provider.of<AuthViewModel>(context, listen: false);
      final success = await viewModel.register(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _passwordController.text, // Same as password for simplified UI
        employeeCode: _employeeCodeController.text.trim(),
      );

      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RegisterSuccessView()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE6F0FF), Color(0xFFF8F9FA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0007B0).withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Brand Logo (Splash welcome style)
                      Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/logo-nobg.png',
                              height: 75,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 75,
                                height: 75,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFE6F0FF),
                                ),
                                child: const Icon(
                                  Icons.local_laundry_service,
                                  size: 36,
                                  color: Color(0xFF0007B0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'myLaundry',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0007B0),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const Text(
                              'Pendaftaran Kurir',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black38,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Username field
                      TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF0B1739), fontSize: 14),
                        decoration: InputDecoration(
                          hintText: viewModel.translate('Nama Pengguna'),
                          hintStyle: const TextStyle(color: Colors.black38, fontWeight: FontWeight.normal, fontSize: 13),
                          prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF0007B0), size: 20),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FA),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(color: Color(0xFF0007B0), width: 1.5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Masukkan nama pengguna Anda';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF0B1739), fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: const TextStyle(color: Colors.black38, fontWeight: FontWeight.normal, fontSize: 13),
                          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF0007B0), size: 20),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FA),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(color: Color(0xFF0007B0), width: 1.5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Masukkan alamat email Anda';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                            return 'Masukkan format email yang valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Phone Number field
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF0B1739), fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Nomor Telepon (mis. 081234567890)',
                          hintStyle: const TextStyle(color: Colors.black38, fontWeight: FontWeight.normal, fontSize: 13),
                          prefixIcon: const Icon(Icons.phone_outlined, color: Color(0xFF0007B0), size: 20),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FA),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(color: Color(0xFF0007B0), width: 1.5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Masukkan nomor telepon Anda';
                          }
                          if (value.trim().length < 9) {
                            return 'Nomor telepon tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF0B1739), fontSize: 14),
                        decoration: InputDecoration(
                          hintText: viewModel.translate('Kata Sandi Baru'),
                          hintStyle: const TextStyle(color: Colors.black38, fontWeight: FontWeight.normal, fontSize: 13),
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF0007B0), size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.black38,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FA),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(color: Color(0xFF0007B0), width: 1.5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan kata sandi baru Anda';
                          }
                          if (value.length < 6) {
                            return 'Kata sandi minimal terdiri dari 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Employee Special Code field
                      TextFormField(
                        controller: _employeeCodeController,
                        textInputAction: TextInputAction.done,
                        style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF0B1739), fontSize: 14),
                        decoration: InputDecoration(
                          hintText: viewModel.translate('Kode Khusus Karyawan'),
                          hintStyle: const TextStyle(color: Colors.black38, fontWeight: FontWeight.normal, fontSize: 13),
                          prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFF0007B0), size: 20),
                          filled: true,
                          fillColor: const Color(0xFFF8F9FA),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(color: Color(0xFF0007B0), width: 1.5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Masukkan kode khusus karyawan Anda';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      if (viewModel.errorMessage != null && viewModel.errorMessage!.isNotEmpty) ...[
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFCA5A5)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.priority_high_rounded,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  viewModel.errorMessage!,
                                  style: const TextStyle(
                                    color: Color(0xFF991B1B),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Register Button
                      ElevatedButton(
                        onPressed: viewModel.isLoading ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0007B0),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFF0007B0).withValues(alpha: 0.6),
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: viewModel.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                viewModel.translate('Daftar'),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      const SizedBox(height: 24),

                      // Terms and Conditions text
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TermsConditionsView()),
                          );
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: 'Dengan mendaftar anda telah menyetujui ',
                            style: TextStyle(fontSize: 11, color: Colors.black38, height: 1.4),
                            children: [
                              TextSpan(
                                text: 'syarat dan ketentuan',
                                style: TextStyle(
                                  color: Color(0xFF0007B0),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(text: ' berlaku'),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Already have an account link
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text.rich(
                          TextSpan(
                            text: viewModel.translate('Sudah punya akun? '),
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                            children: [
                              TextSpan(
                                text: viewModel.translate('Masuk disini'),
                                style: const TextStyle(
                                  color: Color(0xFF0007B0),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
