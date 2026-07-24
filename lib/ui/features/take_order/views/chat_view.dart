import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/take_order_view_model.dart';
import 'call_view.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isRecording = false;
  int _recordSeconds = 0;
  Timer? _timer;
  int? _playingIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordSeconds = 0;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted) {
        setState(() {
          _recordSeconds++;
        });
      }
    });
  }

  void _stopAndSendRecording(TakeOrderViewModel viewModel) {
    _timer?.cancel();
    final durationStr = _formatDuration(_recordSeconds);
    setState(() {
      _isRecording = false;
      _recordSeconds = 0;
    });
    viewModel.sendVoiceMessage(durationStr);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _cancelRecording() {
    _timer?.cancel();
    setState(() {
      _isRecording = false;
      _recordSeconds = 0;
    });
  }

  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TakeOrderViewModel>(context);
    final customerName = viewModel.currentOrder?.customer?.username ?? 'Nidu Askandar';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0B1739)),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF0007B0), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                customerName.isNotEmpty ? customerName[0].toUpperCase() : 'C',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              customerName,
              style: const TextStyle(
                color: Color(0xFF0B1739),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat bubble list
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(20),
                itemCount: viewModel.chatMessages.length,
                itemBuilder: (context, index) {
                  final message = viewModel.chatMessages[index];
                  final isMe = message.isMe;

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.78,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isMe ? const Color(0xFF0007B0) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isMe ? 16 : 0),
                          bottomRight: Radius.circular(isMe ? 0 : 16),
                        ),
                      ),
                      child: message.isAudio
                          ? _buildAudioBubble(message, index, isMe)
                          : Column(
                              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.text,
                                  style: TextStyle(
                                    color: isMe ? Colors.white : const Color(0xFF0B1739),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  message.timestamp,
                                  style: TextStyle(
                                    color: isMe ? Colors.white60 : Colors.black38,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),
            ),

            // Bottom input bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  )
                ],
              ),
              child: _isRecording
                  ? _buildRecordingBar(viewModel)
                  : _buildStandardInputBar(viewModel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioBubble(ChatMessage message, int index, bool isMe) {
    final isPlaying = _playingIndex == index;
    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (_playingIndex == index) {
                    _playingIndex = null;
                  } else {
                    _playingIndex = index;
                  }
                });
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isMe ? Colors.white : const Color(0xFF0007B0),
                ),
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: isMe ? const Color(0xFF0007B0) : Colors.white,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Audio Waveform Visualization
            Row(
              children: List.generate(12, (i) {
                final heights = [12.0, 22.0, 16.0, 28.0, 10.0, 24.0, 18.0, 30.0, 14.0, 20.0, 26.0, 12.0];
                final h = heights[i % heights.length];
                final active = isPlaying && (i % 3 == 0);
                return Container(
                  width: 3,
                  height: active ? h + 4 : h,
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  decoration: BoxDecoration(
                    color: isMe
                        ? (active ? Colors.white : Colors.white70)
                        : (active ? const Color(0xFF0007B0) : Colors.black26),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
            const SizedBox(width: 10),
            Text(
              message.audioDuration ?? '00:05',
              style: TextStyle(
                color: isMe ? Colors.white : const Color(0xFF0B1739),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          message.timestamp,
          style: TextStyle(
            color: isMe ? Colors.white60 : Colors.black38,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildRecordingBar(TakeOrderViewModel viewModel) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444), size: 24),
          onPressed: _cancelRecording,
          tooltip: 'Batal Rekam',
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDuration(_recordSeconds),
                  style: const TextStyle(
                    color: Color(0xFF991B1B),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(8, (i) {
                      final h = (i % 2 == 0) ? 14.0 : 22.0;
                      return Container(
                        width: 3,
                        height: h,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => _stopAndSendRecording(viewModel),
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF0007B0),
            ),
            child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildStandardInputBar(TakeOrderViewModel viewModel) {
    return Row(
      children: [
        // Text field input
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
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Ketik pesan atau rekam suara...',
                      hintStyle: TextStyle(color: Colors.black38, fontSize: 13),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        viewModel.sendChatMessage(value);
                        _messageController.clear();
                        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                      }
                    },
                  ),
                ),
                if (_messageController.text.trim().isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF0007B0), size: 18),
                    onPressed: () {
                      final text = _messageController.text;
                      if (text.trim().isNotEmpty) {
                        viewModel.sendChatMessage(text);
                        _messageController.clear();
                        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                      }
                    },
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.mic_rounded, color: Color(0xFF0007B0), size: 22),
                    onPressed: _startRecording,
                    tooltip: 'Rekam Suara',
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Telephone floating action style button
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
              color: Color(0xFF0007B0),
            ),
            child: const Icon(Icons.phone, color: Colors.white, size: 22),
          ),
        ),
      ],
    );
  }
}
