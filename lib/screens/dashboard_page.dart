// lib/screens/dashboard_page.dart
// ignore_for_file: deprecated_member_use, unused_element, unnecessary_underscores, use_build_context_synchronously

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/borehole_system_card.dart';
import '../main.dart'; // for replayWelcome()
import 'alerts_page.dart';
import 'analytics.dart';
import 'settings.dart';
import 'home_screen.dart'; // AppColors, HomeContentPage

// ─── Greeting helper ───────────────────────────────────────────
String _greeting() {
  final h = DateTime.now().hour;
  if (h < 12) return 'Good Morning';
  if (h < 17) return 'Good Afternoon';
  return 'Good Evening';
}

// ════════════════════════════════════════════════════════════════
//  DASHBOARD PAGE
// ════════════════════════════════════════════════════════════════
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _sideIndex = 0;
  final _pumpState = PumpStateNotifier(initiallyRunning: true);

  @override
  void dispose() {
    _pumpState.dispose();
    super.dispose();
  }

  Widget _body() {
    switch (_sideIndex) {
      case 1:
        return HomeContentPage(
          pumpState: _pumpState,
          onGoToAlerts: () => setState(() => _sideIndex = 2),
        );
      case 2:
        return const AlertsPage();
      case 3:
        return const AnalyticsPage();
      case 4:
        return const SettingsPage();
      case 5:
        return const _ProfileTab();
      default:
        return OverviewPage(
          onGoToAlerts: () => setState(() => _sideIndex = 2),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DashSidebar(
              selected: _sideIndex,
              onSelect: (i) => setState(() => _sideIndex = i),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _TitleBar(),
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.03,
                            child: Image.asset(
                              'assets/meter.png',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const SizedBox.shrink(),
                            ),
                          ),
                        ),
                        _body(),
                      ],
                    ),
                  ),
                  const _AppFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  PERSISTENT TITLE BAR
// ════════════════════════════════════════════════════════════════
class _TitleBar extends StatelessWidget {
  const _TitleBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF2563EB), Color(0xFF3B82F6)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x331D4ED8),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Smart Meter App',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Borehole Management System',
            style: TextStyle(
              color: Color(0xFFBAE6FD),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  SIDEBAR
// ════════════════════════════════════════════════════════════════
class _DashSidebar extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const _DashSidebar({required this.selected, required this.onSelect});

  static const _bg      = Color(0xFFEFF6FF);
  static const _border  = Color(0xFFBFD7F5);
  static const _iconOff = Color(0xFF3B82F6);
  static const _lblOff  = Color(0xFF1E40AF);
  static const _selBg   = Color(0xFF1D4ED8);
  static const _selFg   = Color(0xFFFFFFFF);
  static const _hover   = Color(0xFFBFD7F5);

  static const _items = [
    _NavEntry(icon: Icons.dashboard_rounded,     label: 'Dashboard', idx: 0),
    _NavEntry(icon: Icons.home_rounded,          label: 'Home',      idx: 1),
    _NavEntry(icon: Icons.notifications_rounded, label: 'Alerts',    idx: 2, badge: true),
    _NavEntry(icon: Icons.bar_chart_rounded,     label: 'Analytics', idx: 3),
    _NavEntry(icon: Icons.settings_rounded,      label: 'Settings',  idx: 4),
    _NavEntry(icon: Icons.person_rounded,        label: 'Profile',   idx: 5),
  ];

  @override
  Widget build(BuildContext context) {
    final user     = AuthService.instance.user;
    final initials = user?.initials ?? '?';
    final name     = user?.name     ?? 'User';
    final role     = user?.role     ?? 'Manager';

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: _bg,
        border: const Border(right: BorderSide(color: _border, width: 1.5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D4ED8).withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(6, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(10, 16, 10, 14),
            child: Center(
              child: Container(
                width: 172,
                height: 172,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFBFD7F5), width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A1D4ED8),
                      blurRadius: 14,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  'assets/Logo.png',
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  isAntiAlias: true,
                  errorBuilder: (_, __, ___) => const _SideLogoFallback(),
                ),
              ),
            ),
          ),
          Container(height: 1.5, color: _border),
          const SizedBox(height: 6),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              children: _items.map((item) {
                final active = selected == item.idx;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () => onSelect(item.idx),
                      borderRadius: BorderRadius.circular(12),
                      hoverColor: _hover,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 170),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: active ? _selBg : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: active
                              ? [
                                  BoxShadow(
                                    color: _selBg.withOpacity(0.28),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 26,
                              child: item.badge
                                  ? Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Icon(item.icon, size: 22, color: active ? _selFg : _iconOff),
                                        Positioned(
                                          top: -3,
                                          right: -4,
                                          child: Container(
                                            width: 9,
                                            height: 9,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFDC2626),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Icon(item.icon, size: 22, color: active ? _selFg : _iconOff),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item.label,
                                style: TextStyle(
                                  color: active ? _selFg : _lblOff,
                                  fontSize: 13,
                                  fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ),
                            if (item.badge)
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 170),
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: active
                                      ? Colors.white.withOpacity(0.25)
                                      : const Color(0xFFDC2626),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  '3',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            height: 1.5,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            color: _border,
          ),
          const SizedBox(height: 10),
          ListenableBuilder(
            listenable: AuthService.instance,
            builder: (_, __) => GestureDetector(
              onTap: () => onSelect(5),
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 14),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: _selBg.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _border, width: 1.5),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: _selBg,
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Color(0xFF1E3A8A),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            role,
                            style: const TextStyle(
                              color: Color(0xFF3B82F6),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF93C5FD),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavEntry {
  final IconData icon;
  final String label;
  final int idx;
  final bool badge;
  const _NavEntry({
    required this.icon,
    required this.label,
    required this.idx,
    this.badge = false,
  });
}

class _SideLogoFallback extends StatelessWidget {
  const _SideLogoFallback();
  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '>',
          style: TextStyle(
            color: Color(0xFFFFAA00),
            fontSize: 28,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(width: 2),
        Text(
          'S',
          style: TextStyle(
            color: Color(0xFF1D4ED8),
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  OVERVIEW PAGE (index 0)
// ════════════════════════════════════════════════════════════════
class OverviewPage extends StatelessWidget {
  final VoidCallback? onGoToAlerts;
  const OverviewPage({super.key, this.onGoToAlerts});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthService.instance,
      builder: (context, _) {
        final firstName = AuthService.instance.user?.firstName ?? 'there';
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GreetingRow(firstName: firstName),
              const SizedBox(height: 28),
              // ① Project intro banner
              const _ProjectIntroBanner(),
              const SizedBox(height: 24),
              // ② Full explain card
              const _DashboardExplainCard(),
              const SizedBox(height: 24),
              // ③ Q&A section
              const _QASection(),
              const SizedBox(height: 24),
              // ④ AI chat
              const _AiChatSection(),
            ],
          ),
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  PROJECT INTRO BANNER
// ════════════════════════════════════════════════════════════════
class _ProjectIntroBanner extends StatelessWidget {
  const _ProjectIntroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF2563EB), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D4ED8).withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon badge
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.water_drop_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 18),
          // Text
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart Meter App — Borehole Management System',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'A real-time water infrastructure platform designed for Kenyan property owners and estate managers. '
                  'Connect boreholes, tanks, pumps, and sub-meters into one unified dashboard — monitor consumption, '
                  'control pumps remotely, detect leaks automatically, and generate accurate tenant bills, all from anywhere.',
                  style: TextStyle(
                    color: Color(0xFFBAE6FD),
                    fontSize: 13,
                    height: 1.65,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    _BadgeChip(label: 'IoT-Enabled'),
                    SizedBox(width: 8),
                    _BadgeChip(label: 'Real-Time Data'),
                    SizedBox(width: 8),
                    _BadgeChip(label: 'WRMA Compliant'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final String label;
  const _BadgeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  EXPLANATION CARD
// ════════════════════════════════════════════════════════════════
class _DashboardExplainCard extends StatelessWidget {
  const _DashboardExplainCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBFD7F5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D4ED8).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SecTitle('About Smart Meter App'),
          SizedBox(height: 12),
          _P(
            'Smart Meter App is a real-time water management platform for Kenyan property owners and estate managers. '
            'It connects your borehole pump, storage tank, municipal supply line, and individual unit sub-meters into one '
            'unified dashboard — letting you monitor consumption, control pumps remotely, detect leaks automatically, '
            'generate accurate tenant bills, and stay WRMA-compliant, all without visiting the site.',
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  Q&A SECTION
// ════════════════════════════════════════════════════════════════
class _QASection extends StatelessWidget {
  const _QASection();

  static const _faqs = [
    _FaqItem(
      q: 'How often does the system update sensor readings?',
      a: 'Sensors transmit data every 5 to 15 minutes depending on your connectivity type — 4G LTE provides the most frequent updates for urban sites, while GSM is ideal for remote areas. You can configure the polling interval in Settings.',
    ),
    _FaqItem(
      q: 'Can I control my borehole pump remotely?',
      a: 'Yes. The Home tab gives you a real-time pump toggle and a scheduling interface. You can set the pump to auto-start when the tank drops below a threshold (e.g. 20%) and auto-stop when it reaches full capacity, or run it manually at any time.',
    ),
    _FaqItem(
      q: 'How does leak detection work?',
      a: 'The system builds a baseline of your property\'s normal flow patterns over the first two weeks. After that, any hour where flow deviates significantly from baseline — especially during zero-usage hours like 1–4 AM — triggers an alert in the Alerts tab.',
    ),
    _FaqItem(
      q: 'How are tenant water bills calculated?',
      a: 'Each unit\'s sub-meter records exact consumption in cubic metres. The app applies the Nairobi Water rising-block tariff to generate an itemised bill per unit. Landlords can export bills as PDFs or share them directly from the Analytics tab.',
    ),
    _FaqItem(
      q: 'What happens if the internet goes down on site?',
      a: 'Smart meters have onboard flash storage and will continue recording readings locally. Once connectivity is restored — via GSM, 4G, or Wi-Fi — all stored readings are automatically synced to the cloud. No historical data is ever lost.',
    ),
    _FaqItem(
      q: 'Is the system compatible with WRMA borehole licensing requirements?',
      a: 'Yes. The Analytics section generates monthly extraction reports that align with Water Resources Management Authority (WRMA) reporting formats, helping you stay within your licensed daily and annual extraction limits without manual record-keeping.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBFD7F5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D4ED8).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.quiz_rounded,
                  color: Color(0xFF1D4ED8),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const _SecTitle('Frequently Asked Questions'),
            ],
          ),
          const SizedBox(height: 20),
          ..._faqs.map((faq) => _FaqTile(item: faq)),
        ],
      ),
    );
  }
}

class _FaqItem {
  final String q;
  final String a;
  const _FaqItem({required this.q, required this.a});
}

class _FaqTile extends StatefulWidget {
  final _FaqItem item;
  const _FaqTile({required this.item});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> with SingleTickerProviderStateMixin {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _open ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _open ? const Color(0xFF1D4ED8).withOpacity(0.3) : const Color(0xFFBFD7F5),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: _open
                            ? const Color(0xFF1D4ED8)
                            : const Color(0xFFDBEAFE),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _open ? Icons.remove : Icons.add,
                        size: 14,
                        color: _open ? Colors.white : const Color(0xFF1D4ED8),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.item.q,
                        style: TextStyle(
                          color: _open
                              ? const Color(0xFF1D4ED8)
                              : const Color(0xFF0F172A),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_open) ...[
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 34),
                    child: Text(
                      widget.item.a,
                      style: const TextStyle(
                        color: Color(0xFF475569),
                        fontSize: 13,
                        height: 1.7,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  AI CHAT SECTION
// ════════════════════════════════════════════════════════════════

// ─── Data model ────────────────────────────────────────────────
class _ChatMsg {
  final bool isUser;
  final String text;
  const _ChatMsg({required this.isUser, required this.text});
}

// ─── Widget ────────────────────────────────────────────────────
class _AiChatSection extends StatefulWidget {
  const _AiChatSection();

  @override
  State<_AiChatSection> createState() => _AiChatSectionState();
}

class _AiChatSectionState extends State<_AiChatSection> {
  final _ctrl     = TextEditingController();
  final _scroll   = ScrollController();
  final _msgs     = <_ChatMsg>[];
  bool  _loading  = false;

  // ── Smart keyword-based AI responses (no external API needed) ──
  static const _kb = <String, String>{
    'pump':
        'Your borehole pump can be controlled from the Home tab. You can toggle it manually, set auto-start/stop thresholds based on tank level (e.g. start at 20%, stop at 95%), or schedule it to run during off-peak electricity hours to reduce costs.',
    'schedul':
        'Pump schedules are configured in the Home tab under "Pump Schedule". You can set specific time windows (e.g. 10 PM–5 AM) for the pump to run automatically, helping you take advantage of cheaper off-peak electricity tariffs.',
    'leak':
        'Leak detection works by establishing a baseline of your property\'s normal flow patterns. If the system detects unusual flow — especially during low-use hours like 1–4 AM — it raises an alert in the Alerts tab. A dripping tap can waste ~34 L/day; a running toilet up to 400 L/day.',
    'alert':
        'Alerts are shown in the Alerts tab (the bell icon in the sidebar). You\'ll receive notifications for high consumption, detected leaks, low tank levels, and pump faults. Threshold values can be customised in Settings → Alert Thresholds.',
    'bill':
        'Billing is calculated from each unit\'s sub-meter reading. The app applies the current Nairobi Water rising-block tariff automatically and generates itemised bills per tenant. You can export these as PDFs from the Analytics tab.',
    'tank':
        'Tank level is monitored in real time via an ultrasonic or pressure sensor fitted to your storage tank. The current level is shown on the Home tab. You can configure auto-pump activation when the tank drops below your chosen threshold.',
    'wrma':
        'The Water Resources Management Authority (WRMA) requires licensed borehole owners to report monthly extraction volumes. The Smart Meter App generates compliant monthly reports automatically from your borehole flow meter data — no manual record-keeping needed.',
    'sensor':
        'The system uses four sensor types: a main municipal supply meter, a borehole flow meter, individual unit sub-meters, and a tank level sensor. All send readings to the cloud every 5–15 minutes via GSM, 4G, or LoRa radio.',
    'offline':
        'If your site loses internet connectivity, smart meters continue recording readings in onboard flash storage. Once the connection is restored, all stored data is automatically synced to the cloud — no readings are ever lost.',
    'data':
        'Meter readings are transmitted wirelessly to a secure backend server every 5–15 minutes. The backend processes every reading and exposes it through an API that powers this dashboard in real time.',
    'connect':
        'Meters connect via GSM (2G) for remote low-signal sites, 4G LTE for urban properties needing fast updates, or RF/LoRa mesh where multiple meters relay data locally before uploading to the cloud.',
    'cost':
        'The app helps reduce costs in three ways: accurate per-unit billing eliminates over-charging and disputes, leak alerts prevent water wastage, and pump scheduling shifts electricity use to off-peak hours with lower tariffs.',
    'municipal':
        'The main municipal supply meter tracks water coming in from the county supply line. This is compared against borehole and sub-meter readings to give you a complete picture of all water entering and leaving your property.',
    'borehole':
        'A borehole is a drilled well that taps into underground water. The Smart Meter App monitors your borehole\'s flow meter, controls the submersible pump remotely, and logs daily extraction volumes for WRMA compliance reporting.',
  };

  String _localReply(String question) {
    final q = question.toLowerCase();
    for (final entry in _kb.entries) {
      if (q.contains(entry.key)) return entry.value;
    }
    // Generic fallback
    return 'Great question! The Smart Meter App covers pump control, leak detection, '
        'tank monitoring, tenant billing, and WRMA compliance reporting. '
        'Try asking about a specific feature — for example: "How does leak detection work?" '
        'or "How is billing calculated?"';
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty || _loading) return;

    setState(() {
      _msgs.add(_ChatMsg(isUser: true, text: text));
      _loading = true;
    });
    _ctrl.clear();
    _scrollToBottom();

    // Simulate a brief thinking delay for natural feel
    await Future.delayed(const Duration(milliseconds: 800));

    final reply = _localReply(text);
    setState(() {
      _msgs.add(_ChatMsg(isUser: false, text: reply));
      _loading = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBFD7F5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D4ED8).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.smart_toy_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ask the Smart Meter Assistant',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Powered by AI — ask anything about water management',
                        style: TextStyle(
                          color: Color(0xFFBAE6FD),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Suggested prompts (shown when chat is empty) ────
          if (_msgs.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'How do I schedule my pump?',
                  'What triggers a leak alert?',
                  'How is billing calculated?',
                  'What is WRMA compliance?',
                ].map((q) => _SuggestChip(
                  label: q,
                  onTap: () {
                    _ctrl.text = q;
                    _send();
                  },
                )).toList(),
              ),
            ),

          // ── Messages ────────────────────────────────────────
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 60, maxHeight: 340),
            child: _msgs.isEmpty && !_loading
                ? const _ChatEmptyState()
                : ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    shrinkWrap: true,
                    itemCount: _msgs.length + (_loading ? 1 : 0),
                    itemBuilder: (ctx, i) {
                      if (_loading && i == _msgs.length) {
                        return const _TypingBubble();
                      }
                      return _MsgBubble(msg: _msgs[i]);
                    },
                  ),
          ),

          // ── Input row ───────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFBFD7F5)),
                    ),
                    child: TextField(
                      controller: _ctrl,
                      maxLines: 3,
                      minLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF0F172A),
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Ask a question about the Smart Meter App…',
                        hintStyle: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _send,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _loading
                            ? [const Color(0xFF94A3B8), const Color(0xFFCBD5E1)]
                            : [const Color(0xFF1D4ED8), const Color(0xFF3B82F6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1D4ED8).withOpacity(_loading ? 0 : 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _loading
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                  ),
                ),
              ],
            ),
          ),

          // ── AI disclaimer ────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              border: const Border(
                top: BorderSide(color: Color(0xFFFDE68A), width: 1),
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 14,
                  color: Color(0xFFB45309),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: Color(0xFF92400E),
                        fontSize: 11,
                        height: 1.55,
                      ),
                      children: [
                        TextSpan(
                          text: 'AI-generated responses. ',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text:
                              'Answers are produced by an AI language model and may not always be accurate. '
                              'Always verify critical operational or regulatory decisions with a qualified engineer or the Smart Meter support team.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Suggested prompt chip ─────────────────────────────────────
class _SuggestChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SuggestChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF93C5FD)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_forward_rounded, size: 11, color: Color(0xFF1D4ED8)),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF1D4ED8),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty state ───────────────────────────────────────────────
class _ChatEmptyState extends StatelessWidget {
  const _ChatEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_outline_rounded, size: 32, color: Color(0xFFCBD5E1)),
            SizedBox(height: 8),
            Text(
              'Select a suggested question above\nor type your own below.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 12,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Message bubble ────────────────────────────────────────────
class _MsgBubble extends StatelessWidget {
  final _ChatMsg msg;
  const _MsgBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    final isUser = msg.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: const BoxConstraints(maxWidth: 480),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          gradient: isUser
              ? const LinearGradient(
                  colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isUser ? null : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: (isUser ? const Color(0xFF1D4ED8) : const Color(0xFF475569))
                  .withOpacity(0.10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            color: isUser ? Colors.white : const Color(0xFF1E293B),
            fontSize: 13,
            height: 1.65,
          ),
        ),
      ),
    );
  }
}

// ─── Typing indicator ──────────────────────────────────────────
class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return AnimatedBuilder(
              animation: _anim,
              builder: (_, __) {
                final offset = ((i / 3) * 3.14 * 2);
                final opacity = 0.3 +
                    0.7 *
                        ((1 + ((_anim.value * 3.14 * 2 + offset).truncate() % 628) / 628) /
                            2);
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(
                        29, 78, 216, opacity.clamp(0.25, 1.0)),
                    shape: BoxShape.circle,
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  PROFILE TAB (index 5)
// ════════════════════════════════════════════════════════════════
class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthService.instance,
      builder: (context, _) {
        final user  = AuthService.instance.user;
        final name  = user?.name  ?? 'User';
        final email = user?.email ?? '';
        final first = (user?.firstName ?? 'U')[0].toUpperCase();

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
          child: Column(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: const Color(0xFF1D4ED8),
                child: Text(
                  first,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                name,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: const TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF1D4ED8).withOpacity(0.3),
                  ),
                ),
                child: const Text(
                  'Property Manager',
                  style: TextStyle(
                    color: Color(0xFF1D4ED8),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              ...[
                ['Account Settings',   Icons.manage_accounts_outlined, Color(0xFF1D4ED8)],
                ['Notification Prefs', Icons.notifications_outlined,   Color(0xFF0891B2)],
                ['Team Members',       Icons.group_outlined,            Color(0xFF16A34A)],
                ['Pump Schedules',     Icons.schedule_outlined,         Color(0xFF7C3AED)],
                ['Alert Thresholds',   Icons.tune_rounded,              Color(0xFFEA580C)],
                ['Billing Config',     Icons.receipt_long_outlined,     Color(0xFF0E7A3E)],
                ['Help & Support',     Icons.help_outline_rounded,      Color(0xFF475569)],
                ['About Smart Meter',  Icons.info_outline_rounded,      Color(0xFF475569)],
              ].map(
                (item) => _PRow(
                  label: item[0] as String,
                  icon:  item[1] as IconData,
                  color: item[2] as Color,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await AuthService.instance.signOut();
                    if (context.mounted) {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/', (r) => false);
                    }
                  },
                  icon: const Icon(Icons.logout_rounded,
                      color: Color(0xFFDC2626), size: 18),
                  label: const Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Color(0xFFDC2626),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(
                        color: Color(0xFFDC2626), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _PRow({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFBFD7F5)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(icon, size: 17, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: const Color(0xFF475569).withOpacity(0.4),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  SMALL HELPERS
// ════════════════════════════════════════════════════════════════
class _GreetingRow extends StatelessWidget {
  final String firstName;
  const _GreetingRow({required this.firstName});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_greeting()}, $firstName 👋',
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                "Here's an overview of your Smart Meter system.",
                style: TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => replayWelcome(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFDBEAFE),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF1D4ED8).withOpacity(0.25),
              ),
            ),
            child: const Text(
              'Intro',
              style: TextStyle(
                color: Color(0xFF1D4ED8),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SecTitle extends StatelessWidget {
  final String text;
  const _SecTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 17,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.3,
          height: 1.25,
        ),
      );
}

class _P extends StatelessWidget {
  final String text;
  const _P(this.text);
  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          color: Color(0xFF475569),
          fontSize: 14,
          height: 1.75,
        ),
      );
}

class _HDivider extends StatelessWidget {
  const _HDivider();
  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: const Color(0xFFBFD7F5));
}

// ════════════════════════════════════════════════════════════════
//  PERSISTENT FOOTER — email capture + branding
// ════════════════════════════════════════════════════════════════
class _AppFooter extends StatefulWidget {
  const _AppFooter();
  @override
  State<_AppFooter> createState() => _AppFooterState();
}

class _AppFooterState extends State<_AppFooter> {
  final _emailCtrl = TextEditingController();
  bool _submitted  = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _emailCtrl.text.trim();
    final valid = RegExp(
      r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);

    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address.'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }
    setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Smart Meter App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '© 2025 Snapp Africa. All rights reserved.',
                  style: TextStyle(
                    color: Color(0xFF93C5FD),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 5,
            child: _submitted
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.check_circle_rounded,
                          color: Color(0xFF4ADE80), size: 16),
                      SizedBox(width: 6),
                      Text(
                        "Thanks! We'll be in touch.",
                        style: TextStyle(
                          color: Color(0xFF4ADE80),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 36,
                          child: TextField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter your email...',
                              hintStyle: const TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 12,
                              ),
                              filled: true,
                              fillColor: const Color(0xFF1E293B),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 36,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Subscribe',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}