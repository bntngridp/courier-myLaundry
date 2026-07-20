import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/view_models/auth_view_model.dart';
import '../../take_order/view_models/take_order_view_model.dart';
import '../../take_order/views/take_order_view.dart';
import '../view_models/home_view_model.dart';
import '../../profile/views/profile_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0; // 0: Home, 1: Profile

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeViewModel>(context, listen: false).checkActiveOrder();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);
    final takeOrderViewModel = Provider.of<TakeOrderViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content depending on index
            if (_currentIndex == 0)
              RefreshIndicator(
                onRefresh: homeViewModel.checkActiveOrder,
                color: const Color(0xFF0007B0),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                  children: [
                    // App Bar info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Selamat Bekerja,',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black38,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              authViewModel.authRepository.currentUser?.username ?? 'Kurir',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0B1739),
                              ),
                            ),
                          ],
                        ),
                        // Notifications mock
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.notifications_none, color: Color(0xFF0B1739)),
                            onPressed: () {},
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 36),
                    
                    // Category buttons: Jemput Pesanan & Antar Pesanan
                    Row(
                      children: [
                        // Jemput Pesanan
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE6F0FF),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.local_shipping, color: Color(0xFF0007B0), size: 20),
                                ),
                                const SizedBox(width: 12),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Jemput',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0B1739),
                                      ),
                                    ),
                                    Text(
                                      'Pesanan',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.black38,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Antar Pesanan
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE2E8F0),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.outbox, color: Colors.black45, size: 20),
                                ),
                                const SizedBox(width: 12),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Antar',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0B1739),
                                      ),
                                    ),
                                    Text(
                                      'Pesanan',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.black38,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),

                    // Main Action Panel (State A & B dependent)
                    if (!homeViewModel.hasActiveOrder) ...[
                      // STATE A: Normal State (No active orders)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Visual illustration/icon
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF0007B0).withValues(alpha: 0.05),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.assignment_turned_in,
                                  size: 48,
                                  color: Color(0xFF0007B0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Siap Bekerja Hari Ini?',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0B1739),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Aktifkan mode ambil pesanan dan jemput pakaian kotor pelanggan sekarang.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black38,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const TakeOrderView(),
                                    ),
                                  ).then((_) {
                                    homeViewModel.checkActiveOrder();
                                  });
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
                                  'Ambil Pesanan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      // STATE B: In Progress State (Active order exists)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Visual alert icon
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.directions_run,
                                  size: 48,
                                  color: Color(0xFF4CAF50),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Pesanan Sedang Berjalan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0B1739),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Anda memiliki pesanan aktif atas nama pelanggan "${homeViewModel.activeOrder?.customer?.username ?? 'Pelanggan'}".',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black38,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Disabled Ambil Pesanan button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: null, // Disabled
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE2E8F0),
                                  disabledBackgroundColor: const Color(0xFFF1F5F9),
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Ambil Pesanan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black26,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Lanjutkan Pesanan Terakhir button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (homeViewModel.activeOrder != null) {
                                    takeOrderViewModel.resumeActiveOrder(homeViewModel.activeOrder!);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const TakeOrderView(),
                                      ),
                                    ).then((_) {
                                      homeViewModel.checkActiveOrder();
                                    });
                                  }
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
                                  'Lanjutkan Pesanan Terakhir',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 100), // Spacing for bottom navbar
                  ],
                ),
              )
            else
              const ProfileView(),
              
            // Floating Bottom Navigation Bar (Visual fidelity to Figma spec)
            Positioned(
              bottom: 24,
              left: 64,
              right: 64,
              child: Container(
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Home Icon Button
                    IconButton(
                      icon: Icon(
                        Icons.home_filled,
                        color: _currentIndex == 0 ? const Color(0xFF0007B0) : Colors.black26,
                        size: 28,
                      ),
                      onPressed: () {
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                    ),
                    // Profile Icon Button
                    IconButton(
                      icon: Icon(
                        Icons.person,
                        color: _currentIndex == 1 ? const Color(0xFF0007B0) : Colors.black26,
                        size: 28,
                      ),
                      onPressed: () {
                        setState(() {
                          _currentIndex = 1;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
