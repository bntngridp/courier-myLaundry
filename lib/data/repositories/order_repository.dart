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

  Future<OrderModel> courierArrived(int orderId, String token) async {
    final response = await orderService.courierArrived(orderId: orderId, token: token);
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
}
