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
  int _tab = 0;
  late TabController _tabCtrl;

  final _loginEmail    = TextEditingController();
  final _loginPassword = TextEditingController();
  bool _loginObscure   = true;

  final _signupName     = TextEditingController();
  final _signupEmail    = TextEditingController();
  final _signupPhone    = TextEditingController();
  final _signupPassword = TextEditingController();
  final _signupConfirm  = TextEditingController();
  bool _signupObscure   = true;

  String? _error;

  final _auth = AuthService();

  // ── Brand palette ─────────────────────────────────────────
  static const kPrimary    = Color(0xFF00B4D8); // vivid sky blue
  static const kAccent     = Color(0xFFFF6B35); // energetic orange
  static const kSurface    = Color(0xFF0A1628); // deep navy
  static const kCard       = Color(0xFF112240); // card navy
  static const kBorder     = Color(0xFF1E3A5F); // subtle border
  static const kText       = Color(0xFFE8F4FD); // near-white
  static const kSubtext    = Color(0xFF7BAFD4); // muted blue-grey
  static const kError      = Color(0xFFFF4757);

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(() => setState(() {
      _tab = _tabCtrl.index;
      _error = null;
    }));
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _loginEmail.dispose(); _loginPassword.dispose();
    _signupName.dispose(); _signupEmail.dispose();
    _signupPhone.dispose(); _signupPassword.dispose();
    _signupConfirm.dispose();
    super.dispose();
  }

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

  Future<void> _doGoogleSignIn() async {
    setState(() => _error = null);
    final err = await _auth.signInWithGoogle();
    if (err != null && mounted) setState(() => _error = err);
  }
  Future<void> _doForgotPassword() async {
    final emailCtrl = TextEditingController(text: _loginEmail.text.trim());
    String? sheetError;
    bool sent = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheet) {
            Future<void> send() async {
              setSheet(() { sheetError = null; });
              final err = await _auth.resetPassword(email: emailCtrl.text.trim());
              if (err != null) {
                setSheet(() => sheetError = err);
              } else {
                setSheet(() => sent = true);
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 24, right: 24, top: 28,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 28,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Handle ─────────────────────────────────
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: kBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (!sent) ...[
                    // ── Icon ───────────────────────────────────
                    Center(
                      child: Container(
                        width: 60, height: 60,
                        decoration: BoxDecoration(
                          color: kPrimary.withOpacity(0.12),
                          shape: BoxShape.circle,
                          border: Border.all(color: kPrimary.withOpacity(0.3)),
                        ),
                        child: const Icon(Icons.lock_reset_rounded,
                            color: kPrimary, size: 28),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Forgot Password?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: kText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Enter your email and we\'ll send you a link to reset your password.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kSubtext, fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 24),

                    // ── Error ──────────────────────────────────
                    if (sheetError != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: kError.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: kError.withOpacity(0.4)),
                        ),
                        child: Row(children: [
                          const Icon(Icons.error_outline,
                              color: kError, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(sheetError!,
                                style: const TextStyle(
                                    color: kError, fontSize: 12)),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // ── Email field ────────────────────────────
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Email Address',
                            style: TextStyle(
                                color: kSubtext,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 7),
                        TextField(
                          controller: emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: kText, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'you@example.com',
                            hintStyle: const TextStyle(
                                color: Color(0xFF3D5A7A), fontSize: 13),
                            prefixIcon: const Icon(Icons.email_outlined,
                                color: kSubtext, size: 18),
                            filled: true,
                            fillColor: kSurface,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: kBorder),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: kBorder),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: kPrimary, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── Send button ────────────────────────────
                    ListenableBuilder(
                      listenable: _auth,
                      builder: (_, __) => SizedBox(
                        height: 50,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: _auth.loading
                                ? null
                                : const LinearGradient(
                                    colors: [kPrimary, Color(0xFF0077B6)],
                                  ),
                            color: _auth.loading
                                ? kPrimary.withOpacity(0.3)
                                : null,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: _auth.loading
                                ? []
                                : [
                                    BoxShadow(
                                      color: kPrimary.withOpacity(0.4),
                                      blurRadius: 16,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                          ),
                          child: ElevatedButton(
                            onPressed: _auth.loading ? null : send,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              disabledBackgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: _auth.loading
                                ? const SizedBox(
                                    width: 22, height: 22,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white),
                                  )
                                : const Text('Send Reset Link',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Cancel ─────────────────────────────────
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel',
                          style: TextStyle(color: kSubtext, fontSize: 13)),
                    ),
                  ] else ...[
                    // ── Success state ──────────────────────────
                    Center(
                      child: Container(
                        width: 72, height: 72,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00C896).withOpacity(0.12),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFF00C896).withOpacity(0.4),
                              width: 2),
                        ),
                        child: const Icon(Icons.mark_email_read_rounded,
                            color: Color(0xFF00C896), size: 34),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Check your inbox!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: kText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A password reset link has been sent to\n${emailCtrl.text.trim()}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: kSubtext, fontSize: 13, height: 1.5),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Check your spam folder if you don\'t see it within a minute.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xFF4A7A9B), fontSize: 11),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimary.withOpacity(0.15),
                          foregroundColor: kPrimary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text('Back to Sign In',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSurface,
      body: Stack(
        children: [
          // ── Decorative background blobs ───────────────────
          Positioned(
            top: -80,
            right: -80,
            child: _Blob(color: kPrimary.withOpacity(0.18), size: 280),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: _Blob(color: kAccent.withOpacity(0.12), size: 220),
          ),
          Positioned(
            top: 200,
            left: -40,
            child: _Blob(color: kPrimary.withOpacity(0.08), size: 160),
          ),

          // ── Main content ──────────────────────────────────
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildBranding(),
                      const SizedBox(height: 32),
                      _buildTabBar(),
                      const SizedBox(height: 20),
                      if (_error != null) ...[
                        _buildErrorBanner(),
                        const SizedBox(height: 16),
                      ],
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.05, 0),
                              end: Offset.zero,
                            ).animate(anim),
                            child: child,
                          ),
                        ),
                        child: _tab == 0 ? _loginForm() : _signupForm(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranding() {
    return Center(
      child: Column(
        children: [
          // ── Logo from assets ───────────────────────────────
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: kPrimary.withOpacity(0.35),
                  blurRadius: 32,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.asset(
                'assets/logo.jpeg',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [kPrimary, Color(0xFF0077B6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(Icons.water_drop_rounded,
                      color: Colors.white, size: 40),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [kPrimary, Color(0xFF48CAE4)],
            ).createShader(bounds),
            child: const Text(
              'Maji Smart',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: kAccent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kAccent.withOpacity(0.4)),
            ),
            child: const Text(
              'Borehole Monitoring System',
              style: TextStyle(color: kAccent, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
      ),
      child: TabBar(
        controller: _tabCtrl,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [kPrimary, Color(0xFF0077B6)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: kPrimary.withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: kSubtext,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        dividerColor: Colors.transparent,
        tabs: const [Tab(text: 'Sign In'), Tab(text: 'Sign Up')],
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: kError.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kError.withOpacity(0.5)),
      ),
      child: Row(children: [
        const Icon(Icons.error_outline, color: kError, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(_error!,
              style: const TextStyle(color: kError, fontSize: 12)),
        ),
      ]),
    );
  }

  Widget _loginForm() {
    return Column(
      key: const ValueKey('login'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Field(
          controller: _loginEmail,
          label: 'Email Address',
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
            icon: Icon(
              _loginObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: kSubtext, size: 18,
            ),
            onPressed: () => setState(() => _loginObscure = !_loginObscure),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _doForgotPassword,
            child: const Text('Forgot password?',
                style: TextStyle(color: kPrimary, fontSize: 12)),
          ),
        ),
        const SizedBox(height: 8),
        ListenableBuilder(
          listenable: _auth,
          builder: (_, __) => _GradientButton(
            label: 'Sign In',
            loading: _auth.loading,
            onPressed: _doLogin,
          ),
        ),
        const SizedBox(height: 16),
        _OrDivider(),
        const SizedBox(height: 16),
        _GoogleButton(onPressed: _doGoogleSignIn),
        const SizedBox(height: 20),
        Center(
          child: GestureDetector(
            onTap: () => _tabCtrl.animateTo(1),
            child: RichText(
              text: const TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(color: kSubtext, fontSize: 13),
                children: [
                  TextSpan(text: 'Sign Up', style: TextStyle(color: kPrimary, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

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
          label: 'Email Address',
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
            icon: Icon(
              _signupObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: kSubtext, size: 18,
            ),
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
          builder: (_, __) => _GradientButton(
            label: 'Create Account',
            loading: _auth.loading,
            onPressed: _doSignup,
          ),
        ),
        const SizedBox(height: 16),
        _OrDivider(),
        const SizedBox(height: 16),
        _GoogleButton(onPressed: _doGoogleSignIn),
        const SizedBox(height: 20),
        Center(
          child: GestureDetector(
            onTap: () => _tabCtrl.animateTo(0),
            child: RichText(
              text: const TextSpan(
                text: 'Already have an account? ',
                style: TextStyle(color: kSubtext, fontSize: 13),
                children: [
                  TextSpan(text: 'Sign In', style: TextStyle(color: kPrimary, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Decorative blob ───────────────────────────────────────────

class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  const _Blob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

// ── Or divider ────────────────────────────────────────────────

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Divider(color: _LoginPageState.kBorder, thickness: 1)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text('or continue with',
            style: TextStyle(color: _LoginPageState.kSubtext, fontSize: 11)),
      ),
      Expanded(child: Divider(color: _LoginPageState.kBorder, thickness: 1)),
    ]);
  }
}

// ── Google Sign-In button ─────────────────────────────────────

class _GoogleButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _GoogleButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: _LoginPageState.kCard,
          side: const BorderSide(color: _LoginPageState.kBorder, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google "G" logo using colored text (no package needed)
            Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  'G',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [Color(0xFF4285F4), Color(0xFF34A853)],
                      ).createShader(const Rect.fromLTWH(0, 0, 22, 22)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Continue with Google',
              style: TextStyle(
                color: _LoginPageState.kText,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Text field ────────────────────────────────────────────────

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
                color: _LoginPageState.kSubtext,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3)),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: const TextStyle(color: _LoginPageState.kText, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF3D5A7A), fontSize: 13),
            prefixIcon: Icon(icon, color: _LoginPageState.kSubtext, size: 18),
            suffixIcon: suffix,
            filled: true,
            fillColor: _LoginPageState.kCard,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _LoginPageState.kBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _LoginPageState.kBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _LoginPageState.kPrimary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Gradient primary button ───────────────────────────────────

class _GradientButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onPressed;

  const _GradientButton({
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: loading
              ? null
              : const LinearGradient(
                  colors: [_LoginPageState.kPrimary, Color(0xFF0077B6)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          color: loading ? _LoginPageState.kPrimary.withOpacity(0.3) : null,
          borderRadius: BorderRadius.circular(12),
          boxShadow: loading
              ? []
              : [
                  BoxShadow(
                    color: _LoginPageState.kPrimary.withOpacity(0.45),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: loading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: loading
              ? const SizedBox(
                  width: 22, height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                )
              : Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      letterSpacing: 0.4)),
        ),
      ),
    );
  }
}