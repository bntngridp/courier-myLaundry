import 'package:flutter/material.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/repositories/order_repository.dart';
import '../../../../domain/models/order.dart';

class TakeOrderViewModel extends ChangeNotifier {
  final AuthRepository authRepository;
  final OrderRepository orderRepository;

  bool _isLoading = false;
  String? _errorMessage;
  bool _isAppActive = false;
  bool _isSearching = false;
  List<OrderModel> _availableOrders = [];
  OrderModel? _currentOrder;
  int _currentStep = 0; // 0: Off, 1: Searching, 2: Found List, 3: On the Way, 4: Payment, 5: Success

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
    notifyListeners();
  }

  void resumeActiveOrder(OrderModel order) {
    _isAppActive = true;
    _currentOrder = order;
    final status = order.status.toLowerCase();
    
    if (status == 'kurir on the way' || status == 'delivering') {
      _currentStep = 3; // On the way
    } else if (status == 'arrived - proses pembayaran') {
      _currentStep = 4; // Waiting payment
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

  Future<bool> markArrived() async {
    final token = authRepository.token;
    if (token == null || _currentOrder == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedOrder = await orderRepository.courierArrived(_currentOrder!.id, token);
      _currentOrder = updatedOrder;
      _currentStep = 4; // Waiting Payment screen
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
      _currentStep = 5; // Payment Success screen
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
}
