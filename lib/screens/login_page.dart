// lib/screens/login_page.dart
// ignore_for_file: deprecated_member_use, unnecessary_underscores, unused_field, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _mode = 0; // 0 = Sign In, 1 = Sign Up

  final _loginEmail    = TextEditingController();
  final _loginPassword = TextEditingController();
  bool _loginObscure   = true;

  final _signupFirstName = TextEditingController();
  final _signupLastName  = TextEditingController();
  final _signupEmail     = TextEditingController();
  final _signupPassword  = TextEditingController();
  bool _acceptTerms      = false;

  final _signupPhone   = TextEditingController();
  final _signupConfirm = TextEditingController();
  bool _signupObscure  = true;

  String? _error;
  bool _googleLoading = false;

  final _auth = AuthService.instance;

  // ── Bright, clean palette ─────────────────────────────────
  static const kPageBg    = Color(0xFFF0F4FF);   // light blue-grey page
  static const kPanelLeft = Color(0xFF1B4FD8);   // vibrant royal blue (left panel)
  static const kPanelL2   = Color(0xFF1A3CC8);
  static const kPanelL3   = Color(0xFF0E2FA8);
  static const kAmber     = Color(0xFFFFAA00);   // Snapp Africa orange
  static const kWhite     = Color(0xFFFFFFFF);
  static const kOffWhite  = Color(0xFFF8FAFF);
  static const kBorder    = Color(0xFFDDE3F0);
  static const kText      = Color(0xFF111827);
  static const kSubtext   = Color(0xFF6B7280);
  static const kFieldBg   = Color(0xFFF9FAFB);
  static const kError     = Color(0xFFEF4444);
  static const kBlack     = Color(0xFF0D0D0D);
  static const kTeal      = Color(0xFF0891B2);

  @override
  void dispose() {
    _loginEmail.dispose(); _loginPassword.dispose();
    _signupFirstName.dispose(); _signupLastName.dispose();
    _signupEmail.dispose(); _signupPassword.dispose();
    _signupPhone.dispose(); _signupConfirm.dispose();
    super.dispose();
  }

  Future<void> _doLogin() async {
    final email = _loginEmail.text.trim();
    final password = _loginPassword.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Please enter your email and password.');
      return;
    }
    setState(() => _error = null);
    final err = await _auth.login(email: email, password: password);
    if (err != null && mounted) setState(() => _error = err);
  }

  Future<void> _doSignup() async {
    final first = _signupFirstName.text.trim();
    final last  = _signupLastName.text.trim();
    final email = _signupEmail.text.trim();
    final password = _signupPassword.text;
    if (first.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _error = 'First name, email and password are required.');
      return;
    }
    if (!email.contains('@')) {
      setState(() => _error = 'Please enter a valid email address.');
      return;
    }
    if (password.length < 6) {
      setState(() => _error = 'Password must be at least 6 characters.');
      return;
    }
    if (!_acceptTerms) {
      setState(() => _error = 'Please accept the Terms & Conditions.');
      return;
    }
    setState(() => _error = null);
    final err = await _auth.signUp(
        name: '$first $last', email: email, password: password, phone: '');
    if (err != null && mounted) setState(() => _error = err);
  }

  Future<void> _doGoogleSignIn() async {
    setState(() { _error = null; _googleLoading = true; });
    final err = await _auth.signInWithGoogle();
    if (mounted) setState(() { _googleLoading = false; _error = err; });
  }

  Future<void> _doForgotPassword() async {
    final emailCtrl = TextEditingController(text: _loginEmail.text.trim());
    String? sheetError;
    bool sent = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kWhite,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) {
          Future<void> send() async {
            setSheet(() => sheetError = null);
            final err = await _auth.resetPassword(email: emailCtrl.text.trim());
            if (err != null) setSheet(() => sheetError = err);
            else setSheet(() => sent = true);
          }

          return Padding(
            padding: EdgeInsets.only(
                left: 24, right: 24, top: 24,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: Container(
                  width: 36, height: 4,
                  decoration: BoxDecoration(
                      color: kBorder, borderRadius: BorderRadius.circular(2)),
                )),
                const SizedBox(height: 20),
                if (!sent) ...[
                  const Text('Reset Password',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kText, fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  const Text("Enter your email and we'll send a reset link.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kSubtext, fontSize: 13)),
                  const SizedBox(height: 20),
                  if (sheetError != null) ...[
                    _ErrBox(message: sheetError!), const SizedBox(height: 12),
                  ],
                  _OutlineField(controller: emailCtrl, hint: 'Email address',
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  ListenableBuilder(
                    listenable: _auth,
                    builder: (_, _) => _DarkBtn(label: 'Send Reset Link',
                        loading: _auth.loading, onPressed: send),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel',
                        style: TextStyle(color: kSubtext, fontSize: 13)),
                  ),
                ] else ...[
                  const Icon(Icons.mark_email_read_rounded, color: kTeal, size: 48),
                  const SizedBox(height: 14),
                  const Text('Check your inbox!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kText, fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 20),
                  SizedBox(height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kText,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: const Text('Done',
                          style: TextStyle(color: kWhite, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // BUILD
  // ════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPageBg,
      body: Container(
        // Bright light page background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEBF0FF), Color(0xFFF5F7FF), Color(0xFFE8EEFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: _buildCard(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── The split card ────────────────────────────────────────

  Widget _buildCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B4FD8).withOpacity(0.18),
            blurRadius: 50,
            spreadRadius: 2,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(width: 280, child: _buildHeroPanel()),
              Expanded(child: _buildFormPanel()),
            ],
          ),
        ),
      ),
    );
  }

  // ── LEFT: Bright blue hero panel ─────────────────────────

  Widget _buildHeroPanel() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1B4FD8),  // bright royal blue
            Color(0xFF1A44C2),
            Color(0xFF1238A8),
            Color(0xFF0E2D90),  // deeper blue at bottom
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Subtle light blobs for depth — NOT dark circles
          Positioned(top: -50, right: -50,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kWhite.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(bottom: -60, left: -40,
            child: Container(
              width: 220, height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kWhite.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(top: 120, right: 10,
            child: Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kAmber.withOpacity(0.12),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 30, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // ── LOGO on WHITE background so it's fully visible ──
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 148, height: 60,
                      decoration: BoxDecoration(
                        // WHITE background — logo (black bg, orange chevron) is now clearly visible
                        color: kWhite,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/logo.jpeg',
                          fit: BoxFit.contain,
                          // Fallback: drawn Snapp Africa logo (no empty circle)
                          errorBuilder: (_, __, ___) => Container(
                            color: kBlack,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '>',
                                  style: TextStyle(
                                    color: kAmber,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                    fontStyle: FontStyle.italic,
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text('SNAPP',
                                        style: TextStyle(
                                          color: kWhite,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 2,
                                          height: 1,
                                        )),
                                    Text('AFRICA',
                                        style: TextStyle(
                                          color: kAmber,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 3,
                                          height: 1.4,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Smart Meter ·  Borehole Monitoring',
                      style: TextStyle(
                        color: kWhite.withOpacity(0.55),
                        fontSize: 9,
                        letterSpacing: 0.3,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // ── Welcome copy + Snapp Africa footer ──
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _mode == 0 ? 'Welcome\nback.' : 'Create your\nAccount',
                      style: const TextStyle(
                        color: kWhite,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _mode == 0
                          ? 'Monitor boreholes in\nreal-time across Africa.'
                          : 'Monitor boreholes and\nmanage water smartly.',
                      style: TextStyle(
                        color: kWhite.withOpacity(0.7),
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // ── Powered by Snapp Africa strip ──
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 9),
                      decoration: BoxDecoration(
                        color: kWhite.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: kAmber.withOpacity(0.35), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Amber chevron icon
                          const Text('>',
                              style: TextStyle(
                                color: kAmber,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                                height: 1,
                              )),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Powered by Snapp Africa',
                                  style: TextStyle(
                                    color: kWhite.withOpacity(0.92),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.2,
                                  )),
                              Text('The last mile provider for mobile & web',
                                  style: TextStyle(
                                    color: kWhite.withOpacity(0.5),
                                    fontSize: 7.5,
                                    fontStyle: FontStyle.italic,
                                    letterSpacing: 0.1,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── RIGHT: White form panel ───────────────────────────────

  Widget _buildFormPanel() {
    return Container(
      color: kWhite,
      padding: const EdgeInsets.fromLTRB(36, 36, 36, 36),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        transitionBuilder: (child, anim) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04), end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
            child: child,
          ),
        ),
        child: _mode == 0
            ? _signInForm(key: const ValueKey('signin'))
            : _signUpForm(key: const ValueKey('signup')),
      ),
    );
  }

  // ── Sign-In Form ──────────────────────────────────────────

  Widget _signInForm({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Sign In',
            style: TextStyle(color: kText, fontSize: 26,
                fontWeight: FontWeight.w900, letterSpacing: -0.3)),
        const SizedBox(height: 4),
        const Text('Welcome back to Smart Meter App',
            style: TextStyle(color: kSubtext, fontSize: 13)),
        const SizedBox(height: 24),

        if (_error != null) ...[
          _ErrBox(message: _error!, onClose: () => setState(() => _error = null)),
          const SizedBox(height: 14),
        ],

        _OutlineField(controller: _loginEmail, hint: 'Email address',
            keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 10),
        _OutlineField(
          controller: _loginPassword, hint: 'Password',
          obscure: _loginObscure,
          suffix: IconButton(
            icon: Icon(_loginObscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
                color: kSubtext, size: 18),
            onPressed: () => setState(() => _loginObscure = !_loginObscure),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: _doForgotPassword,
            child: const Text('Forgot password?',
                style: TextStyle(color: kSubtext, fontSize: 12,
                    fontWeight: FontWeight.w500)),
          ),
        ),
        const SizedBox(height: 20),

        ListenableBuilder(
          listenable: _auth,
          builder: (_, __) => _DarkBtn(label: 'Sign in  →',
              loading: _auth.loading, onPressed: _doLogin),
        ),
        const SizedBox(height: 16),
        _OrDivider(),
        const SizedBox(height: 16),

        _SocialBtn(label: 'Sign in with Google', icon: _googleGIcon(),
            onPressed: _googleLoading ? null : _doGoogleSignIn,
            loading: _googleLoading, dark: false),
        const SizedBox(height: 10),
        _SocialBtn(label: 'Sign in with Apple',
            icon: const Icon(Icons.apple, color: kWhite, size: 18),
            onPressed: () {}, dark: true),

        const SizedBox(height: 20),
        Center(
          child: GestureDetector(
            onTap: () => setState(() { _mode = 1; _error = null; }),
            child: RichText(
              text: const TextSpan(
                text: "Don't have an account?  ",
                style: TextStyle(color: kSubtext, fontSize: 13),
                children: [
                  TextSpan(text: 'Sign up',
                      style: TextStyle(color: kPanelLeft,
                          fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Sign-Up Form ──────────────────────────────────────────

  Widget _signUpForm({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Sign Up',
            style: TextStyle(color: kText, fontSize: 26,
                fontWeight: FontWeight.w900, letterSpacing: -0.3)),
        const SizedBox(height: 4),
        const Text('Create your Maji Smart account',
            style: TextStyle(color: kSubtext, fontSize: 13)),
        const SizedBox(height: 24),

        if (_error != null) ...[
          _ErrBox(message: _error!, onClose: () => setState(() => _error = null)),
          const SizedBox(height: 14),
        ],

        Row(children: [
          Expanded(child: _OutlineField(
              controller: _signupFirstName, hint: 'First name')),
          const SizedBox(width: 10),
          Expanded(child: _OutlineField(
              controller: _signupLastName, hint: 'Last name')),
        ]),
        const SizedBox(height: 10),
        _OutlineField(controller: _signupEmail, hint: 'Email address',
            keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 10),
        _OutlineField(
          controller: _signupPassword, hint: 'Password',
          obscure: _signupObscure,
          suffix: IconButton(
            icon: Icon(_signupObscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
                color: kSubtext, size: 18),
            onPressed: () => setState(() => _signupObscure = !_signupObscure),
          ),
        ),
        const SizedBox(height: 12),

        GestureDetector(
          onTap: () => setState(() => _acceptTerms = !_acceptTerms),
          child: Row(
            children: [
              SizedBox(width: 18, height: 18,
                child: Checkbox(
                  value: _acceptTerms,
                  onChanged: (v) => setState(() => _acceptTerms = v ?? false),
                  activeColor: kPanelLeft,
                  side: const BorderSide(color: kBorder, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(width: 8),
              const Text('Accept Terms & Conditions',
                  style: TextStyle(color: kSubtext, fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 18),

        ListenableBuilder(
          listenable: _auth,
          builder: (_, __) => _DarkBtn(label: 'Join us  →',
              loading: _auth.loading, onPressed: _doSignup),
        ),
        const SizedBox(height: 16),
        _OrDivider(),
        const SizedBox(height: 16),

        _SocialBtn(label: 'Sign up with Google', icon: _googleGIcon(),
            onPressed: _googleLoading ? null : _doGoogleSignIn,
            loading: _googleLoading, dark: false),
        const SizedBox(height: 10),
        _SocialBtn(label: 'Sign up with Apple',
            icon: const Icon(Icons.apple, color: kWhite, size: 18),
            onPressed: () {}, dark: true),

        const SizedBox(height: 20),
        Center(
          child: GestureDetector(
            onTap: () => setState(() { _mode = 0; _error = null; }),
            child: RichText(
              text: const TextSpan(
                text: 'Already have an account?  ',
                style: TextStyle(color: kSubtext, fontSize: 13),
                children: [
                  TextSpan(text: 'Sign in',
                      style: TextStyle(color: kPanelLeft,
                          fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _googleGIcon() {
    return SizedBox(
      width: 18, height: 18,
      child: Center(
        child: Text('G',
          style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w900,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: [Color(0xFF4285F4), Color(0xFF34A853)],
              ).createShader(const Rect.fromLTWH(0, 0, 18, 18)),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// SHARED HELPER WIDGETS
// ════════════════════════════════════════════════════════════════

class _OutlineField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffix;

  const _OutlineField({
    required this.controller, required this.hint,
    this.obscure = false, this.keyboardType, this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: _LoginPageState.kText, fontSize: 13.5),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
            color: _LoginPageState.kSubtext, fontSize: 13.5),
        suffixIcon: suffix,
        filled: true,
        fillColor: _LoginPageState.kFieldBg,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
              color: _LoginPageState.kBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
              color: _LoginPageState.kBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
              color: _LoginPageState.kPanelLeft, width: 1.8),
        ),
      ),
    );
  }
}

class _DarkBtn extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onPressed;
  const _DarkBtn({required this.label, required this.loading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _LoginPageState.kText,
          disabledBackgroundColor: _LoginPageState.kText.withOpacity(0.35),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: loading
            ? const SizedBox(width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
            : Text(label,
                style: const TextStyle(
                  color: _LoginPageState.kWhite,
                  fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: 0.2,
                )),
      ),
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback? onPressed;
  final bool dark;
  final bool loading;
  const _SocialBtn({
    required this.label, required this.icon, required this.onPressed,
    this.dark = false, this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: dark
          ? ElevatedButton.icon(
              onPressed: onPressed, icon: icon,
              label: Text(label, style: const TextStyle(
                  color: _LoginPageState.kWhite,
                  fontWeight: FontWeight.w600, fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _LoginPageState.kBlack,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: loading
                  ? const SizedBox(width: 18, height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: _LoginPageState.kText))
                  : icon,
              label: Text(label, style: const TextStyle(
                  color: _LoginPageState.kText,
                  fontWeight: FontWeight.w600, fontSize: 13)),
              style: OutlinedButton.styleFrom(
                backgroundColor: _LoginPageState.kWhite,
                side: const BorderSide(color: _LoginPageState.kBorder, width: 1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Expanded(child: Divider(color: _LoginPageState.kBorder, thickness: 1)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text('or', style: const TextStyle(
            color: _LoginPageState.kSubtext, fontSize: 12)),
      ),
      const Expanded(child: Divider(color: _LoginPageState.kBorder, thickness: 1)),
    ]);
  }
}

class _ErrBox extends StatelessWidget {
  final String message;
  final VoidCallback? onClose;
  const _ErrBox({required this.message, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: _LoginPageState.kError.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _LoginPageState.kError.withOpacity(0.4)),
      ),
      child: Row(children: [
        const Icon(Icons.error_outline, color: _LoginPageState.kError, size: 15),
        const SizedBox(width: 8),
        Expanded(child: Text(message, style: const TextStyle(
            color: _LoginPageState.kError, fontSize: 12))),
        if (onClose != null)
          GestureDetector(onTap: onClose,
              child: const Icon(Icons.close,
                  color: _LoginPageState.kError, size: 15)),
      ]),
    );
  }
}