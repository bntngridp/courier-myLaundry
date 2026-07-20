import 'package:flutter/material.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../data/repositories/order_repository.dart';
import '../../../../domain/models/order.dart';

class DeliveryViewModel extends ChangeNotifier {
  final AuthRepository authRepository;
  final OrderRepository orderRepository;

  bool _isLoading = false;
  String? _errorMessage;
  OrderModel? _currentOrder;
  int _currentStep = 0; // 0: On the Way (Map), 1: Upload Bukti, 2: Bukti Template/Completed Success
  String? _uploadedImagePath;

  DeliveryViewModel({
    required this.authRepository,
    required this.orderRepository,
  });

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  OrderModel? get currentOrder => _currentOrder;
  int get currentStep => _currentStep;
  String? get uploadedImagePath => _uploadedImagePath;

  void reset() {
    _currentStep = 0;
    _currentOrder = null;
    _uploadedImagePath = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  void goToUploadStep() {
    _currentStep = 1;
    notifyListeners();
  }

  void goBackToRouteStep() {
    _currentStep = 0;
    notifyListeners();
  }

  void setUploadedImage(String path) {
    _uploadedImagePath = path;
    _currentStep = 2; // Move to preview/complete step
    notifyListeners();
  }

  void retakeImage() {
    _uploadedImagePath = null;
    _currentStep = 1; // Back to upload step
    notifyListeners();
  }

  Future<bool> startDeliveryFlow(OrderModel order) async {
    final token = authRepository.token;
    if (token == null) return false;

    _isLoading = true;
    _errorMessage = null;
    _currentOrder = order;
    notifyListeners();

    try {
      // Check if order is already delivering, if so just keep it. Otherwise call API.
      if (order.status.toLowerCase() != 'delivering') {
        final updatedOrder = await orderRepository.startDelivery(order.id, token);
        _currentOrder = updatedOrder;
      }
      _currentStep = 0;
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

  Future<bool> completeDelivery() async {
    final token = authRepository.token;
    if (token == null || _currentOrder == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await orderRepository.updateOrderStatus(_currentOrder!.id, 'completed', token);
      if (success) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        throw Exception('Gagal memperbaharui status ke selesai');
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
