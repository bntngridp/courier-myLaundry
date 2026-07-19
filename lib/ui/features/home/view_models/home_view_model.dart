import 'package:flutter/material.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/repositories/order_repository.dart';
import '../../../../domain/models/order.dart';

class HomeViewModel extends ChangeNotifier {
  final AuthRepository authRepository;
  final OrderRepository orderRepository;

  bool _isLoading = false;
  String? _errorMessage;
  OrderModel? _activeOrder;

  HomeViewModel({
    required this.authRepository,
    required this.orderRepository,
  });

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  OrderModel? get activeOrder => _activeOrder;
  bool get hasActiveOrder => _activeOrder != null;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> checkActiveOrder() async {
    final token = authRepository.token;
    if (token == null) {
      _activeOrder = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final orders = await orderRepository.getOrders(available: false, token: token);
      
      // Find any order that is currently in progress
      _activeOrder = null;
      for (var order in orders) {
        final status = order.status.toLowerCase();
        if (status == 'kurir on the way' ||
            status == 'arrived - proses pembayaran' ||
            status == 'delivering' ||
            status == 'waiting for courier approval') {
          // If the order has this courier's ID and is active
          if (order.courier?.id == authRepository.currentUser?.id && status != 'waiting for courier approval') {
            _activeOrder = order;
            break;
          }
        }
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      _activeOrder = null;
      notifyListeners();
    }
  }
}
