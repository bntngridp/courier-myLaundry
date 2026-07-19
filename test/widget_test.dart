import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:courier_mylaundry/main.dart';
import 'package:courier_mylaundry/data/services/auth_service.dart';
import 'package:courier_mylaundry/data/repositories/auth_repository.dart';
import 'package:courier_mylaundry/ui/features/auth/view_models/auth_view_model.dart';

void main() {
  testWidgets('Courier App Initial UI Test', (WidgetTester tester) async {
    final authService = AuthService();
    final authRepository = AuthRepository(authService: authService);

    // Build our app and trigger a frame.
    await tester.pumpWidget(
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

    // Verify that the login screen elements are displayed
    expect(find.text('Masuk'), findsWidgets);
    expect(find.text('Email atau Nomor Telepon'), findsOneWidget);
  });
}
