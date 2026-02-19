// lib/screens/login_page.dart
// ignore_for_file: deprecated_member_use, unnecessary_underscores

import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  // Tabs: 0 = Login, 1 = Sign Up
  int _tab = 0;
  late TabController _tabCtrl;

  // Login form
  final _loginEmail    = TextEditingController();
  final _loginPassword = TextEditingController();
  bool _loginObscure   = true;

  // Sign-up form
  final _signupName     = TextEditingController();
  final _signupEmail    = TextEditingController();
  final _signupPhone    = TextEditingController();
  final _signupPassword = TextEditingController();
  final _signupConfirm  = TextEditingController();
  bool _signupObscure   = true;

  String? _error;

  final _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(() => setState(() { _tab = _tabCtrl.index; _error = null; }));
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _loginEmail.dispose(); _loginPassword.dispose();
    _signupName.dispose(); _signupEmail.dispose();
    _signupPhone.dispose(); _signupPassword.dispose(); _signupConfirm.dispose();
    super.dispose();
  }

  // ── Actions ───────────────────────────────────────────────

  Future<void> _doLogin() async {
    setState(() => _error = null);
    if (_loginEmail.text.trim().isEmpty || _loginPassword.text.isEmpty) {
      setState(() => _error = 'Please enter your email and password.');
      return;
    }
    final err = await _auth.login(
      email: _loginEmail.text.trim(),
      password: _loginPassword.text,
    );
    if (err != null && mounted) setState(() => _error = err);
    // If no error, AuthService notifies — main.dart will swap to HomeScreen
  }

  Future<void> _doSignup() async {
    setState(() => _error = null);
    if (_signupName.text.trim().isEmpty ||
        _signupEmail.text.trim().isEmpty ||
        _signupPassword.text.isEmpty) {
      setState(() => _error = 'Name, email and password are required.');
      return;
    }
    if (_signupPassword.text != _signupConfirm.text) {
      setState(() => _error = 'Passwords do not match.');
      return;
    }
    final err = await _auth.signUp(
      name:     _signupName.text.trim(),
      email:    _signupEmail.text.trim(),
      password: _signupPassword.text,
      phone:    _signupPhone.text.trim(),
    );
    if (err != null && mounted) setState(() => _error = err);
  }

  // ── UI ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Logo / Branding ───────────────────────
                  Center(
                    child: Column(children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2DD4BF),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF2DD4BF).withOpacity(0.4),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.water_drop_rounded,
                            color: Colors.white, size: 34),
                      ),
                      const SizedBox(height: 14),
                      const Text('Maji Smart',
                          style: TextStyle(
                              color: Color(0xFFE6EDF3),
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5)),
                      const SizedBox(height: 4),
                      const Text('Borehole Monitoring System',
                          style: TextStyle(
                              color: Color(0xFF8B949E), fontSize: 13)),
                    ]),
                  ),

                  const SizedBox(height: 36),

                  // ── Tab bar ───────────────────────────────
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B22),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF30363D)),
                    ),
                    child: TabBar(
                      controller: _tabCtrl,
                      indicator: BoxDecoration(
                        color: const Color(0xFF2DD4BF).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color(0xFF2DD4BF).withOpacity(0.5)),
                      ),
                      labelColor: const Color(0xFF2DD4BF),
                      unselectedLabelColor: const Color(0xFF8B949E),
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13),
                      dividerColor: Colors.transparent,
                      tabs: const [Tab(text: 'Sign In'), Tab(text: 'Sign Up')],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Error banner ──────────────────────────
                  if (_error != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0x33FF6B6B),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFF6B6B).withOpacity(0.4)),
                      ),
                      child: Row(children: [
                        const Icon(Icons.error_outline,
                            color: Color(0xFFFF6B6B), size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(_error!,
                              style: const TextStyle(
                                  color: Color(0xFFFF6B6B), fontSize: 12)),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ── Forms ─────────────────────────────────
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: _tab == 0 ? _loginForm() : _signupForm(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Login form ────────────────────────────────────────────

  Widget _loginForm() {
    return Column(
      key: const ValueKey('login'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Field(
          controller: _loginEmail,
          label: 'Email',
          hint: 'you@example.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        _Field(
          controller: _loginPassword,
          label: 'Password',
          hint: '••••••••',
          icon: Icons.lock_outline,
          obscure: _loginObscure,
          suffix: IconButton(
            icon: Icon(_loginObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: const Color(0xFF8B949E), size: 18),
            onPressed: () => setState(() => _loginObscure = !_loginObscure),
          ),
        ),
        const SizedBox(height: 24),
        ListenableBuilder(
          listenable: _auth,
          builder: (_, __) => _PrimaryButton(
            label: 'Sign In',
            loading: _auth.loading,
            onPressed: _doLogin,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: GestureDetector(
            onTap: () => _tabCtrl.animateTo(1),
            child: const Text(
              "Don't have an account? Sign Up",
              style: TextStyle(color: Color(0xFF2DD4BF), fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  // ── Sign-up form ──────────────────────────────────────────

  Widget _signupForm() {
    return Column(
      key: const ValueKey('signup'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Field(
          controller: _signupName,
          label: 'Full Name',
          hint: 'John Kamau',
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 14),
        _Field(
          controller: _signupEmail,
          label: 'Email',
          hint: 'you@example.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        _Field(
          controller: _signupPhone,
          label: 'Phone (optional)',
          hint: '+254 7XX XXX XXX',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 14),
        _Field(
          controller: _signupPassword,
          label: 'Password',
          hint: 'Min. 6 characters',
          icon: Icons.lock_outline,
          obscure: _signupObscure,
          suffix: IconButton(
            icon: Icon(_signupObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: const Color(0xFF8B949E), size: 18),
            onPressed: () => setState(() => _signupObscure = !_signupObscure),
          ),
        ),
        const SizedBox(height: 14),
        _Field(
          controller: _signupConfirm,
          label: 'Confirm Password',
          hint: 'Repeat password',
          icon: Icons.lock_outline,
          obscure: _signupObscure,
        ),
        const SizedBox(height: 24),
        ListenableBuilder(
          listenable: _auth,
          builder: (_, __) => _PrimaryButton(
            label: 'Create Account',
            loading: _auth.loading,
            onPressed: _doSignup,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: GestureDetector(
            onTap: () => _tabCtrl.animateTo(0),
            child: const Text(
              'Already have an account? Sign In',
              style: TextStyle(color: Color(0xFF2DD4BF), fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Reusable widgets ──────────────────────────────────────────

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffix;

  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.keyboardType,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Color(0xFF8B949E),
                fontSize: 12,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: const TextStyle(color: Color(0xFFE6EDF3), fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF484F58), fontSize: 13),
            prefixIcon: Icon(icon, color: const Color(0xFF8B949E), size: 18),
            suffixIcon: suffix,
            filled: true,
            fillColor: const Color(0xFF161B22),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF30363D)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF30363D)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF2DD4BF), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2DD4BF),
          disabledBackgroundColor: const Color(0xFF2DD4BF).withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15)),
      ),
    );
  }
}