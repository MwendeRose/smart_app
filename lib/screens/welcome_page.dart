// lib/screens/welcome_page.dart
// ignore_for_file: deprecated_member_use, unused_element, unnecessary_underscores

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

// ─── Bright, clean colour palette ────────────────────────────
const _kWhite     = Color(0xFFFFFFFF);
const _kBg        = Color(0xFFF6F9FF);      // very light blue-white page bg
const _kBgAlt     = Color(0xFFEDF2FF);      // slightly deeper for alternating sections
const _kBlue      = Color(0xFF1A4FD6);      // primary blue
const _kBlueSoft  = Color(0xFFE8EFFE);      // blue tint bg
const _kAmber     = Color(0xFFFFAA00);      // amber accent
const _kAmberBg   = Color(0xFFFFF4D6);      // amber tint bg
const _kText      = Color(0xFF0D1726);      // near-black body
const _kTextMid   = Color(0xFF2C3A55);      // secondary text
const _kSubtext   = Color(0xFF5A6A85);      // muted body text
const _kBorder    = Color(0xFFD0DBEE);      // subtle borders
const _kGreen     = Color(0xFF14A849);      // success / live green

// Per-benefit accent colours (dark enough for white text)
const _benefitAccents = [
  Color(0xFF1550CC),
  Color(0xFF996600),
  Color(0xFFCC2222),
  Color(0xFF0E7A3E),
  Color(0xFF6626CC),
];

// Per-benefit soft background tints
const _benefitBgs = [
  Color(0xFFEAF1FF),
  Color(0xFFFFF8E1),
  Color(0xFFFFECEC),
  Color(0xFFE8F9F1),
  Color(0xFFF3EDFF),
];

// ─── Data ────────────────────────────────────────────────────
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
    _entryCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _entryFade = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
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
      transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
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
                // ★ Smart Meter is now the FIRST thing users see
                _buildMeterHero(),
                _buildHeader(),
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

  // ─── METER HERO (full-bleed, shown FIRST) ───────────────────
  Widget _buildMeterHero() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0E3BAA), Color(0xFF1A4FD6), Color(0xFF2060E8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // Logo on dark background
              SizedBox(
                width: 180,
                height: 60,
                child: Image.asset(
                  'assets/Logo.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                  isAntiAlias: true,
                  errorBuilder: (_, __, ___) => const _TextLogo(),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'powered by Snapp Africa',
                style: TextStyle(
                  color: Color(0xAABBCCFF),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 32),

              // "Meet your hardware" label
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: _kAmber.withOpacity(0.18),
                  border: Border.all(color: _kAmber.withOpacity(0.55)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'THE HARDWARE',
                  style: TextStyle(
                    color: _kAmber,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.8,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Hero headline
              const Text(
                'Meet the Smart Meter',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _kWhite,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  height: 1.18,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'A compact device that attaches to your borehole\nand streams live data straight to your phone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _kWhite.withOpacity(0.78),
                  fontSize: 13.5,
                  height: 1.65,
                ),
              ),
              const SizedBox(height: 32),

              // ── Large, centred meter image ──
              Center(
                child: Container(
                  width: 200,
                  height: 260,
                  decoration: BoxDecoration(
                    color: _kWhite,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: _kWhite.withOpacity(0.3), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.30),
                        blurRadius: 40,
                        offset: const Offset(0, 16),
                      ),
                      BoxShadow(
                        color: _kAmber.withOpacity(0.15),
                        blurRadius: 60,
                        spreadRadius: 4,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/meter.png',
                          width: 200,
                          height: 260,
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                          filterQuality: FilterQuality.high,
                          errorBuilder: (_, __, ___) => const _MeterPlaceholderLarge(),
                        ),
                      ),
                      // LIVE badge
                      Positioned(
                        top: 12, right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                          decoration: BoxDecoration(
                            color: _kGreen,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: _kGreen.withOpacity(0.4),
                                  blurRadius: 8, offset: const Offset(0, 2)),
                            ],
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Container(
                              width: 6, height: 6,
                              decoration: const BoxDecoration(
                                  color: _kWhite, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 5),
                            const Text('LIVE',
                                style: TextStyle(color: _kWhite, fontSize: 9,
                                    fontWeight: FontWeight.w900, letterSpacing: 0.8)),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Feature chips row
              Wrap(
                spacing: 10, runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  _MeterChip(icon: Icons.wifi_rounded, label: 'Wireless'),
                  _MeterChip(icon: Icons.bolt_rounded, label: 'Low Power'),
                  _MeterChip(icon: Icons.water_drop_rounded, label: 'IP67 Rated'),
                  _MeterChip(icon: Icons.build_circle_rounded, label: 'Easy Install'),
                ],
              ),
              const SizedBox(height: 30),

              // Product badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: _kAmberBg,
                  border: Border.all(color: _kAmber.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'SNAPP SMART METER  ·  BOREHOLE EDITION',
                  style: TextStyle(
                    color: Color(0xFF774400),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // CTA to scroll / continue
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _goToLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kAmber,
                    foregroundColor: const Color(0xFF3D2000),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Get Started — It\'s Free',
                    style: TextStyle(
                      color: Color(0xFF3D2000),
                      fontSize: 16,
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    'Sign In to Your Account',
                    style: TextStyle(
                        color: _kWhite, fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              // Scroll hint
              const SizedBox(height: 24),
              Column(children: [
                Text('Scroll to learn more',
                    style: TextStyle(
                        color: _kWhite.withOpacity(0.5), fontSize: 11,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                Icon(Icons.keyboard_arrow_down_rounded,
                    color: _kWhite.withOpacity(0.4), size: 22),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  // ─── HEADER (now second section) ─────────────────────────────
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEBF1FF), Color(0xFFF8FAFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 44, 24, 44),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // Blue badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: _kBlueSoft,
                border: Border.all(color: const Color(0xFF99B8FF)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Smart Borehole Monitoring',
                style: TextStyle(
                  color: _kBlue,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Hero headline
            const Text(
              'Never Worry About\nYour Water Supply Again',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _kText,
                fontSize: 30,
                fontWeight: FontWeight.w900,
                height: 1.18,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 14),

            const Text(
              'Monitor your borehole, control your pump, and get\nwarned about problems — all from your phone.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _kSubtext,
                fontSize: 14,
                height: 1.65,
              ),
            ),
            const SizedBox(height: 32),

            // Stats card
            Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              decoration: BoxDecoration(
                color: _kWhite,
                border: Border.all(color: _kBorder),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _kBlue.withOpacity(0.07),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _Stat('30s',  'Updates'),
                  _StatDiv(),
                  _Stat('<2s',  'Pump resp.'),
                  _StatDiv(),
                  _Stat('<1s',  'Alerts'),
                  _StatDiv(),
                  _Stat('24/7', 'Monitoring'),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Trust badges
            Wrap(
              spacing: 14, runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _Trust('No contracts'),
                _Trust('Any phone'),
                _Trust('Easy install'),
                _Trust('Free to start'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── BENEFITS ────────────────────────────────────────────────
  Widget _buildBenefits() {
    final b = _benefits[_activeBenefit];
    final accent = _benefitAccents[_activeBenefit];
    final bgTint = _benefitBgs[_activeBenefit];

    return Container(
      color: _kBgAlt,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
      child: Column(
        children: [
          _SectionPill('WHY SMART METER APP'),
          const SizedBox(height: 14),
          const Text(
            'Built for people who can\'t\nafford water problems',
            textAlign: TextAlign.center,
            style: TextStyle(color: _kText, fontSize: 22, fontWeight: FontWeight.w900,
                letterSpacing: -0.3, height: 1.2),
          ),
          const SizedBox(height: 26),

          // Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_benefits.length, (i) {
                final active = i == _activeBenefit;
                final tabAccent = _benefitAccents[i];
                return GestureDetector(
                  onTap: () => setState(() => _activeBenefit = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                    decoration: BoxDecoration(
                      color: active ? tabAccent : _kWhite,
                      border: Border.all(color: active ? tabAccent : _kBorder, width: active ? 2 : 1.5),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: active ? [BoxShadow(color: tabAccent.withOpacity(0.2),
                          blurRadius: 8, offset: const Offset(0, 3))] : [],
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
                position: Tween<Offset>(begin: const Offset(0.04, 0), end: Offset.zero)
                    .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
                child: child,
              ),
            ),
            child: Container(
              key: ValueKey(_activeBenefit),
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: bgTint,
                border: Border.all(color: accent.withOpacity(0.25), width: 1.5),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(b.subline.toUpperCase(),
                    style: TextStyle(color: accent, fontSize: 10, fontWeight: FontWeight.w800,
                        letterSpacing: 1.0)),
                const SizedBox(height: 8),
                Text(b.headline,
                    style: const TextStyle(color: _kText, fontSize: 19,
                        fontWeight: FontWeight.w900, letterSpacing: -0.2)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(border: Border(left: BorderSide(color: accent, width: 3))),
                  child: Text(b.story,
                      style: const TextStyle(color: _kTextMid, fontSize: 13.5, height: 1.75)),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(8)),
                  child: Text(b.proof,
                      style: const TextStyle(color: _kWhite, fontSize: 12, fontWeight: FontWeight.w800)),
                ),
              ]),
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

  String _tabLabel(int i) => ['Monitor', 'Control', 'Alerts', 'Save', 'Team'][i];

  // ─── HOW IT WORKS ────────────────────────────────────────────
  Widget _buildHowItWorks() {
    return Container(
      color: _kWhite,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
      child: Column(children: [
        _SectionPill('HOW IT WORKS'),
        const SizedBox(height: 14),
        const Text(
          'Up and running in one afternoon',
          textAlign: TextAlign.center,
          style: TextStyle(color: _kText, fontSize: 22, fontWeight: FontWeight.w900,
              letterSpacing: -0.3, height: 1.2),
        ),
        const SizedBox(height: 30),
        ...List.generate(_howSteps.length, (i) {
          final s = _howSteps[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _kBg,
              border: Border.all(color: _kBorder, width: 1.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(color: _kAmber, borderRadius: BorderRadius.circular(12)),
                alignment: Alignment.center,
                child: Text(s[0], style: const TextStyle(color: Color(0xFF3D2000),
                    fontSize: 18, fontWeight: FontWeight.w900)),
              ),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s[1], style: const TextStyle(color: _kText, fontSize: 15, fontWeight: FontWeight.w800)),
                const SizedBox(height: 5),
                Text(s[2], style: const TextStyle(color: _kSubtext, fontSize: 13, height: 1.6)),
              ])),
            ]),
          );
        }),
      ]),
    );
  }

  // ─── TESTIMONIALS ────────────────────────────────────────────
  Widget _buildTestimonials() {
    return Container(
      color: _kBgAlt,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
      child: Column(children: [
        _SectionPill('WHAT OUR USERS SAY'),
        const SizedBox(height: 14),
        const Text(
          'Real people. Real results.',
          textAlign: TextAlign.center,
          style: TextStyle(color: _kText, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.3),
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
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: _kBlue.withOpacity(0.05),
                  blurRadius: 12, offset: const Offset(0, 3))],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('❝', style: TextStyle(color: _kAmber, fontSize: 28, height: 1)),
              const SizedBox(height: 6),
              Text(t[0], style: const TextStyle(color: _kTextMid, fontSize: 14,
                  height: 1.75, fontStyle: FontStyle.italic)),
              const SizedBox(height: 14),
              const Divider(color: _kBorder, thickness: 1),
              const SizedBox(height: 10),
              Row(children: [
                CircleAvatar(radius: 20, backgroundColor: _kBlue,
                    child: Text(t[1][0], style: const TextStyle(color: _kWhite,
                        fontWeight: FontWeight.w900, fontSize: 15))),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t[1], style: const TextStyle(color: _kText, fontSize: 13, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(t[2], style: const TextStyle(color: _kSubtext, fontSize: 11.5)),
                ]),
              ]),
            ]),
          );
        }),
      ]),
    );
  }

  // ─── FINAL CTA ───────────────────────────────────────────────
  Widget _buildCTA() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A4FD6), Color(0xFF0E3BAA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 52),
      child: Column(children: [
        const Text(
          'Your borehole deserves\nbetter than guesswork',
          textAlign: TextAlign.center,
          style: TextStyle(color: _kWhite, fontSize: 25, fontWeight: FontWeight.w900,
              letterSpacing: -0.4, height: 1.2),
        ),
        const SizedBox(height: 14),
        Text(
          'Join property managers across Kenya who have taken\ncontrol of their water supply. Free to get started.',
          textAlign: TextAlign.center,
          style: TextStyle(color: _kWhite.withOpacity(0.82), fontSize: 14, height: 1.65),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: const Text('Create Free Account',
                style: TextStyle(color: Color(0xFF3D2000), fontSize: 16, fontWeight: FontWeight.w900)),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Sign In to Existing Account',
                style: TextStyle(color: _kWhite, fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ),
      ]),
    );
  }

  // ─── FOOTER ──────────────────────────────────────────────────
  Widget _buildFooter() {
    return Container(
      color: const Color(0xFFEDF1FA),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      child: SafeArea(
        top: false,
        child: Column(children: [
          SizedBox(
            width: 130, height: 42,
            child: Image.asset(
              'assets/Logo.png',
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              errorBuilder: (_, __, ___) => const _TextLogoLight(),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '© 2025 Smart Meter App · Powered by Snapp Africa · Nairobi, Kenya',
            textAlign: TextAlign.center,
            style: TextStyle(color: _kSubtext, fontSize: 11),
          ),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// HELPER WIDGETS
// ════════════════════════════════════════════════════════════════

class _MeterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MeterChip({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: _kWhite.withOpacity(0.12),
      border: Border.all(color: _kWhite.withOpacity(0.25)),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 13, color: _kAmber),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(color: _kWhite, fontSize: 12,
          fontWeight: FontWeight.w700)),
    ]),
  );
}

class _SectionPill extends StatelessWidget {
  final String text;
  const _SectionPill(this.text);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    decoration: BoxDecoration(
      color: _kBlueSoft,
      border: Border.all(color: const Color(0xFF99B8FF)),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(text, style: const TextStyle(color: _kBlue, fontSize: 10,
        fontWeight: FontWeight.w800, letterSpacing: 1.5)),
  );
}

class _TextLogoLight extends StatelessWidget {
  const _TextLogoLight();
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      const Text('>', style: TextStyle(color: _kAmber, fontSize: 28,
          fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
      const SizedBox(width: 5),
      Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('SNAPP', style: TextStyle(color: _kText, fontSize: 14,
            fontWeight: FontWeight.w900, letterSpacing: 2, height: 1)),
        const Text('AFRICA', style: TextStyle(color: Color(0xFF774400), fontSize: 8,
            fontWeight: FontWeight.w700, letterSpacing: 3, height: 1.4)),
      ]),
    ]);
  }
}

class _TextLogo extends StatelessWidget {
  const _TextLogo();
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      const Text('>', style: TextStyle(color: _kAmber, fontSize: 28,
          fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
      const SizedBox(width: 5),
      Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('SNAPP', style: TextStyle(color: _kWhite, fontSize: 14,
            fontWeight: FontWeight.w900, letterSpacing: 2, height: 1)),
        const Text('AFRICA', style: TextStyle(color: _kAmber, fontSize: 8,
            fontWeight: FontWeight.w700, letterSpacing: 3, height: 1.4)),
      ]),
    ]);
  }
}

class _MeterPlaceholderLarge extends StatelessWidget {
  const _MeterPlaceholderLarge();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kBlueSoft,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.sensors_rounded, size: 56, color: _kBlue),
        const SizedBox(height: 10),
        const Text('Smart Meter', style: TextStyle(color: _kText, fontSize: 14, fontWeight: FontWeight.w800)),
        const SizedBox(height: 5),
        const Text('Add meter.png\nto assets/', textAlign: TextAlign.center,
            style: TextStyle(color: _kSubtext, fontSize: 11, height: 1.4)),
      ]),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value, label;
  const _Stat(this.value, this.label);
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(value, style: const TextStyle(color: _kBlue, fontSize: 17,
          fontWeight: FontWeight.w900, letterSpacing: -0.5)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(color: _kSubtext, fontSize: 9.5,
          fontWeight: FontWeight.w500)),
    ],
  );
}

class _StatDiv extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 28, color: _kBorder);
}

class _Trust extends StatelessWidget {
  final String label;
  const _Trust(this.label);
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(width: 7, height: 7,
          decoration: const BoxDecoration(color: _kGreen, shape: BoxShape.circle)),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(color: _kSubtext, fontSize: 12, fontWeight: FontWeight.w600)),
    ],
  );
}