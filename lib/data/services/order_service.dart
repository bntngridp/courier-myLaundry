import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OrderService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8085/api';
    }
    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:8085/api';
      }
    } catch (_) {
      // Platform check can fail in web unit tests
    }
    return 'http://localhost:8085/api';
  }

  final http.Client _client;

  OrderService({http.Client? client}) : _client = client ?? http.Client();

  Future<http.Response> getOrders({bool available = false, required String token}) async {
    final queryParams = available ? '?available=true' : '';
    final url = Uri.parse('$baseUrl/orders/$queryParams');
    return await _client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> acceptOrder(int orderId, String token) async {
    final url = Uri.parse('$baseUrl/orders/accept/$orderId');
    return await _client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> courierArrived({required int orderId, required String token}) async {
    final url = Uri.parse('$baseUrl/orders/courier-arrived');
    return await _client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'order_id': orderId,
      }),
    );
  }

  Future<http.Response> acceptCashPayment({required int orderId, required String token}) async {
    final url = Uri.parse('$baseUrl/orders/accept-cash-payment');
    return await _client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'order_id': orderId,
      }),
    );
  }
}
