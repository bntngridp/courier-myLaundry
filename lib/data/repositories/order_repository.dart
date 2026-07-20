import 'dart:convert';
import '../../domain/models/order.dart';
import '../services/order_service.dart';

class OrderRepository {
  final OrderService orderService;

  OrderRepository({required this.orderService});

  Future<List<OrderModel>> getOrders({bool available = false, required String token}) async {
    final response = await orderService.getOrders(available: available, token: token);
    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      final List<dynamic> data = body['data'] ?? [];
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } else {
      final msg = body['message'] ?? 'Gagal mengambil data pesanan';
      throw Exception(msg);
    }
  }

  Future<OrderModel> acceptOrder(int orderId, String token) async {
    final response = await orderService.acceptOrder(orderId, token);
    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      return OrderModel.fromJson(body['data']);
    } else {
      final msg = body['message'] ?? 'Gagal mengambil pesanan';
      throw Exception(msg);
    }
  }

  Future<OrderModel> courierArrived({
    required int orderId,
    required String token,
    double? totalPrice,
    double? weight,
    int? quantity,
  }) async {
    final response = await orderService.courierArrived(
      orderId: orderId,
      token: token,
      totalPrice: totalPrice,
      weight: weight,
      quantity: quantity,
    );
    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      return OrderModel.fromJson(body['data']);
    } else {
      final msg = body['message'] ?? 'Gagal memperbarui status kedatangan';
      throw Exception(msg);
    }
  }

  Future<OrderModel> acceptCashPayment(int orderId, String token) async {
    final response = await orderService.acceptCashPayment(orderId: orderId, token: token);
    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      return OrderModel.fromJson(body['data']);
    } else {
      final msg = body['message'] ?? 'Gagal memproses pembayaran tunai';
      throw Exception(msg);
    }
  }

  Future<OrderModel> startDelivery(int orderId, String token) async {
    final response = await orderService.startDelivery(orderId, token);
    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      return OrderModel.fromJson(body['data']);
    } else {
      final msg = body['message'] ?? 'Gagal memulai pengantaran kembali';
      throw Exception(msg);
    }
  }

  Future<bool> updateOrderStatus(int orderId, String status, String token) async {
    final response = await orderService.updateOrderStatus(orderId, status, token);
    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      final msg = body['message'] ?? 'Gagal memperbaharui status pesanan';
      throw Exception(msg);
    }
  }
}
