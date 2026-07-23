import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/delivery_view_model.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../take_order/views/chat_view.dart';
import '../../take_order/views/call_view.dart';

class DeliveryView extends StatefulWidget {
  const DeliveryView({super.key});

  @override
  State<DeliveryView> createState() => _DeliveryViewState();
}

class _DeliveryViewState extends State<DeliveryView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DeliveryViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(context, viewModel),
      body: SafeArea(
        child: _buildBodyByStep(context, viewModel),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context, DeliveryViewModel viewModel) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF0B1739)),
        onPressed: () {
          if (viewModel.currentStep == 1) {
            viewModel.goBackToRouteStep();
          } else if (viewModel.currentStep == 2) {
            viewModel.retakeImage();
          } else {
            Navigator.pop(context);
          }
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
      centerTitle: true,
    );
  }

  String _getAppBarTitle(int step) {
    switch (step) {
      case 0:
        return 'Pengantaran Kembali';
      case 1:
        return 'Bukti';
      case 2:
        return '(Template) Bukti';
      default:
        return 'Pengantaran';
    }
  }

  Widget _buildBodyByStep(BuildContext context, DeliveryViewModel viewModel) {
    switch (viewModel.currentStep) {
      case 0:
        return _buildStepOnTheWay(context, viewModel);
      case 1:
        return _buildStepUpload(context, viewModel);
      case 2:
        return _buildStepComplete(context, viewModel);
      default:
        return _buildStepOnTheWay(context, viewModel);
    }
  }

  // STEP 0: On the Way Map View
  Widget _buildStepOnTheWay(BuildContext context, DeliveryViewModel viewModel) {
    final order = viewModel.currentOrder;
    final address = order?.address;

    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _MockMapPainter(),
          ),
        ),
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
                        'Alamat Pengantaran',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        address?.receiverName ?? 'Nidu Askandar',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B1739),
                        ),
                      ),
                      Text(
                        address?.fullAddress ?? 'Jl. Sukapura No. 1, Bandung',
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
                const Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'Anda akan tiba dalam ',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                      children: [
                        TextSpan(
                          text: '4 Menit',
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
                ElevatedButton(
                  onPressed: () => viewModel.goToUploadStep(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0007B0),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Telah Sampai',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ChatView()),
                          );
                        },
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
                                  enabled: false,
                                  decoration: InputDecoration(
                                    hintText: 'Kirimkan pesan bisa diisi ya...',
                                    hintStyle: TextStyle(color: Colors.black38, fontSize: 13),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.send, color: Color(0xFF0007B0), size: 18),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ChatView()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CallView()),
                        );
                      },
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE6F0FF),
                        ),
                        child: const Icon(Icons.phone, color: Color(0xFF0007B0), size: 22),
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

  // STEP 1: Upload Proof
  Widget _buildStepUpload(BuildContext context, DeliveryViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: Text(
              'Foto Bukti Pengantaran',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B1739),
              ),
            ),
          ),
          const SizedBox(height: 36),
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Simulate camera photo upload with a mock image URL
                viewModel.setUploadedImage(
                  'https://images.unsplash.com/photo-1545155998-0c67ff433434?auto=format&fit=crop&q=80&w=300',
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF1F5F9),
                      ),
                      child: const Icon(Icons.add, color: Colors.black38, size: 36),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  // STEP 2: Proof Preview & Complete Order
  Widget _buildStepComplete(BuildContext context, DeliveryViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: Text(
              'Foto Bukti Pengantaran',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B1739),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Laundry Image Frame
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                image: viewModel.uploadedImagePath != null
                    ? DecorationImage(
                        image: NetworkImage(viewModel.uploadedImagePath!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () => viewModel.retakeImage(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0007B0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
              ),
              child: const Text('Ambil ulang', style: TextStyle(color: Colors.white, fontSize: 13)),
            ),
          ),
          const SizedBox(height: 36),
          ElevatedButton(
            onPressed: viewModel.isLoading
                ? null
                : () async {
                    final success = await viewModel.completeDelivery();
                    if (success && context.mounted) {
                      AppSnackBar.showSuccess(context, 'Pengantaran berhasil diselesaikan');
                      Navigator.pop(context);
                    } else if (context.mounted && viewModel.errorMessage != null) {
                      AppSnackBar.showError(context, viewModel.errorMessage!);
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
            child: viewModel.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Text(
                    'Selesai',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
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
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final streetPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 24.0;

    canvas.drawLine(Offset(size.width * 0.2, 0), Offset(size.width * 0.2, size.height), streetPaint);
    canvas.drawLine(Offset(size.width * 0.5, 0), Offset(size.width * 0.5, size.height), streetPaint);
    canvas.drawLine(Offset(size.width * 0.8, 0), Offset(size.width * 0.8, size.height), streetPaint);
    
    canvas.drawLine(Offset(0, size.height * 0.25), Offset(size.width, size.height * 0.25), streetPaint);
    canvas.drawLine(Offset(0, size.height * 0.6), Offset(size.width, size.height * 0.6), streetPaint);
    canvas.drawLine(Offset(0, size.height * 0.85), Offset(size.width, size.height * 0.85), streetPaint);

    final routePaint = Paint()
      ..color = const Color(0xFF0007B0)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8.0;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.85)
      ..lineTo(size.width * 0.2, size.height * 0.6)
      ..lineTo(size.width * 0.8, size.height * 0.6)
      ..lineTo(size.width * 0.8, size.height * 0.25);
    
    canvas.drawPath(path, routePaint);

    final startPinPaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;

    final endPinPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.85), 14, startPinPaint);
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.85), 6, Paint()..color = Colors.white);

    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.25), 14, endPinPaint);
    canvas.drawCircle(Offset(size.width * 0.8, size.height * 0.25), 6, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
