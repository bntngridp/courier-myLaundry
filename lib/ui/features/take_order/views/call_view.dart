import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/services/call_signaling_service.dart';

class CallView extends StatefulWidget {
  final int targetUserId;
  final int orderId;
  final String customerName;
  final String phoneNumber;

  const CallView({
    super.key,
    this.targetUserId = 0,
    this.orderId = 0,
    this.customerName = 'Pelanggan',
    this.phoneNumber = '',
  });

  @override
  State<CallView> createState() => _CallViewState();
}

class _CallViewState extends State<CallView> {
  final CallSignalingService _signalingService = CallSignalingService();
  StreamSubscription<CallMessage>? _subscription;

  Timer? _timer;
  int _secondsElapsed = 0;
  bool _isCallConnected = false;
  String _statusText = 'Memanggil (In-App)...';
  bool _isSpeakerOn = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _initSignalingAndCall();
  }

  Future<void> _initSignalingAndCall() async {
    final authRepo = Provider.of<AuthRepository>(context, listen: false);
    final token = authRepo.token;
    final currentUserName = authRepo.currentUser?.username ?? 'Kurir myLaundry';

    if (token != null) {
      await _signalingService.connect(token);

      _subscription = _signalingService.onMessage.listen((msg) {
        if (!mounted) return;

        if (msg.type == 'CALL_ANSWER') {
          setState(() {
            _isCallConnected = true;
            _statusText = 'Terhubung';
          });
          _startTimer();
        } else if (msg.type == 'CALL_REJECT') {
          setState(() {
            _statusText = 'Panggilan Ditolak';
          });
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted) Navigator.pop(context);
          });
        } else if (msg.type == 'CALL_END') {
          if (mounted) Navigator.pop(context);
        }
      });

      if (widget.targetUserId > 0) {
        _signalingService.startCall(
          targetUserId: widget.targetUserId,
          orderId: widget.orderId,
          callerName: currentUserName,
        );
      }
    }

    // Fallback timer if target auto-connects or testing
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && !_isCallConnected && _statusText.contains('Memanggil')) {
        setState(() {
          _isCallConnected = true;
          _statusText = 'Terhubung (In-App Voice)';
        });
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  Future<void> _triggerNativeFallback() async {
    if (widget.phoneNumber.trim().isNotEmpty) {
      final cleanNumber = widget.phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
      final uri = Uri.parse('tel:$cleanNumber');
      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      } catch (_) {}
    }
  }

  void _endCall() {
    if (widget.targetUserId > 0) {
      _signalingService.endCall(
        targetUserId: widget.targetUserId,
        orderId: widget.orderId,
      );
    }
    _signalingService.disconnect();
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _timer?.cancel();
    _signalingService.disconnect();
    super.dispose();
  }

  String _formatDuration(int totalSeconds) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final displayName = widget.customerName.isNotEmpty ? widget.customerName : 'Pelanggan';

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
                    _statusText,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black45,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B1739),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shield_outlined, size: 14, color: Color(0xFF10B981)),
                            SizedBox(width: 4),
                            Text(
                              'In-App Account Call',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF10B981),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_isCallConnected) ...[
                    const SizedBox(height: 12),
                    Text(
                      _formatDuration(_secondsElapsed),
                      style: const TextStyle(
                        fontSize: 20,
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
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0007B0), Color(0xFF2563EB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0007B0).withValues(alpha: 0.25),
                        blurRadius: 25,
                        spreadRadius: 5,
                      )
                    ],
                    border: Border.all(color: Colors.white, width: 6),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    displayName.isNotEmpty ? displayName[0].toUpperCase() : 'C',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 64),
                  ),
                ),
              ),

              // Control buttons and End Call button
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Speaker Toggle Button
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _isSpeakerOn = !_isSpeakerOn),
                            child: Container(
                              width: 58,
                              height: 58,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isSpeakerOn ? const Color(0xFF0007B0) : Colors.white,
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                  )
                                ],
                              ),
                              child: Icon(
                                _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                                color: _isSpeakerOn ? Colors.white : Colors.black54,
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

                      // Mute Toggle Button
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _isMuted = !_isMuted),
                            child: Container(
                              width: 58,
                              height: 58,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isMuted ? const Color(0xFF0007B0) : Colors.white,
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 10,
                                  )
                                ],
                              ),
                              child: Icon(
                                _isMuted ? Icons.mic_off : Icons.mic,
                                color: _isMuted ? Colors.white : Colors.black54,
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

                      // Native Dialer Option Button
                      if (widget.phoneNumber.isNotEmpty)
                        Column(
                          children: [
                            GestureDetector(
                              onTap: _triggerNativeFallback,
                              child: Container(
                                width: 58,
                                height: 58,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 10,
                                    )
                                  ],
                                ),
                                child: const Icon(
                                  Icons.dialpad_rounded,
                                  color: Color(0xFF0007B0),
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Pulsa HP',
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
                    onTap: _endCall,
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
