import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/services/auth_service.dart';
import 'data/repositories/auth_repository.dart';
import 'ui/features/auth/view_models/auth_view_model.dart';
import 'ui/features/auth/views/login_view.dart';

void main() async {
  // Ensure Flutter bindings are initialized before calling SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();
  final authRepository = AuthRepository(authService: authService);
  
  // Initialize repository (loading stored local session credentials)
  await authRepository.init();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>.value(value: authService),
        Provider<AuthRepository>.value(value: authRepository),
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => AuthViewModel(authRepository: authRepository),
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
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const LoginView(),
    );
  }
}
