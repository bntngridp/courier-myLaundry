import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/view_models/auth_view_model.dart';
import '../../take_order/view_models/take_order_view_model.dart';
import '../../take_order/views/take_order_view.dart';
import '../view_models/home_view_model.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../profile/views/profile_view.dart';
import '../../delivery/view_models/delivery_view_model.dart';
import '../../delivery/views/delivery_view.dart';
import '../../notification/views/notification_view.dart';
import '../../notification/view_models/notification_view_model.dart';

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
      Provider.of<NotificationViewModel>(context, listen: false).fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);
    final takeOrderViewModel = Provider.of<TakeOrderViewModel>(context, listen: false);

    final courierName = authViewModel.authRepository.currentUser?.username ?? 'Kurir';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Main Content depending on index
          if (_currentIndex == 0)
            RefreshIndicator(
              onRefresh: homeViewModel.checkActiveOrder,
              color: const Color(0xFF0007B0),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Gradient Header Card matching Customer App Design System
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0B1739), Color(0xFF0007B0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(36),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x200007B0),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Courier Profile & Notification Header Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withValues(alpha: 0.15),
                                      border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        courierName.isNotEmpty ? courierName[0].toUpperCase() : 'K',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          authViewModel.translate('Selamat Bekerja,'),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          courierName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                             Consumer<NotificationViewModel>(
                               builder: (context, notifVm, child) {
                                 return Container(
                                   decoration: BoxDecoration(
                                     color: Colors.white.withValues(alpha: 0.15),
                                     shape: BoxShape.circle,
                                     border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                                   ),
                                   child: Stack(
                                     clipBehavior: Clip.none,
                                     children: [
                                       IconButton(
                                         icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 22),
                                         onPressed: () {
                                           Navigator.push(
                                             context,
                                             MaterialPageRoute(builder: (context) => const NotificationView()),
                                           );
                                         },
                                       ),
                                       if (notifVm.unreadCount > 0)
                                         Positioned(
                                           right: 6,
                                           top: 6,
                                           child: Container(
                                             padding: const EdgeInsets.all(4),
                                             decoration: const BoxDecoration(
                                               color: Color(0xFFFF4757),
                                               shape: BoxShape.circle,
                                             ),
                                             child: Text(
                                               '${notifVm.unreadCount}',
                                               style: const TextStyle(
                                                 color: Colors.white,
                                                 fontSize: 9,
                                                 fontWeight: FontWeight.bold,
                                               ),
                                             ),
                                           ),
                                         ),
                                     ],
                                   ),
                                 );
                               },
                             ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Online Status Pill (Interactive & Dynamic DB Synchronization)
                        Consumer<AuthViewModel>(
                          builder: (context, authVm, child) {
                            final currentUser = authVm.authRepository.currentUser;
                            final bool isAvailable = currentUser?.isAvailable ?? true;
                            
                            String statusText = isAvailable ? 'Status: Available / Siap Tugas' : 'Status: Offline / Istirahat';
                            Color statusColor = isAvailable ? const Color(0xFF22C55E) : const Color(0xFF9CA3AF);

                            if (homeViewModel.hasActiveOrder && homeViewModel.activeOrder != null) {
                              final st = homeViewModel.activeOrder!.status.toLowerCase();
                              if (st.contains('delivering')) {
                                statusText = 'Status: Mengantar Order #${homeViewModel.activeOrder!.id}';
                                statusColor = const Color(0xFF3B82F6); // Blue
                              } else {
                                statusText = 'Status: Menjemput Order #${homeViewModel.activeOrder!.id}';
                                statusColor = const Color(0xFFF59E0B); // Amber
                              }
                            }

                            return GestureDetector(
                              onTap: homeViewModel.hasActiveOrder ? null : () async {
                                final newStatus = !isAvailable;
                                await authVm.toggleCourierStatus(newStatus);
                                if (context.mounted) {
                                  AppSnackBar.showSuccess(
                                    context,
                                    newStatus ? 'Status bertugas diaktifkan (Available)' : 'Status bertugas dinonaktifkan (Offline)',
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: statusColor,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      statusText,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (!homeViewModel.hasActiveOrder) ...[
                                      const SizedBox(width: 6),
                                      const Icon(Icons.sync_alt_rounded, color: Colors.white70, size: 14),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),


                  // Content Container with Padding
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        // ─── ACTIVE ORDER PROGRESS TRACKER ──────────────────
                        // Only shown when there's an active order
                        if (homeViewModel.hasActiveOrder && homeViewModel.activeOrder != null) ...[
                          _ActiveOrderTracker(
                            authViewModel: authViewModel,
                            homeViewModel: homeViewModel,
                            takeOrderViewModel: takeOrderViewModel,
                          ),
                          const SizedBox(height: 20),
                        ],

                        // ─── MAIN ACTION PANEL ───────────────────────────────
                        if (!homeViewModel.hasActiveOrder) ...[
                          // STATE A: No active order → Hero CTA card
                          Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: const Color(0xFFE8EAFC)),
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
                                // Icon cluster badge
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFFEEF0FB),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.assignment_turned_in_rounded,
                                          size: 38,
                                          color: Color(0xFF3B3FD8),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          border: Border.all(color: const Color(0xFFE8EAFC), width: 1.5),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.local_shipping_rounded,
                                            size: 14,
                                            color: Color(0xFFA5A8F5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  authViewModel.translate('Siap Bekerja Hari Ini?'),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0B1739),
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  authViewModel.translate('Aktifkan mode jemput pesanan dan antar pakaian kotor pelanggan.'),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF64748B),
                                    height: 1.5,
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
                                      backgroundColor: const Color(0xFF3B3FD8),
                                      padding: const EdgeInsets.symmetric(vertical: 18),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                    ).copyWith(
                                      overlayColor: WidgetStateProperty.resolveWith(
                                        (states) => states.contains(WidgetState.pressed)
                                            ? Colors.white.withValues(alpha: 0.08)
                                            : null,
                                      ),
                                    ),
                                    child: Text(
                                      authViewModel.translate('Cari & Jemput Pesanan'),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

              const SizedBox(height: 100), // Spacing for bottom navbar
            ],
          ),
        )
      else
        const ProfileView(),
              
          // Floating Bottom Navigation Bar
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
    );
  }
}

// ─── Active Order Progress Tracker Widget ─────────────────────────────────────
// Shown only when homeViewModel.hasActiveOrder == true
class _ActiveOrderTracker extends StatelessWidget {
  final AuthViewModel authViewModel;
  final HomeViewModel homeViewModel;
  final TakeOrderViewModel takeOrderViewModel;

  const _ActiveOrderTracker({
    required this.authViewModel,
    required this.homeViewModel,
    required this.takeOrderViewModel,
  });

  @override
  Widget build(BuildContext context) {
    final order = homeViewModel.activeOrder!;
    final status = order.status.toLowerCase();
    final isDelivering = status.contains('delivering') || status.contains('done');
    final customerName = order.customer?.username ?? 'Pelanggan';
    final orderId = '#${order.id}';

    const stepLabels = ['Pesanan Diterima', 'Menjemput', 'Mengantar'];
    final int activeStep = isDelivering ? 2 : 1;

    final accentColor = isDelivering ? const Color(0xFF2563EB) : const Color(0xFFF59E0B);
    final accentBg = isDelivering ? const Color(0xFFEFF6FF) : const Color(0xFFFFFBEB);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header bar ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: accentBg,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isDelivering ? Icons.local_shipping_rounded : Icons.directions_bike_rounded,
                    color: accentColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authViewModel.translate(
                          isDelivering ? 'Sedang Mengantar' : 'Sedang Menjemput',
                        ),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                          letterSpacing: 0.1,
                        ),
                      ),
                      Text(
                        '${authViewModel.translate('Pesanan')} $orderId · $customerName',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      authViewModel.translate('Aktif'),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Step progress indicator ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: List.generate(stepLabels.length * 2 - 1, (i) {
                if (i.isOdd) {
                  final segmentIndex = i ~/ 2;
                  final isDone = segmentIndex < activeStep;
                  return Expanded(
                    child: Container(
                      height: 2,
                      color: isDone ? const Color(0xFF3B3FD8) : const Color(0xFFE2E8F0),
                    ),
                  );
                }
                final stepIndex = i ~/ 2;
                final isDone = stepIndex < activeStep;
                final isCurrent = stepIndex == activeStep;
                return Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone || isCurrent
                        ? const Color(0xFF3B3FD8)
                        : const Color(0xFFE2E8F0),
                  ),
                  child: Center(
                    child: isDone
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                        : isCurrent
                            ? Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                  ),
                );
              }),
            ),
          ),
          // Step labels
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 6, 8, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(stepLabels.length, (i) {
                final isCurrent = i == activeStep;
                return SizedBox(
                  width: 80,
                  child: Text(
                    authViewModel.translate(stepLabels[i]),
                    textAlign: i == 0
                        ? TextAlign.left
                        : i == stepLabels.length - 1
                            ? TextAlign.right
                            : TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                      color: isCurrent ? const Color(0xFF3B3FD8) : const Color(0xFF94A3B8),
                    ),
                  ),
                );
              }),
            ),
          ),

          // ── Action button ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (isDelivering) {
                    final deliveryViewModel = Provider.of<DeliveryViewModel>(context, listen: false);
                    deliveryViewModel.startDeliveryFlow(order);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DeliveryView()),
                    ).then((_) => homeViewModel.checkActiveOrder());
                  } else {
                    takeOrderViewModel.resumeActiveOrder(order);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TakeOrderView()),
                    ).then((_) => homeViewModel.checkActiveOrder());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isDelivering ? Icons.local_shipping_rounded : Icons.navigation_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      authViewModel.translate(
                        isDelivering ? 'Lanjut Mengantar' : 'Lanjut Menjemput',
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
