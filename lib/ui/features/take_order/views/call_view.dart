import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/take_order_view_model.dart';

class CallView extends StatefulWidget {
  const CallView({super.key});

  @override
  State<CallView> createState() => _CallViewState();
}

class _CallViewState extends State<CallView> {
  Timer? _timer;
  int _secondsElapsed = 0;
  bool _isCallConnected = false;

  @override
  void initState() {
    super.initState();
    // Simulate call connecting after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isCallConnected = true;
        });
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(int totalSeconds) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TakeOrderViewModel>(context);
    final customerName = viewModel.currentOrder?.customer?.username ?? 'Nidu Askandar';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header text
              Column(
                children: [
                  const SizedBox(height: 48),
                  Text(
                    _isCallConnected ? 'Menghubungkan...' : 'Memanggil...',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black38,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    customerName,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B1739),
                    ),
                  ),
                  if (_isCallConnected) ...[
                    const SizedBox(height: 12),
                    Text(
                      _formatDuration(_secondsElapsed),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0007B0),
                      ),
                    ),
                  ],
                ],
              ),

              // Profile Image
              Center(
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 25,
                        spreadRadius: 5,
                      )
                    ],
                    border: Border.all(color: Colors.white, width: 6),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=120',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Control buttons and End Call button
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Speaker Toggle Button
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => viewModel.toggleSpeaker(),
                            child: Container(
                              width: 58,
                              height: 58,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: viewModel.isSpeakerOn
                                    ? const Color(0xFF0007B0)
                                    : Colors.white,
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                  )
                                ],
                              ),
                              child: Icon(
                                viewModel.isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                                color: viewModel.isSpeakerOn ? Colors.white : Colors.black54,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Sepiker',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 48),
                      // Mute Toggle Button
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => viewModel.toggleMute(),
                            child: Container(
                              width: 58,
                              height: 58,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: viewModel.isMuted
                                    ? const Color(0xFF0007B0)
                                    : Colors.white,
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                  )
                                ],
                              ),
                              child: Icon(
                                viewModel.isMuted ? Icons.mic_off : Icons.mic,
                                color: viewModel.isMuted ? Colors.white : Colors.black54,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Bisukan',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  // Hang Up Button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.redAccent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent,
                            blurRadius: 15,
                            spreadRadius: -2,
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.call_end,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
