import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/take_order_view_model.dart';

class TakeOrderView extends StatefulWidget {
  const TakeOrderView({super.key});

  @override
  State<TakeOrderView> createState() => _TakeOrderViewState();
}

class _TakeOrderViewState extends State<TakeOrderView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TakeOrderViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(context, viewModel),
      body: SafeArea(
        child: _buildBodyByStep(context, viewModel),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context, TakeOrderViewModel viewModel) {
    if (viewModel.currentStep == 5) return null; // No app bar for success screen

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF0B1739)),
        onPressed: () {
          if (viewModel.currentStep == 1 || viewModel.currentStep == 2) {
            viewModel.resetFlow();
          }
          Navigator.pop(context);
        },
      ),
      title: Text(
        _getAppBarTitle(viewModel.currentStep),
        style: const TextStyle(
          color: Color(0xFF0B1739),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [
        // Switch on top right for Step 0, 1, 2
        if (viewModel.currentStep <= 2)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Text(
                  viewModel.isAppActive ? 'ON' : 'OFF',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: viewModel.isAppActive ? const Color(0xFF4CAF50) : Colors.black38,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: viewModel.isAppActive,
                  onChanged: (val) {
                    viewModel.toggleAppActivity(val);
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _getAppBarTitle(int step) {
    switch (step) {
      case 0:
        return 'Ambil Pesanan';
      case 1:
        return 'Mencari Pesanan';
      case 2:
        return 'Pesanan Tersedia';
      case 3:
        return 'Perjalanan Penjemputan';
      case 4:
        return 'Pembayaran';
      default:
        return 'Ambil Pesanan';
    }
  }

  Widget _buildBodyByStep(BuildContext context, TakeOrderViewModel viewModel) {
    switch (viewModel.currentStep) {
      case 0:
        return _buildStepOff(context, viewModel);
      case 1:
        return _buildStepSearching(context, viewModel);
      case 2:
        return _buildStepList(context, viewModel);
      case 3:
        return _buildStepOnTheWay(context, viewModel);
      case 4:
        return _buildStepPayment(context, viewModel);
      case 5:
        return _buildStepSuccess(context, viewModel);
      default:
        return _buildStepOff(context, viewModel);
    }
  }

  // STEP 0: App is OFF
  Widget _buildStepOff(BuildContext context, TakeOrderViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: 0.03),
            ),
            child: const Icon(
              Icons.power_settings_new,
              size: 64,
              color: Colors.black26,
            ),
          ),
          const SizedBox(height: 36),
          const Text(
            'Aktifkan aplikasimu untuk\nmendapatkan pesanan',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black38,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // STEP 1: Searching for orders
  Widget _buildStepSearching(BuildContext context, TakeOrderViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          const Text(
            'Mencari Pesanan..',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B1739),
            ),
          ),
          const SizedBox(height: 48),
          const Center(
            child: SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                strokeWidth: 6,
                color: Color(0xFF0007B0),
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () => viewModel.toggleAppActivity(false),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0007B0),
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Batalkan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // STEP 2: Found unassigned orders list
  Widget _buildStepList(BuildContext context, TakeOrderViewModel viewModel) {
    if (viewModel.availableOrders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off, size: 64, color: Colors.black26),
              const SizedBox(height: 16),
              const Text(
                'Belum Ada Pesanan Baru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1739),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Kami akan mencari lagi secara otomatis ketika ada pesanan laundry masuk.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black38),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: viewModel.fetchAvailableOrders,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0007B0),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Segarkan', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Yeyy Pesanan Ketemu 😄',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B1739),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.availableOrders.length,
              itemBuilder: (context, index) {
                final order = viewModel.availableOrders[index];
                // Generate mock distances for visual fidelity
                final mockDistances = ['2.5 km', '3.8 km', '4.2 km', '6.0 km'];
                final distance = mockDistances[index % mockDistances.length];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      // Distance badge
                      Container(
                        width: 58,
                        height: 58,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE6F0FF),
                        ),
                        child: Center(
                          child: Text(
                            distance,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0007B0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.customer?.username ?? 'Pelanggan',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0B1739),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              order.service?.title ?? 'Laundry Service',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Terima Button
                      ElevatedButton(
                        onPressed: () => viewModel.acceptOrder(order),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Terima',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // STEP 3: On The Way with mockup map and bottom actions card
  Widget _buildStepOnTheWay(BuildContext context, TakeOrderViewModel viewModel) {
    final order = viewModel.currentOrder;
    final address = order?.address;

    return Stack(
      children: [
        // Map Mockup Painter
        Positioned.fill(
          child: CustomPaint(
            painter: _MockMapPainter(),
          ),
        ),
        
        // Custom Top Floating Address HUD
        Positioned(
          top: 16,
          left: 24,
          right: 24,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.my_location, color: Color(0xFF0007B0), size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rute Penjemputan',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        address?.receiverName ?? 'Rumah Pelanggan',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B1739),
                        ),
                      ),
                      Text(
                        address?.fullAddress ?? 'Alamat lengkap pelanggan',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),

        // Bottom HUD Card
        Positioned(
          bottom: 24,
          left: 24,
          right: 24,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Estimate time
                const Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'Anda akan tiba dalam ',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                      children: [
                        TextSpan(
                          text: '8 Menit',
                          style: TextStyle(
                            color: Color(0xFF0007B0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Telah Sampai Button
                ElevatedButton(
                  onPressed: viewModel.isLoading ? null : () => viewModel.markArrived(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0007B0),
                    padding: const EdgeInsets.symmetric(vertical: 18),
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
                      : const Text(
                          'Telah Sampai',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                
                // Chat input and call button Row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: TextField(
                                readOnly: true, // Mock input field
                                decoration: InputDecoration(
                                  hintText: 'Kirimkan pesan bisa diisi ya...',
                                  hintStyle: TextStyle(color: Colors.black38, fontSize: 13),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send, color: Color(0xFF0007B0), size: 18),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Phone Icon Button
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE6F0FF),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.phone, color: Color(0xFF0007B0), size: 22),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // STEP 4: Payment waiting state
  Widget _buildStepPayment(BuildContext context, TakeOrderViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          const Text(
            'Menunggu Pembayaran',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B1739),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Total Tagihan: Rp ${(viewModel.currentOrder?.totalPrice ?? 0).toInt()}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 48),
          const Center(
            child: SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                strokeWidth: 6,
                color: Color(0xFF0007B0),
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: viewModel.isLoading ? null : () => viewModel.processPayment(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0007B0),
              padding: const EdgeInsets.symmetric(vertical: 18),
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
                : const Text(
                    'Selesaikan Pembayaran Tunai',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // STEP 5: Payment success confirmation
  Widget _buildStepSuccess(BuildContext context, TakeOrderViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          const Text(
            'Pembayaran Berhasil',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0B1739),
            ),
          ),
          const SizedBox(height: 48),
          // Large Checkmark
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0007B0),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0007B0).withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 64,
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              viewModel.resetFlow();
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
              'Kembali ke Home',
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
    );
  }
}

// Custom Painter to draw a beautiful visual representation of a map route
class _MockMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..style = PaintingStyle.fill;
    
    // Fill background (mock land)
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Paint mock streets
    final streetPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 24.0;

    // Draw grid of mock streets
    canvas.drawLine(Offset(size.width * 0.2, 0), Offset(size.width * 0.2, size.height), streetPaint);
    canvas.drawLine(Offset(size.width * 0.5, 0), Offset(size.width * 0.5, size.height), streetPaint);
    canvas.drawLine(Offset(size.width * 0.8, 0), Offset(size.width * 0.8, size.height), streetPaint);
    
    canvas.drawLine(Offset(0, size.height * 0.25), Offset(size.width, size.height * 0.25), streetPaint);
    canvas.drawLine(Offset(0, size.height * 0.6), Offset(size.width, size.height * 0.6), streetPaint);
    canvas.drawLine(Offset(0, size.height * 0.85), Offset(size.width, size.height * 0.85), streetPaint);

    // Draw route path (blue line showing GPS direction)
    final routePaint = Paint()
      ..color = const Color(0xFF0007B0)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8.0;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.85) // Start pin
      ..lineTo(size.width * 0.2, size.height * 0.6)
      ..lineTo(size.width * 0.8, size.height * 0.6)
      ..lineTo(size.width * 0.8, size.height * 0.25); // Target pin
    
    canvas.drawPath(path, routePaint);

    // Draw Pins
    final startPinPaint = Paint()
      ..color = const Color(0xFF4CAF50) // Green pin for Courier
      ..style = PaintingStyle.fill;

    final endPinPaint = Paint()
      ..color = Colors.red // Red pin for Customer
      ..style = PaintingStyle.fill;

    // Courier Pin (Green)
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.85), 14, startPinPaint);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.85), 6, Paint()..color = Colors.white);

    // Customer Pin (Red)
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.25), 14, endPinPaint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.25), 6, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
