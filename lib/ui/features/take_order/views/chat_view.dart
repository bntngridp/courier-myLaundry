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

  @override
  void dispose() {
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
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
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
                      child: Column(
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
              child: Row(
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
                              decoration: const InputDecoration(
                                hintText: 'Obrolan pesan bisa diisi ya...',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
