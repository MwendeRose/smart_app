// lib/screens/welcome_page.dart
// ignore_for_file: deprecated_member_use, unused_element, unnecessary_underscores

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

// ─── Colour palette ──────────────────────────────────────────
const _kWhite      = Color(0xFFFFFFFF);
const _kBg         = Color(0xFFF8FBFF);
const _kBgAlt      = Color(0xFFEFF5FF);
const _kBlue       = Color(0xFF1A4FD6);
const _kBlueBright = Color(0xFF2563EB);
const _kBlueSoft   = Color(0xFFE0ECFF);
const _kAmber      = Color(0xFFFFAA00);
const _kAmberBg    = Color(0xFFFFF8E6);
const _kText       = Color(0xFF0D1726);
const _kTextMid    = Color(0xFF2C3A55);
const _kSubtext    = Color(0xFF5A6A85);
const _kBorder     = Color(0xFFD0DBEE);
const _kGreen      = Color(0xFF10B981);

const _benefitAccents = [
  Color(0xFF2563EB), Color(0xFFD97706), Color(0xFFDC2626),
  Color(0xFF059669), Color(0xFF7C3AED),
];
const _benefitBgs = [
  Color(0xFFEFF6FF), Color(0xFFFFFBEB), Color(0xFFFEF2F2),
  Color(0xFFECFDF5), Color(0xFFF5F3FF),
];

class _Benefit {
  final String subline, headline, story, proof;
  const _Benefit({required this.subline, required this.headline,
      required this.story, required this.proof});
}

const _benefits = [
  _Benefit(
    subline: '24/7 borehole visibility',
    headline: 'See Everything, From Anywhere',
    story: 'Open the app and instantly see how much water you have, whether the pump is running, and how much has been used today — no matter where you are.',
    proof: 'Live updates every 30 seconds',
  ),
  _Benefit(
    subline: 'Remote pump management',
    headline: 'Control Your Pump With One Tap',
    story: 'Switch the pump on or off from anywhere. Set schedules so it runs automatically — saving electricity and ensuring water is always ready when you need it.',
    proof: 'Pump responds in under 2 seconds',
  ),
  _Benefit(
    subline: 'Instant problem detection',
    headline: 'Get Warned Before Things Go Wrong',
    story: 'Burst pipe. Tank overflow. Pump failure. Smart Meter App detects problems the moment they happen and alerts you immediately — before damage is done.',
    proof: 'Alerts delivered in under 1 second',
  ),
  _Benefit(
    subline: 'Usage analytics & reporting',
    headline: 'Stop Wasting Water and Money',
    story: 'Simple daily and monthly charts show exactly where every litre goes. Spot leaks early and understand your patterns so billing is never a surprise.',
    proof: 'Full usage history included',
  ),
  _Benefit(
    subline: 'Multi-user access control',
    headline: 'Your Whole Team, On the Same Page',
    story: 'Add your caretaker, manager, and accountant — each with the right access level. Everyone sees what they need, and you stay in control of everything.',
    proof: 'Unlimited members, 3 permission levels',
  ),
];

const _howSteps = [
  ['1', 'Install the smart meter', 'A small device attaches to your borehole in about an hour. Works with most existing setups across Kenya.'],
  ['2', 'Download Smart Meter App', 'Available on Android and iOS. Log in and your borehole appears live on the dashboard instantly.'],
  ['3', 'Monitor, control and relax', 'Set your alerts, configure pump schedules, and let Smart Meter App handle the rest — 24/7.'],
];

const _testimonials = [
  ['"I used to visit my properties twice a week to check water. Now I do it from my phone at breakfast."', 'James M.', 'Property Manager, Nairobi'],
  ['"We caught a leak that would have wasted thousands of litres. The alert came at night and we fixed it by morning."', 'Grace W.', 'School Administrator, Kiambu'],
  ['"Tenants stopped complaining because we know about problems before they do."', 'David K.', 'Estate Owner, Mombasa'],
];

// ═══════════════════════════════════════════════════════════════
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin {
  int    _activeBenefit = 0;
  Timer? _benefitTimer;

  late final AnimationController _entryCtrl;
  late final Animation<double>   _entryFade;
  late final Animation<Offset>   _entrySlide;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _entryFade  = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _entrySlide = Tween<Offset>(begin: const Offset(0, 0.025), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));
    WidgetsBinding.instance.addPostFrameCallback((_) => _entryCtrl.forward());
    _benefitTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted) setState(() => _activeBenefit = (_activeBenefit + 1) % _benefits.length);
    });
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _benefitTimer?.cancel();
    super.dispose();
  }

  Future<void> _goToLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_welcome', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (_, __, ___) => const LoginPage(),
      transitionsBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: FadeTransition(
        opacity: _entryFade,
        child: SlideTransition(
          position: _entrySlide,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHero(),
                _buildBenefits(),
                _buildHowItWorks(),
                _buildTestimonials(),
                _buildCTA(),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  //  HERO
  // ────────────────────────────────────────────────────────────
  Widget _buildHero() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEAF1FF), Color(0xFFF4F8FF), _kWhite],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // ── 1. Logo bar — white card, logo centred ─────────
            Container(
              width: double.infinity,
              color: _kWhite,
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
              child: Column(
                children: [
                  // Logo — large and centred
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                          maxWidth: 220, maxHeight: 70),
                      child: Image.asset(
                        'assets/Logo.png',
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                        isAntiAlias: true,
                        errorBuilder: (_, __, ___) => const _TextLogoBlue(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Powered-by sub-line
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 6, height: 6,
                        decoration: const BoxDecoration(
                            color: _kGreen, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Powered by Snapp Africa',
                        style: TextStyle(
                          color: _kSubtext,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // thin accent line
            Container(
              height: 3,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1D4ED8), Color(0xFF2563EB), Color(0xFF3B82F6)],
                ),
              ),
            ),

            // ── 2. Welcome banner ──────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1D4ED8), Color(0xFF2563EB), Color(0xFF3B82F6)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _kAmber,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'WELCOME',
                          style: TextStyle(
                            color: Color(0xFF3D2000),
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Your water, under control',
                        style: TextStyle(
                          color: _kWhite.withOpacity(0.7),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Headline
                  const Text(
                    'Welcome to Smart Meter App',
                    style: TextStyle(
                      color: _kWhite,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Clear welcome paragraph
                  Text(
                    'Smart Meter App is your all-in-one borehole management platform built for '
                    'Kenyan property owners and estate managers. Monitor your water supply in '
                    'real time, control your pump remotely, detect leaks instantly, and '
                    'generate accurate tenant bills — all from your phone, wherever you are.',
                    style: TextStyle(
                      color: _kWhite.withOpacity(0.88),
                      fontSize: 13,
                      height: 1.72,
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _goToLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _kAmber,
                            foregroundColor: const Color(0xFF3D2000),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Get Started Free',
                            style: TextStyle(
                              color: Color(0xFF3D2000),
                              fontSize: 13.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _goToLogin,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _kWhite,
                            side: BorderSide(
                                color: _kWhite.withOpacity(0.55), width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: _kWhite,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── 3. Meter image LEFT + explanation RIGHT ────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LEFT — meter image card
                  Container(
                    width: 175,
                    height: 228,
                    decoration: BoxDecoration(
                      color: _kWhite,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                          color: const Color(0xFFD4E3FF), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: _kBlueBright.withOpacity(0.12),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/meter.png',
                            width: 175,
                            height: 228,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high,
                            errorBuilder: (_, __, ___) =>
                                const _MeterPlaceholder(),
                          ),
                        ),
                        // LIVE badge
                        Positioned(
                          top: 10, right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _kGreen,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: _kGreen.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 5, height: 5,
                                  decoration: const BoxDecoration(
                                      color: _kWhite,
                                      shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'LIVE',
                                  style: TextStyle(
                                    color: _kWhite, fontSize: 8.5,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20),

                  // RIGHT — brief explanation
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _kAmberBg,
                            border: Border.all(
                                color: _kAmber.withOpacity(0.4)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.sensors_rounded,
                                  size: 11, color: _kAmber),
                              SizedBox(width: 5),
                              Text(
                                'THE DEVICE',
                                style: TextStyle(
                                  color: Color(0xFF7A4A00), fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Meet the\nSmart Meter',
                          style: TextStyle(
                            color: _kText, fontSize: 20,
                            fontWeight: FontWeight.w900, height: 1.22,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'A compact IoT device that clips onto your borehole pipe and streams live water data to your phone every 30 seconds — over GSM or 4G. No site visits. No guesswork.',
                          style: TextStyle(
                            color: _kSubtext, fontSize: 12.5, height: 1.7,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _BulletPoint(
                          icon: Icons.wifi_tethering_rounded,
                          color: _kBlueBright,
                          text: 'Live data every 30 seconds',
                        ),
                        const SizedBox(height: 9),
                        _BulletPoint(
                          icon: Icons.bolt_rounded,
                          color: _kAmber,
                          text: 'Remote pump control in under 2s',
                        ),
                        const SizedBox(height: 9),
                        _BulletPoint(
                          icon: Icons.notifications_active_rounded,
                          color: _kGreen,
                          text: 'Instant leak & fault alerts',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  //  BENEFITS
  // ────────────────────────────────────────────────────────────
  Widget _buildBenefits() {
    final b      = _benefits[_activeBenefit];
    final accent = _benefitAccents[_activeBenefit];
    final bgTint = _benefitBgs[_activeBenefit];

    return Container(
      color: _kBg,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 44),
      child: Column(
        children: [
          _SectionPill('WHY SMART METER APP'),
          const SizedBox(height: 14),
          const Text(
            'Built for people who can\'t\nafford water problems',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _kText, fontSize: 22, fontWeight: FontWeight.w900,
              letterSpacing: -0.3, height: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_benefits.length, (i) {
                final active    = i == _activeBenefit;
                final tabAccent = _benefitAccents[i];
                return GestureDetector(
                  onTap: () => setState(() => _activeBenefit = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 9),
                    decoration: BoxDecoration(
                      color: active ? tabAccent : _kWhite,
                      border: Border.all(
                        color: active ? tabAccent : _kBorder,
                        width: active ? 2 : 1.5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: active
                          ? [BoxShadow(
                              color: tabAccent.withOpacity(0.22),
                              blurRadius: 10, offset: const Offset(0, 4))]
                          : [],
                    ),
                    child: Text(
                      _tabLabel(i),
                      style: TextStyle(
                        color: active ? _kWhite : _kSubtext,
                        fontSize: 12,
                        fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 18),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                        begin: const Offset(0.04, 0), end: Offset.zero)
                    .animate(CurvedAnimation(
                        parent: anim, curve: Curves.easeOut)),
                child: child,
              ),
            ),
            child: Container(
              key: ValueKey(_activeBenefit),
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: bgTint,
                border: Border.all(
                    color: accent.withOpacity(0.22), width: 1.5),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: accent.withOpacity(0.08),
                    blurRadius: 16, offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    b.subline.toUpperCase(),
                    style: TextStyle(
                      color: accent, fontSize: 10,
                      fontWeight: FontWeight.w800, letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    b.headline,
                    style: const TextStyle(
                      color: _kText, fontSize: 19,
                      fontWeight: FontWeight.w900, letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.only(left: 12),
                    decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(color: accent, width: 3)),
                    ),
                    child: Text(
                      b.story,
                      style: const TextStyle(
                          color: _kTextMid, fontSize: 13.5, height: 1.75),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      b.proof,
                      style: const TextStyle(
                          color: _kWhite, fontSize: 12,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_benefits.length, (i) {
              final active = i == _activeBenefit;
              return GestureDetector(
                onTap: () => setState(() => _activeBenefit = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 22 : 7, height: 7,
                  decoration: BoxDecoration(
                    color: active ? _benefitAccents[i] : _kBorder,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _tabLabel(int i) =>
      ['Monitor', 'Control', 'Alerts', 'Save', 'Team'][i];

  // ────────────────────────────────────────────────────────────
  //  HOW IT WORKS
  // ────────────────────────────────────────────────────────────
  Widget _buildHowItWorks() {
    return Container(
      color: _kWhite,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 44),
      child: Column(
        children: [
          _SectionPill('HOW IT WORKS'),
          const SizedBox(height: 14),
          const Text(
            'Up and running in one afternoon',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _kText, fontSize: 22, fontWeight: FontWeight.w900,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 28),
          ...List.generate(_howSteps.length, (i) {
            final s = _howSteps[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: _kBg,
                border: Border.all(color: _kBorder, width: 1.5),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _kBlueBright.withOpacity(0.04),
                    blurRadius: 10, offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_kAmber, Color(0xFFFFCC44)],
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(13),
                      boxShadow: [
                        BoxShadow(
                          color: _kAmber.withOpacity(0.3),
                          blurRadius: 10, offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      s[0],
                      style: const TextStyle(
                        color: Color(0xFF3D2000), fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s[1],
                            style: const TextStyle(
                              color: _kText, fontSize: 15,
                              fontWeight: FontWeight.w800,
                            )),
                        const SizedBox(height: 5),
                        Text(s[2],
                            style: const TextStyle(
                              color: _kSubtext, fontSize: 13, height: 1.6,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  //  TESTIMONIALS
  // ────────────────────────────────────────────────────────────
  Widget _buildTestimonials() {
    return Container(
      color: _kBgAlt,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 44),
      child: Column(
        children: [
          _SectionPill('WHAT OUR USERS SAY'),
          const SizedBox(height: 14),
          const Text(
            'Real people. Real results.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _kText, fontSize: 22, fontWeight: FontWeight.w900,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 28),
          ...List.generate(_testimonials.length, (i) {
            final t = _testimonials[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _kWhite,
                border: Border.all(color: _kBorder, width: 1.5),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: _kBlueBright.withOpacity(0.06),
                    blurRadius: 12, offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('❝',
                      style: TextStyle(
                          color: _kAmber, fontSize: 28, height: 1)),
                  const SizedBox(height: 6),
                  Text(t[0],
                      style: const TextStyle(
                        color: _kTextMid, fontSize: 14,
                        height: 1.75, fontStyle: FontStyle.italic,
                      )),
                  const SizedBox(height: 14),
                  Container(height: 1, color: _kBorder),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: _kBlueBright,
                        child: Text(
                          t[1][0],
                          style: const TextStyle(
                            color: _kWhite, fontWeight: FontWeight.w900,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t[1],
                              style: const TextStyle(
                                color: _kText, fontSize: 13,
                                fontWeight: FontWeight.w800,
                              )),
                          const SizedBox(height: 2),
                          Text(t[2],
                              style: const TextStyle(
                                color: _kSubtext, fontSize: 11.5,
                              )),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  //  FINAL CTA
  // ────────────────────────────────────────────────────────────
  Widget _buildCTA() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_kBlueBright, const Color(0xFF1D4ED8)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 52),
      child: Column(
        children: [
          const Text(
            'Your borehole deserves\nbetter than guesswork',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _kWhite, fontSize: 25, fontWeight: FontWeight.w900,
              letterSpacing: -0.4, height: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Join property managers across Kenya who have taken\ncontrol of their water supply. Free to get started.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _kWhite.withOpacity(0.82), fontSize: 14, height: 1.65,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _goToLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: _kAmber,
                foregroundColor: const Color(0xFF3D2000),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text(
                'Create Free Account',
                style: TextStyle(
                  color: Color(0xFF3D2000), fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _goToLogin,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFAAC0FF), width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                'Sign In to Existing Account',
                style: TextStyle(
                  color: _kWhite, fontSize: 15, fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  //  FOOTER
  // ────────────────────────────────────────────────────────────
  Widget _buildFooter() {
    return Container(
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            SizedBox(
              width: 140, height: 46,
              child: Image.asset(
                'assets/Logo.png',
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                errorBuilder: (_, __, ___) => const _TextLogoWhite(),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '© 2025 Smart Meter App · Powered by Snapp Africa',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF64748B), fontSize: 11),
            ),
            const SizedBox(height: 4),
            const Text(
              'Nairobi, Kenya',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF475569), fontSize: 10.5),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// HELPER WIDGETS
// ══════════════════════════════════════════════════════════════

class _BulletPoint extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  const _BulletPoint(
      {required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28, height: 28,
          decoration: BoxDecoration(
            color: color.withOpacity(0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              text,
              style: const TextStyle(
                color: _kTextMid, fontSize: 12.5,
                height: 1.45, fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionPill extends StatelessWidget {
  final String text;
  const _SectionPill(this.text);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: _kBlueSoft,
          border: Border.all(color: _kBlueBright.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: _kBlue, fontSize: 10,
            fontWeight: FontWeight.w800, letterSpacing: 1.5,
          ),
        ),
      );
}

class _TextLogoBlue extends StatelessWidget {
  const _TextLogoBlue();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          '>',
          style: TextStyle(
            color: _kAmber, fontSize: 34, fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SNAPP',
              style: TextStyle(
                color: _kBlue, fontSize: 22, fontWeight: FontWeight.w900,
                letterSpacing: 3, height: 1,
              ),
            ),
            Text(
              'AFRICA',
              style: TextStyle(
                color: _kAmber, fontSize: 10, fontWeight: FontWeight.w700,
                letterSpacing: 4, height: 1.3,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TextLogoWhite extends StatelessWidget {
  const _TextLogoWhite();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          '>',
          style: TextStyle(
            color: _kAmber, fontSize: 28, fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(width: 5),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SNAPP',
              style: TextStyle(
                color: _kWhite, fontSize: 16, fontWeight: FontWeight.w900,
                letterSpacing: 2, height: 1,
              ),
            ),
            Text(
              'AFRICA',
              style: TextStyle(
                color: _kAmber, fontSize: 8, fontWeight: FontWeight.w700,
                letterSpacing: 3, height: 1.4,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MeterPlaceholder extends StatelessWidget {
  const _MeterPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kBlueSoft,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sensors_rounded, size: 52, color: _kBlueBright),
          SizedBox(height: 10),
          Text(
            'Smart Meter',
            style: TextStyle(
              color: _kText, fontSize: 13, fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Add meter.png\nto assets/',
            textAlign: TextAlign.center,
            style: TextStyle(color: _kSubtext, fontSize: 10, height: 1.4),
          ),
        ],
      ),
    );
  }
}