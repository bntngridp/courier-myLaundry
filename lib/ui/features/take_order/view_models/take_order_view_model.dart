import 'package:flutter/material.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/repositories/order_repository.dart';
import '../../../../domain/models/order.dart';

class InputItem {
  final String category; // "Cuci Lipat", "Cuci Satuan", "Cuci Setrika"
  final String serviceType; // "Reguler", "Ngebut", "Kilat", "Selimut", "Bedcover", etc.
  final double value; // weight in kg or count in pcs
  final double price; // unit price

  InputItem({
    required this.category,
    required this.serviceType,
    required this.value,
    required this.price,
  });

  double get totalPrice => price * value;

  String get valueSuffix {
    if (category == 'Cuci Satuan') {
      return '${value.toInt()} pcs';
    }
    return '${value.toStringAsFixed(1).replaceAll('.0', '')} kg';
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final String timestamp;
  final bool isAudio;
  final String? audioDuration;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.isAudio = false,
    this.audioDuration,
  });
}

class TakeOrderViewModel extends ChangeNotifier {
  final AuthRepository authRepository;
  final OrderRepository orderRepository;

  bool _isLoading = false;
  String? _errorMessage;
  bool _isAppActive = false;
  bool _isSearching = false;
  List<OrderModel> _availableOrders = [];
  OrderModel? _currentOrder;
  int _currentStep = 0; // 0: Off, 1: Searching, 2: Found List, 3: On the Way, 4: Input Order, 5: Payment, 6: Success

  List<InputItem> _inputItems = [];

  // Chat and Telephone Feature states
  final List<ChatMessage> _chatMessages = [
    ChatMessage(text: 'Mas udah dimana ya', isMe: false, timestamp: '10:36 am'),
    ChatMessage(text: 'saya udah di depan kos ya', isMe: false, timestamp: '10:36 am'),
  ];
  bool _isSpeakerOn = false;
  bool _isMuted = false;

  TakeOrderViewModel({
    required this.authRepository,
    required this.orderRepository,
  });

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAppActive => _isAppActive;
  bool get isSearching => _isSearching;
  List<OrderModel> get availableOrders => _availableOrders;
  OrderModel? get currentOrder => _currentOrder;
  int get currentStep => _currentStep;
  List<InputItem> get inputItems => _inputItems;

  List<ChatMessage> get chatMessages => _chatMessages;
  bool get isSpeakerOn => _isSpeakerOn;
  bool get isMuted => _isMuted;

  double get localTotalPrice {
    double total = 0;
    for (var item in _inputItems) {
      total += item.totalPrice;
    }
    return total;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void resetFlow() {
    _isSearching = false;
    _availableOrders = [];
    _currentOrder = null;
    _currentStep = 0;
    _isAppActive = false;
    _inputItems = [];
    notifyListeners();
  }

  void resumeActiveOrder(OrderModel order) {
    _isAppActive = true;
    _currentOrder = order;
    final status = order.status.toLowerCase();
    
    if (status == 'kurir on the way' || status == 'delivering') {
      _currentStep = 3; // On the way
    } else if (status == 'arrived - proses pembayaran') {
      _currentStep = 5; // Waiting payment
    } else {
      _currentStep = 3;
    }
    notifyListeners();
  }

  Future<void> toggleAppActivity(bool active) async {
    _isAppActive = active;
    if (active) {
      _currentStep = 1; // Searching screen
      _isSearching = true;
      notifyListeners();
      
      // Delay search slightly for premium feel
      await Future.delayed(const Duration(seconds: 2));
      await fetchAvailableOrders();
    } else {
      resetFlow();
    }
  }

  Future<void> fetchAvailableOrders() async {
    final token = authRepository.token;
    if (token == null) {
      _errorMessage = 'Sesi masuk kadaluarsa.';
      _currentStep = 0;
      _isAppActive = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final orders = await orderRepository.getOrders(available: true, token: token);
      _availableOrders = orders;
      _isSearching = false;
      _currentStep = 2; // List of unassigned orders
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isSearching = false;
      _currentStep = 0;
      _isAppActive = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> acceptOrder(OrderModel order) async {
    final token = authRepository.token;
    if (token == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedOrder = await orderRepository.acceptOrder(order.id, token);
      _currentOrder = updatedOrder;
      _currentStep = 3; // On the Way screen
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void goToInputOrder() {
    _currentStep = 4; // Input Order screen
    _inputItems = [];
    notifyListeners();
  }

  void goBackToOnTheWay() {
    _currentStep = 3;
    notifyListeners();
  }

  void addItemToLocalList(InputItem item) {
    _inputItems.add(item);
    notifyListeners();
  }

  void removeItemFromLocalList(int index) {
    if (index >= 0 && index < _inputItems.length) {
      _inputItems.removeAt(index);
      notifyListeners();
    }
  }

  double getPriceRate(String category, String serviceType) {
    if (category == 'Cuci Lipat') {
      if (serviceType == 'Reguler') return 7000;
      if (serviceType == 'Ngebut') return 10000;
      if (serviceType == 'Kilat') return 15000;
    } else if (category == 'Cuci Setrika') {
      if (serviceType == 'Reguler') return 8000;
      if (serviceType == 'Ngebut') return 9000;
      if (serviceType == 'Kilat') return 12000;
    } else if (category == 'Cuci Satuan') {
      if (serviceType == 'Selimut') return 15000;
      if (serviceType == 'Bedcover') return 25000;
      if (serviceType == 'Sprei') return 15000;
      if (serviceType == 'Kemeja') return 8000;
      if (serviceType == 'Jas') return 20000;
      if (serviceType == 'Kebaya') return 18000;
      if (serviceType == 'Dress') return 15000;
      if (serviceType == 'Karpet Bulu') return 30000;
      if (serviceType == 'Boneka(S)') return 10000;
      if (serviceType == 'Boneka(L)') return 20000;
    }
    return 0;
  }

  Future<bool> submitOrderDetails() async {
    final token = authRepository.token;
    if (token == null || _currentOrder == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Accumulate total weight and total quantity to submit to backend
    double totalWeight = 0;
    int totalQuantity = 0;

    for (var item in _inputItems) {
      if (item.category == 'Cuci Satuan') {
        totalQuantity += item.value.toInt();
      } else {
        totalWeight += item.value;
      }
    }

    try {
      final updatedOrder = await orderRepository.courierArrived(
        orderId: _currentOrder!.id,
        token: token,
        totalPrice: localTotalPrice,
        weight: totalWeight,
        quantity: totalQuantity,
      );
      _currentOrder = updatedOrder;
      _currentStep = 5; // Waiting Payment screen
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> processPayment() async {
    final token = authRepository.token;
    if (token == null || _currentOrder == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedOrder = await orderRepository.acceptCashPayment(_currentOrder!.id, token);
      _currentOrder = updatedOrder;
      _currentStep = 6; // Payment Success screen
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Chat & Phone Actions
  void sendChatMessage(String text) {
    if (text.trim().isEmpty) return;
    
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final ampm = now.hour >= 12 ? 'pm' : 'am';
    final minute = now.minute.toString().padLeft(2, '0');
    final timestamp = '$hour:$minute $ampm';

    _chatMessages.add(ChatMessage(text: text, isMe: true, timestamp: timestamp));
    notifyListeners();

    // Trigger mock reply after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      final nowReply = DateTime.now();
      final hourR = nowReply.hour > 12 ? nowReply.hour - 12 : (nowReply.hour == 0 ? 12 : nowReply.hour);
      final ampmR = nowReply.hour >= 12 ? 'pm' : 'am';
      final minuteR = nowReply.minute.toString().padLeft(2, '0');
      final timestampR = '$hourR:$minuteR $ampmR';
      
      _chatMessages.add(ChatMessage(
        text: 'Oke mas, ditunggu ya! 👍',
        isMe: false,
        timestamp: timestampR,
      ));
      notifyListeners();
    });
  }

  void sendVoiceMessage(String duration) {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final ampm = now.hour >= 12 ? 'pm' : 'am';
    final minute = now.minute.toString().padLeft(2, '0');
    final timestamp = '$hour:$minute $ampm';

    _chatMessages.add(
      ChatMessage(
        text: 'Pesan Suara',
        isMe: true,
        timestamp: timestamp,
        isAudio: true,
        audioDuration: duration,
      ),
    );
    notifyListeners();

    // Trigger mock reply after 2.5 seconds
    Future.delayed(const Duration(milliseconds: 2500), () {
      final nowReply = DateTime.now();
      final hourR = nowReply.hour > 12 ? nowReply.hour - 12 : (nowReply.hour == 0 ? 12 : nowReply.hour);
      final ampmR = nowReply.hour >= 12 ? 'pm' : 'am';
      final minuteR = nowReply.minute.toString().padLeft(2, '0');
      final timestampR = '$hourR:$minuteR $ampmR';

      _chatMessages.add(ChatMessage(
        text: 'Pesan Suara',
        isMe: false,
        timestamp: timestampR,
        isAudio: true,
        audioDuration: '00:06',
      ));
      notifyListeners();
    });
  }

  void toggleSpeaker() {
    _isSpeakerOn = !_isSpeakerOn;
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    notifyListeners();
  }
}
