import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/repositories/auth_repository.dart';

class LoginHistoryItem {
  final String location;
  final String statusOrTime;
  final String device;
  final bool isActive;

  LoginHistoryItem({
    required this.location,
    required this.statusOrTime,
    required this.device,
    required this.isActive,
  });
}

class LoginHistoryView extends StatefulWidget {
  const LoginHistoryView({super.key});

  @override
  State<LoginHistoryView> createState() => _LoginHistoryViewState();
}

class _LoginHistoryViewState extends State<LoginHistoryView> {
  bool _isLoading = true;
  List<LoginHistoryItem> _histories = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() {
      _isLoading = true;
    });

    final authRepository = Provider.of<AuthRepository>(context, listen: false);
    final rawData = await authRepository.getLoginHistory();

    if (rawData.isNotEmpty) {
      _histories = rawData.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final ip = item['ip'] ?? '127.0.0.1';
        final ua = item['user_agent'] ?? 'Aplikasi Kurir';
        final loggedAt = item['logged_at'] ?? item['CreatedAt'] ?? '';

        return LoginHistoryItem(
          location: 'IP: $ip',
          statusOrTime: index == 0 ? 'Aktif' : (loggedAt.toString().split('T')[0]),
          device: ua.toString().length > 35 ? '${ua.toString().substring(0, 35)}...' : ua.toString(),
          isActive: index == 0,
        );
      }).toList();
    } else {
      _histories = [
        LoginHistoryItem(
          location: 'Sesi Kurir Ini',
          statusOrTime: 'Aktif',
          device: 'Aplikasi Kurir',
          isActive: true,
        ),
      ];
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
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
          'Riwayat Masuk',
          style: TextStyle(
            color: Color(0xFF0B1739),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF0007B0)),
              )
            : RefreshIndicator(
                onRefresh: _fetchHistory,
                color: const Color(0xFF0007B0),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  itemCount: _histories.length,
                  itemBuilder: (context, index) {
                    final item = _histories[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.location,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0B1739),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: item.isActive
                                      ? const Color(0x1A4CAF50)
                                      : Colors.black.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  item.statusOrTime,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: item.isActive ? const Color(0xFF4CAF50) : Colors.black38,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.device,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
