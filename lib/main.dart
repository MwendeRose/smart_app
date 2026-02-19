// lib/main.dart
import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'screens/login_page.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Restore saved session before first frame
  await AuthService.instance.init();
  runApp(const MajiSmartApp());
}

class MajiSmartApp extends StatelessWidget {
  const MajiSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maji Smart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2DD4BF),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Inter', // optional — remove if not configured
      ),
      home: const _AuthGate(),
    );
  }
}

/// Listens to AuthService and swaps between LoginPage and HomeScreen.
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthService.instance,
      builder: (context, _) {
        return AuthService.instance.isLoggedIn
            ? const HomeScreen()
            : const LoginPage();
      },
    );
  }
}