import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'data/services/auth_service.dart';
import 'data/services/order_service.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/order_repository.dart';
import 'ui/features/auth/view_models/auth_view_model.dart';
import 'ui/features/home/view_models/home_view_model.dart';
import 'ui/features/take_order/view_models/take_order_view_model.dart';
import 'ui/features/delivery/view_models/delivery_view_model.dart';
import 'ui/features/auth/views/login_view.dart';
import 'ui/features/home/views/home_view.dart';

void main() async {
  // Ensure Flutter bindings are initialized before calling SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();
  final authRepository = AuthRepository(authService: authService);
  
  final orderService = OrderService();
  final orderRepository = OrderRepository(orderService: orderService);
  
  // Initialize repository (loading stored local session credentials)
  await authRepository.init();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>.value(value: authService),
        Provider<OrderService>.value(value: orderService),
        Provider<AuthRepository>.value(value: authRepository),
        Provider<OrderRepository>.value(value: orderRepository),
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => AuthViewModel(authRepository: authRepository),
        ),
        ChangeNotifierProvider<HomeViewModel>(
          create: (_) => HomeViewModel(
            authRepository: authRepository,
            orderRepository: orderRepository,
          ),
        ),
        ChangeNotifierProvider<TakeOrderViewModel>(
          create: (_) => TakeOrderViewModel(
            authRepository: authRepository,
            orderRepository: orderRepository,
          ),
        ),
        ChangeNotifierProvider<DeliveryViewModel>(
          create: (_) => DeliveryViewModel(
            authRepository: authRepository,
            orderRepository: orderRepository,
          ),
        ),
      ],
      child: const CourierApp(),
    ),
  );
}

class CourierApp extends StatelessWidget {
  const CourierApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context, listen: false);

    return MaterialApp(
      title: 'myLaundry Courier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0007B0),
          primary: const Color(0xFF0007B0),
          secondary: const Color(0xFF0B1739),
          surface: const Color(0xFFF8F9FA),
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          ThemeData.light().textTheme,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: authRepository.isAuthenticated ? const HomeView() : const LoginView(),
    );
  }
}
