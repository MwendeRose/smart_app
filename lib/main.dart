// lib/main.dart
// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_app/screens/firebase_options.dart';
import 'services/auth_service.dart';
import 'screens/welcome_page.dart';
import 'screens/login_page.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AuthService.instance.init();
  runApp(const MajiSmartApp());
}

class MajiSmartApp extends StatelessWidget {
  const MajiSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart_meter_app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2DD4BF),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Inter',
      ),
      home: const _AuthGate(),
    );
  }
}

/// ─── Routing ─────────────────────────────────────────────────
///
///  First install  →  WelcomePage  →  LoginPage  →  HomeScreen
///  Return visit   →  LoginPage    →  HomeScreen
///  Already authed →  HomeScreen
///
class _AuthGate extends StatefulWidget {
  const _AuthGate();
  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  bool _loading     = true;
  bool _seenWelcome = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _seenWelcome = prefs.getBool('seen_welcome') ?? false;
      _loading     = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const _Splash();

    // ① First ever launch — show welcome BEFORE anything else,
    //   even if Firebase already has a saved session.
    if (!_seenWelcome) return const WelcomePage();

    // ② Welcome already seen — now check auth state
    return ListenableBuilder(
      listenable: AuthService.instance,
      builder: (_, __) {
        if (AuthService.instance.isLoggedIn) return const HomeScreen();
        return const LoginPage();
      },
    );
  }
}

/// Branded splash while SharedPreferences loads (~100–200 ms)
class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060F3D),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo container
            Container(
              width: 140, height: 68,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFFAA00).withOpacity(0.5), width: 2),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 28, offset: const Offset(0, 8)),
                  BoxShadow(color: const Color(0xFFFFAA00).withOpacity(0.2), blurRadius: 40),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  'assets/Logo.pdf',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFF0D0D0D),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('>',
                            style: TextStyle(
                              color: Color(0xFFFFAA00),
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                            )),
                        SizedBox(width: 8),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('SNAPP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2.5,
                                )),
                            Text('AFRICA',
                                style: TextStyle(
                                  color: Color(0xFFFFAA00),
                                  fontSize: 8,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 3,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Color(0xFFFFAA00),
              ),
            ),
          ],
        ),
      ),
    );
  }
}