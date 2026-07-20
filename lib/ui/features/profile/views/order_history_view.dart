import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../auth/view_models/auth_view_model.dart';
import '../../take_order/view_models/take_order_view_model.dart';
import '../../../../domain/models/order.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  bool _isLoading = true;
  String? _error;
  List<OrderModel> _historyOrders = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final takeOrderViewModel = Provider.of<TakeOrderViewModel>(context, listen: false);
    final token = authViewModel.authRepository.token;

    if (token == null) {
      setState(() {
        _isLoading = false;
        _error = 'Sesi masuk kadaluarsa';
      });
      return;
    }

    try {
      final orders = await takeOrderViewModel.orderRepository.getOrders(available: false, token: token);
      // Filter orders that are completed or delivered, or just show all courier orders
      setState(() {
        _historyOrders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  Map<String, List<OrderModel>> _groupOrdersByDate() {
    final Map<String, List<OrderModel>> groups = {};
    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);
    final yesterdayStr = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 1)));

    for (var order in _historyOrders) {
      final date = DateTime.tryParse(order.createdAt) ?? now;
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      
      String key;
      if (dateStr == todayStr) {
        key = 'Hari Ini';
      } else if (dateStr == yesterdayStr) {
        key = 'Kemarin';
      } else {
        key = DateFormat('dd MMMM yyyy', 'id_ID').format(date);
      }

      if (!groups.containsKey(key)) {
        groups[key] = [];
      }
      groups[key]!.add(order);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0B1739)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Riwayat',
          style: TextStyle(
            color: Color(0xFF0B1739),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF0007B0),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text(
                'Terjadi Kesalahan',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1739),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black38),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _fetchHistory();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0007B0),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    if (_historyOrders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.folder_open_outlined, size: 64, color: Colors.black26),
              const SizedBox(height: 16),
              const Text(
                'Belum Ada Riwayat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1739),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Semua pesanan yang telah Anda selesaikan akan muncul di sini.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black38),
              ),
            ],
          ),
        ),
      );
    }

    final grouped = _groupOrdersByDate();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      itemCount: grouped.keys.length,
      itemBuilder: (context, index) {
        final dateKey = grouped.keys.elementAt(index);
        final orders = grouped[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                dateKey,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1739),
                ),
              ),
            ),
            ...orders.map((order) {
              final priceText = 'Rp ${order.totalPrice.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')},00';

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
                    // Sliced circular service status icons from Figma
                    Row(
                      children: [
                        _buildCircleIcon(Icons.local_laundry_service, const Color(0xFFFFD700)), // Yellow washer
                        const SizedBox(width: 6),
                        _buildCircleIcon(Icons.iron, const Color(0xFF4CAF50)), // Green iron
                        const SizedBox(width: 6),
                        _buildCircleIcon(Icons.folder_open, const Color(0xFF0007B0)), // Blue package
                      ],
                    ),
                    const Spacer(),
                    // Total Price
                    Text(
                      priceText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0007B0),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildCircleIcon(IconData icon, Color color) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.15),
      ),
      child: Icon(icon, color: color, size: 16),
    );
  }
}
