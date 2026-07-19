import 'package:flutter/material.dart';

class RegisterSuccessView extends StatelessWidget {
  const RegisterSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // Title
              const Text(
                'Terima Kasih,\nKini akunmu telah terdaftar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1739),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 48),
              // Premium Decorative Illustration
              Center(
                child: SizedBox(
                  width: 260,
                  height: 260,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background decorative bubbles
                      Positioned(
                        top: 20,
                        left: 30,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0x1A0007B0),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 40,
                        right: 20,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0x0F0007B0),
                          ),
                        ),
                      ),
                      // Card Mockup 1 (Credit card style element)
                      Positioned(
                        bottom: 60,
                        left: 20,
                        child: Transform.rotate(
                          angle: -0.15,
                          child: Container(
                            width: 100,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0x330007B0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      // Card Mockup 2 (Blue shopping cart or box element)
                      Positioned(
                        top: 50,
                        right: 30,
                        child: Transform.rotate(
                          angle: 0.2,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0007B0),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.local_shipping_outlined,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      // Main Phone Mockup
                      Container(
                        width: 130,
                        height: 210,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0B1739),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            // Speaker/Notch
                            Container(
                              width: 50,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const Spacer(),
                            // Green check circle on phone screen
                            Container(
                              width: 54,
                              height: 54,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF4CAF50),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const Spacer(),
                            // Home Bar
                            Container(
                              width: 60,
                              height: 4,
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // "Masuk" Button
              ElevatedButton(
                onPressed: () {
                  // Pop back to login screen
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0007B0),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Masuk',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
