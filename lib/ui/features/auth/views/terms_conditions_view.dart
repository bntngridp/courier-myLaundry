import 'package:flutter/material.dart';

class TermsConditionsView extends StatelessWidget {
  const TermsConditionsView({super.key});

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
          'Syarat dan Ketentuan',
          style: TextStyle(
            color: Color(0xFF0B1739),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Syarat dan Ketentuan Kurir myLaundry',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1739),
                ),
              ),
              const SizedBox(height: 16),
              _buildPointSection(
                number: '1.',
                title: 'Penerimaan Syarat dan Ketentuan',
                body: 'Dengan mendaftar sebagai kurir di myLaundry ("Aplikasi"), Anda setuju untuk mematuhi dan terikat oleh Syarat dan Ketentuan ini. Jika Anda tidak setuju dengan syarat-syarat ini, harap jangan melanjutkan pendaftaran atau penggunaan Aplikasi sebagai kurir.',
              ),
              _buildPointSection(
                number: '2.',
                title: 'Kualifikasi Kurir',
                bullets: [
                  'Kurir harus memiliki SIM (Surat Izin Mengemudi) yang masih berlaku.',
                  'Kurir harus memiliki kendaraan pribadi yang layak dan sesuai dengan persyaratan yang ditetapkan oleh myLaundry.',
                  'Kurir harus memiliki smartphone dengan akses internet untuk menggunakan Aplikasi.',
                ],
              ),
              _buildPointSection(
                number: '3.',
                title: 'Tanggung Jawab Kurir',
                bullets: [
                  'Kurir bertanggung jawab untuk menjemput dan mengantarkan pakaian pelanggan sesuai dengan jadwal yang telah disepakati di Aplikasi.',
                  'Kurir harus memastikan bahwa pakaian yang diambil dan diantar dalam kondisi yang sama seperti saat diterima, tanpa kerusakan atau kehilangan.',
                  'Kurir harus menjaga komunikasi yang baik dengan pelanggan dan memberikan layanan yang ramah dan profesional.',
                  'Kurir harus menggunakan perlengkapan penjemputan dan pengantaran yang disediakan oleh myLaundry untuk menjaga kualitas layanan.',
                ],
              ),
              _buildPointSection(
                number: '4.',
                title: 'Proses Penjemputan dan Pengantaran',
                bullets: [
                  'Kurir harus memastikan bahwa pakaian sudah siap untuk diambil pada waktu yang telah ditentukan di Aplikasi.',
                  'Kurir harus memastikan pakaian yang telah dicuci dikembalikan kepada pelanggan pada waktu dan lokasi yang telah disepakati.',
                  'Kurir harus memeriksa dan mencatat kondisi pakaian saat penjemputan dan pengantaran untuk menghindari sengketa.',
                ],
              ),
              _buildPointSection(
                number: '5.',
                title: 'Pembayaran dan Kompensasi',
                bullets: [
                  'Kurir akan menerima pembayaran berdasarkan jumlah penjemputan dan pengantaran yang dilakukan, sesuai dengan tarif yang ditetapkan oleh myLaundry.',
                  'Pembayaran akan dilakukan secara mingguan/bulanan melalui metode yang disepakati oleh kedua belah pihak.',
                  'Kurir berhak mendapatkan kompensasi tambahan untuk tugas-tugas khusus atau penjemputan dan pengantaran di luar jam kerja yang disepakati.',
                ],
              ),
              _buildPointSection(
                number: '6.',
                title: 'Batasan Tanggung Jawab',
                bullets: [
                  'myLaundry tidak bertanggung jawab atas kerugian atau kerusakan yang disebabkan oleh tindakan kurir di luar tanggung jawab pekerjaan yang telah ditentukan.',
                  'Kurir bertanggung jawab atas segala biaya yang timbul akibat pelanggaran hukum atau peraturan lalu lintas selama melakukan tugas.',
                ],
              ),
              _buildPointSection(
                number: '7.',
                title: 'Pemutusan Kerjasama',
                body: 'myLaundry berhak untuk menghentikan kerjasama dengan kurir setiap saat jika ditemukan pelanggaran terhadap kode etik, standar pelayanan, atau pelanggaran hukum yang berlaku.',
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPointSection({
    required String number,
    required String title,
    String? body,
    List<String>? bullets,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number & Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                number,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1739),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B1739),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Body text or bullets list
          if (body != null)
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                body,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
          if (bullets != null)
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                children: bullets.map((bullet) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '•',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            bullet,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
