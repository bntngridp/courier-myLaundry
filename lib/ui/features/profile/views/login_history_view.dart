import 'package:flutter/material.dart';

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

class LoginHistoryView extends StatelessWidget {
  const LoginHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<LoginHistoryItem> histories = [
      LoginHistoryItem(
        location: 'Bandung, Indonesia',
        statusOrTime: 'Aktif',
        device: 'samsung xxx',
        isActive: true,
      ),
      LoginHistoryItem(
        location: 'Jakarta, Indonesia',
        statusOrTime: '02:23 AM, 12 Januari 2023',
        device: 'samsung SM-M123',
        isActive: false,
      ),
    ];

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
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          itemCount: histories.length,
          itemBuilder: (context, index) {
            final item = histories[index];

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
    );
  }
}
