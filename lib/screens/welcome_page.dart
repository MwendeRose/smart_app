// lib/screens/welcome_page.dart
// ignore_for_file: deprecated_member_use, curly_braces_in_flow_control_structures, unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

// ─── Design Tokens (matches LoginPage palette) ───────────────
const _kBlue      = Color(0xFF1B4FD8);
const _kAmber     = Color(0xFFFFAA00);
const _kWhite     = Color(0xFFFFFFFF);
const _kOffWhite  = Color(0xFFF0F4FF);
const _kText      = Color(0xFF111827);
const _kSubtext   = Color(0xFF6B7280);
const _kBorder    = Color(0xFFDDE3F0);

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {

  final PageController _pageCtrl = PageController();
  int _currentPage = 0;

  late final List<AnimationController> _fadeControllers;
  late final List<Animation<double>>   _fadeAnims;
  late final List<AnimationController> _slideControllers;
  late final List<Animation<Offset>>   _slideAnims;

  late final AnimationController _entryCtrl;
  late final Animation<double>   _entryFade;
  late final Animation<Offset>   _entrySlide;

  final List<_OnboardStep> _steps = const [
    _OnboardStep(
      icon:        Icons.water_drop_rounded,
      iconColor:   Color(0xFF0EA5E9),
      iconBg:      Color(0xFFE0F2FE),
      title:       'Real-Time Borehole Monitoring',
      description: 'Track water levels, pump status, and flow rates across all your boreholes — updated live, 24/7.',
      stat:        '99.9%',
      statLabel:   'Uptime',
      stat2:       'Live',
      statLabel2:  'Updates',
    ),
    _OnboardStep(
      icon:        Icons.bolt_rounded,
      iconColor:   Color(0xFFFFAA00),
      iconBg:      Color(0xFFFFF7E0),
      title:       'Smart Pump Control',
      description: 'Start, stop, or schedule your pumps remotely. Full control at your fingertips, wherever you are.',
      stat:        '1-tap',
      statLabel:   'Control',
      stat2:       'Remote',
      statLabel2:  'Access',
    ),
    _OnboardStep(
      icon:        Icons.analytics_rounded,
      iconColor:   Color(0xFF8B5CF6),
      iconBg:      Color(0xFFF3F0FF),
      title:       'Analytics & Insights',
      description: 'Visualise consumption trends, detect anomalies, and generate reports to make smarter water decisions.',
      stat:        '30+',
      statLabel:   'Reports',
      stat2:       'AI',
      statLabel2:  'Insights',
    ),
    _OnboardStep(
      icon:        Icons.notifications_active_rounded,
      iconColor:   Color(0xFFEF4444),
      iconBg:      Color(0xFFFFEEEE),
      title:       'Instant Critical Alerts',
      description: 'Get notified immediately when pumps fail, tanks overflow, or unusual activity is detected on your network.',
      stat:        '<1s',
      statLabel:   'Alert Time',
      stat2:       'SMS + App',
      statLabel2:  'Channels',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _entryFade = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _entrySlide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));

    _fadeControllers = List.generate(_steps.length,
        (_) => AnimationController(vsync: this, duration: const Duration(milliseconds: 420)));
    _fadeAnims = _fadeControllers
        .map((c) => CurvedAnimation(parent: c, curve: Curves.easeOut))
        .toList();

    _slideControllers = List.generate(_steps.length,
        (_) => AnimationController(vsync: this, duration: const Duration(milliseconds: 420)));
    _slideAnims = _slideControllers.map((c) =>
      Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
          .animate(CurvedAnimation(parent: c, curve: Curves.easeOut)),
    ).toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _entryCtrl.forward();
      _fadeControllers[0].forward();
      _slideControllers[0].forward();
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _entryCtrl.dispose();
    for (final c in _fadeControllers) c.dispose();
    for (final c in _slideControllers) c.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    _fadeControllers[page].reset();
    _slideControllers[page].reset();
    _fadeControllers[page].forward();
    _slideControllers[page].forward();
  }

  void _next() {
    if (_currentPage < _steps.length - 1) {
      _pageCtrl.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      _goToLogin();
    }
  }

  void _skip() => _goToLogin();

  // ✅ Saves seen_welcome flag so main.dart routes to LoginPage on next launch
  Future<void> _goToLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_welcome', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const LoginPage(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size   = MediaQuery.of(context).size;
    final isWide = size.width > 680;

    return Scaffold(
      backgroundColor: _kOffWhite,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEBF0FF), Color(0xFFF5F7FF), Color(0xFFE8EEFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _entryFade,
            child: SlideTransition(
              position: _entrySlide,
              child: isWide ? _buildWideLayout() : _buildNarrowLayout(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWideLayout() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 880),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              _buildTopBar(),
              const SizedBox(height: 16),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(flex: 5, child: _buildHeroPanel()),
                    const SizedBox(width: 20),
                    Expanded(flex: 7, child: _buildRightPanel()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNarrowLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          _buildTopBar(),
          const SizedBox(height: 20),
          Expanded(child: _buildMobileSlides()),
          _buildBottomCTA(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo pill — drawn, no image asset needed
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _kBlue,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: _kBlue.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('>', style: TextStyle(color: _kAmber, fontSize: 18, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
              const SizedBox(width: 7),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('SNAPP', style: TextStyle(color: _kWhite, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 2.5, height: 1)),
                  Text('AFRICA', style: TextStyle(color: _kAmber, fontSize: 7, fontWeight: FontWeight.w700, letterSpacing: 3, height: 1.4)),
                ],
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: _skip,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: _kBorder)),
            backgroundColor: _kWhite,
          ),
          child: const Text('Skip  →', style: TextStyle(color: _kSubtext, fontSize: 12, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildHeroPanel() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1B4FD8), Color(0xFF0E2D90)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [BoxShadow(color: _kBlue.withOpacity(0.35), blurRadius: 40, offset: const Offset(0, 12))],
      ),
      child: Stack(
        children: [
          Positioned(top: -40, right: -40,
            child: Container(width: 180, height: 180,
              decoration: BoxDecoration(shape: BoxShape.circle, color: _kWhite.withOpacity(0.06)))),
          Positioned(bottom: -60, left: -30,
            child: Container(width: 200, height: 200,
              decoration: BoxDecoration(shape: BoxShape.circle, color: _kWhite.withOpacity(0.04)))),
          Positioned(top: 100, right: 10,
            child: Container(width: 60, height: 60,
              decoration: BoxDecoration(shape: BoxShape.circle, color: _kAmber.withOpacity(0.14)))),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('${_currentPage + 1} / ${_steps.length}',
                        style: TextStyle(color: _kWhite.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1)),
                    const SizedBox(height: 10),
                    Row(
                      children: List.generate(_steps.length, (i) {
                        final active = i == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 6),
                          width: active ? 24 : 6, height: 6,
                          decoration: BoxDecoration(
                            color: active ? _kAmber : _kWhite.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      child: Container(
                        key: ValueKey(_currentPage),
                        width: 68, height: 68,
                        decoration: BoxDecoration(
                          color: _kWhite.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: _kWhite.withOpacity(0.2), width: 1.5),
                        ),
                        child: Icon(_steps[_currentPage].icon, color: _kWhite, size: 32),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      child: Text(_steps[_currentPage].title,
                        key: ValueKey('title_$_currentPage'),
                        style: const TextStyle(color: _kWhite, fontSize: 22, fontWeight: FontWeight.w900, height: 1.2, letterSpacing: -0.3),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('POWERED BY', style: TextStyle(color: Color(0x7FFFFFFF), fontSize: 8, letterSpacing: 2.5, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: _kWhite.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _kAmber.withOpacity(0.3), width: 1),
                      ),
                      child: Row(children: [
                        const Text('>', style: TextStyle(color: _kAmber, fontSize: 14, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Snapp Africa', style: TextStyle(color: _kWhite.withOpacity(0.9), fontSize: 11, fontWeight: FontWeight.w700)),
                            Text('Smart water for Africa', style: TextStyle(color: _kWhite.withOpacity(0.5), fontSize: 8.5, fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ]),
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

  Widget _buildRightPanel() {
    return Column(children: [
      Expanded(child: _buildSlideContent()),
      const SizedBox(height: 16),
      _buildBottomCTA(),
    ]);
  }

  Widget _buildSlideContent() {
    return PageView.builder(
      controller: _pageCtrl,
      onPageChanged: _onPageChanged,
      itemCount: _steps.length,
      itemBuilder: (ctx, i) => FadeTransition(
        opacity: _fadeAnims[i],
        child: SlideTransition(
          position: _slideAnims[i],
          child: _SlideCard(step: _steps[i]),
        ),
      ),
    );
  }

  Widget _buildMobileSlides() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_steps.length, (i) {
          final active = i == _currentPage;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: active ? 20 : 6, height: 6,
            decoration: BoxDecoration(
              color: active ? _kBlue : _kBorder,
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
      ),
      const SizedBox(height: 20),
      Expanded(child: _buildSlideContent()),
    ]);
  }

  Widget _buildBottomCTA() {
    final isLast = _currentPage == _steps.length - 1;
    return Column(
      children: [
        if (MediaQuery.of(context).size.width > 680) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_steps.length, (i) {
              final active = i == _currentPage;
              return GestureDetector(
                onTap: () => _pageCtrl.animateToPage(i, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 20 : 6, height: 6,
                  decoration: BoxDecoration(color: active ? _kBlue : _kBorder, borderRadius: BorderRadius.circular(3)),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
        ],
        Row(children: [
          if (_currentPage > 0) ...[
            SizedBox(
              height: 52, width: 52,
              child: OutlinedButton(
                onPressed: () => _pageCtrl.previousPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: const BorderSide(color: _kBorder),
                  backgroundColor: _kWhite,
                ),
                child: const Icon(Icons.arrow_back_rounded, color: _kSubtext, size: 18),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(isLast ? 'Get Started' : 'Continue',
                        style: const TextStyle(color: _kWhite, fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.2)),
                    const SizedBox(width: 8),
                    Icon(isLast ? Icons.rocket_launch_rounded : Icons.arrow_forward_rounded, color: _kAmber, size: 17),
                  ],
                ),
              ),
            ),
          ),
        ]),
        const SizedBox(height: 10),
        Center(
          child: GestureDetector(
            onTap: _skip,
            child: RichText(
              text: const TextSpan(
                text: 'Already have an account?  ',
                style: TextStyle(color: _kSubtext, fontSize: 12),
                children: [
                  TextSpan(text: 'Sign in', style: TextStyle(color: _kBlue, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Models & Widgets ─────────────────────────────────────────

class _OnboardStep {
  final IconData icon;
  final Color    iconColor, iconBg;
  final String   title, description, stat, statLabel, stat2, statLabel2;
  const _OnboardStep({
    required this.icon, required this.iconColor, required this.iconBg,
    required this.title, required this.description,
    required this.stat, required this.statLabel,
    required this.stat2, required this.statLabel2,
  });
}

class _SlideCard extends StatelessWidget {
  final _OnboardStep step;
  const _SlideCard({required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: _kWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kBorder),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.07), blurRadius: 30, offset: const Offset(0, 8))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(color: step.iconBg, borderRadius: BorderRadius.circular(16)),
              child: Icon(step.icon, color: step.iconColor, size: 28),
            ),
            const SizedBox(height: 20),
            Text(step.title, style: const TextStyle(color: _kText, fontSize: 22, fontWeight: FontWeight.w900, height: 1.2, letterSpacing: -0.3)),
            const SizedBox(height: 10),
            Text(step.description, style: const TextStyle(color: _kSubtext, fontSize: 13.5, height: 1.65)),
            const Spacer(),
            Row(children: [
              Expanded(child: _StatPill(value: step.stat, label: step.statLabel, accent: step.iconColor)),
              const SizedBox(width: 10),
              Expanded(child: _StatPill(value: step.stat2, label: step.statLabel2, accent: step.iconColor)),
            ]),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String value, label;
  final Color  accent;
  const _StatPill({required this.value, required this.label, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: TextStyle(color: accent, fontSize: 18, fontWeight: FontWeight.w900, height: 1, letterSpacing: -0.3)),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(color: _kSubtext, fontSize: 10.5, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}