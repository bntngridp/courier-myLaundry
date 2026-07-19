import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/view_models/auth_view_model.dart';
import '../../auth/views/login_view.dart';
import '../../take_order/view_models/take_order_view_model.dart';
import '../../take_order/views/take_order_view.dart';
import '../view_models/home_view_model.dart';

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
    // Fetch active order state on mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().checkActiveOrder();
    });
  }

  void _showProfileDialog(BuildContext context, AuthViewModel authViewModel) {
    final user = authViewModel.authRepository.currentUser;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar Circle
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF0007B0),
                ),
                child: Center(
                  child: Text(
                    user?.username.substring(0, 1).toUpperCase() ?? 'K',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Username
              Text(
                user?.username ?? 'Nama Kurir',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1739),
                ),
              ),
              const SizedBox(height: 4),
              // Role Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0x1A0007B0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Kurir Resmi',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0007B0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFE2E8F0)),
              const SizedBox(height: 8),
              // Email
              Row(
                children: [
                  const Icon(Icons.email_outlined, size: 20, color: Colors.black38),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      user?.email ?? 'kurir@mylaundry.com',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context); // Close dialog
                    await authViewModel.logout();
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginView()),
                        (route) => false,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Keluar Akun',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);
    final takeOrderViewModel = Provider.of<TakeOrderViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: homeViewModel.checkActiveOrder,
          color: const Color(0xFF0007B0),
          child: Stack(
            children: [
              // Main content scrollable to allow pull-to-refresh
              ListView(
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
                                width: 42,
                                height: 42,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFE6F0FF),
                                ),
                                child: const Icon(
                                  Icons.arrow_upward,
                                  color: Color(0xFF0007B0),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
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
                                        fontSize: 12,
                                        color: Colors.black38,
                                      ),
                                    ),
                                  ],
                                ),
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
                                width: 42,
                                height: 42,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFE8F5E9),
                                ),
                                child: const Icon(
                                  Icons.arrow_downward,
                                  color: Color(0xFF4CAF50),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
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
                                        fontSize: 12,
                                        color: Colors.black38,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),

                  // Button triggers based on Home State (Normal vs. In Progress)
                  if (!homeViewModel.hasActiveOrder) ...[
                    // State A: Normal Home page
                    Center(
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF0007B0).withValues(alpha: 0.05),
                        ),
                        child: const Icon(
                          Icons.local_shipping_outlined,
                          size: 64,
                          color: Color(0xFF0007B0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 64),
                    ElevatedButton(
                      onPressed: () {
                        // Reset flow and navigate to take order screen
                        takeOrderViewModel.resetFlow();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TakeOrderView()),
                        ).then((_) => homeViewModel.checkActiveOrder());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0007B0),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
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
                  ] else ...[
                    // State B: In Progress Home page
                    Center(
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFF3CD),
                        ),
                        child: const Icon(
                          Icons.directions_run_outlined,
                          size: 64,
                          color: Color(0xFF856404),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Disabled Ambil Pesanan button (grayed out)
                    ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE2E8F0),
                        disabledBackgroundColor: const Color(0xFFE2E8F0),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
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
                    const SizedBox(height: 16),
                    // Lanjutkan Pesanan Terakhir button
                    ElevatedButton(
                      onPressed: () {
                        // Resume active order flow
                        takeOrderViewModel.resumeActiveOrder(homeViewModel.activeOrder!);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TakeOrderView()),
                        ).then((_) => homeViewModel.checkActiveOrder());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0007B0),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
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
                  ],
                  const SizedBox(height: 100), // Spacing for bottom navbar
                ],
              ),
              
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
                          _showProfileDialog(context, authViewModel);
                          // Reset back to Home index visually
                          setState(() {
                            _currentIndex = 0;
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
      ),
    );
  }
}
