// lib/screens/home_screen.dart
// ignore_for_file: unnecessary_underscores, deprecated_member_use, unused_import, unused_element

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/borehole_system_card.dart';
import '../widgets/water_meter_card.dart';
import '../widgets/sub_meters_grid.dart';
import '../widgets/stats_row.dart';
import '../widgets/critical_alert_card.dart';
import 'analytics.dart';
import 'settings.dart';
import 'alerts_page.dart';
import 'dashboard_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Design Tokens ───────────────────────────────────────────
class AppColors {
  static const bg          = Color(0xFFEFF6FF);
  static const surface     = Color(0xFFFFFFFF);
  static const surfaceAlt  = Color(0xFFDBEAFE);
  static const border      = Color(0xFFBFD7F5);
  static const accent      = Color(0xFF2563EB);
  static const accentSoft  = Color(0x262563EB);
  static const textPrimary = Color(0xFF0F172A);
  static const textSub     = Color(0xFF475569);
  static const textMuted   = Color(0xFF94A3B8);

  static const sidebarBg       = Color(0xFF1E40AF);
  static const sidebarSurface  = Color(0xFF1D3FAB);
  static const sidebarBorder   = Color(0xFF2D52C4);
  static const sidebarSelected = Color(0xFF3B5FD4);
  static const sidebarText     = Color(0xFFEFF6FF);
  static const sidebarTextSub  = Color(0xFF93C5FD);
  static const sidebarIcon     = Color(0xFFBFD7F5);

  static const sidebarW          = 220.0;
  static const sidebarCollapsedW = 64.0;
}

// ─── Greeting helper ─────────────────────────────────────────
String _greeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good Morning';
  if (hour < 17) return 'Good Afternoon';
  return 'Good Evening';
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int  _currentIndex    = 0;
  bool _sidebarExpanded = true;

  late AnimationController _sidebarAnim;
  late Animation<double>   _sidebarWidth;

  final _auth = AuthService.instance;
  final _pumpState = PumpStateNotifier(initiallyRunning: true);

  String _location = '';

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.home_rounded,          label: 'Home'),
    _NavItem(icon: Icons.bar_chart_rounded,     label: 'Analytics'),
    _NavItem(icon: Icons.notifications_rounded, label: 'Alerts'),
    _NavItem(icon: Icons.tune_rounded,          label: 'Settings'),
  ];

  @override
  void initState() {
    super.initState();
    _loadLocation();
    _auth.addListener(_onAuthChanged);
    _sidebarAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      value: 1.0,
    );
    _sidebarWidth = Tween<double>(
      begin: AppColors.sidebarCollapsedW,
      end:   AppColors.sidebarW,
    ).animate(CurvedAnimation(parent: _sidebarAnim, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _auth.removeListener(_onAuthChanged);
    _sidebarAnim.dispose();
    _pumpState.dispose();
    super.dispose();
  }

  Future<void> _loadLocation() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final saved = prefs.getString('estate_location') ?? '';
    setState(() {
      _location = saved.isNotEmpty ? saved : (_auth.user?.name ?? '');
    });
  }

  void _onAuthChanged() => _loadLocation();

  void _toggleSidebar() {
    setState(() => _sidebarExpanded = !_sidebarExpanded);
    _sidebarExpanded ? _sidebarAnim.forward() : _sidebarAnim.reverse();
  }

  void _goToAlerts() => setState(() => _currentIndex = 2);

  Widget _buildPage() {
    switch (_currentIndex) {
      case 0:  return HomePage(onGoToAlerts: _goToAlerts, pumpState: _pumpState);
      case 1:  return const AnalyticsPage();
      case 2:  return const AlertsPage();
      case 3:  return const SettingsPage();
      default: return HomePage(onGoToAlerts: _goToAlerts, pumpState: _pumpState);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 720;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: isWide ? _wideLayout() : _narrowLayout(),
    );
  }

  Widget _wideLayout() {
    return Row(
      children: [
        AnimatedBuilder(
          animation: _sidebarWidth,
          builder: (_, __) => ListenableBuilder(
            listenable: _auth,
            builder: (_, __) => _Sidebar(
              width:        _sidebarWidth.value,
              expanded:     _sidebarExpanded,
              currentIndex: _currentIndex,
              navItems:     _navItems,
              user:         _auth.user,
              onTap: (i) {
                if (i == 2) { _goToAlerts(); return; }
                setState(() => _currentIndex = i);
              },
              onToggle: _toggleSidebar,
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              _TopBar(
                title:    _navItems[_currentIndex].label,
                onAlerts: _goToAlerts,
                location: _location,
              ),
              Expanded(child: _buildPage()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _narrowLayout() {
    return Column(
      children: [
        _TopBar(title: _navItems[_currentIndex].label, onAlerts: _goToAlerts, location: _location),
        Expanded(child: _buildPage()),
        _BottomNav(
          currentIndex: _currentIndex,
          navItems:     _navItems,
          onTap: (i) {
            if (i == 2) { _goToAlerts(); return; }
            setState(() => _currentIndex = i);
          },
        ),
      ],
    );
  }
}

// ─── Nav Item ────────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final String   label;
  const _NavItem({required this.icon, required this.label});
}

// ─── Sidebar ─────────────────────────────────────────────────
class _Sidebar extends StatelessWidget {
  final double         width;
  final bool           expanded;
  final int            currentIndex;
  final List<_NavItem> navItems;
  final AppUser?       user;
  final ValueChanged<int> onTap;
  final VoidCallback   onToggle;

  const _Sidebar({
    required this.width,
    required this.expanded,
    required this.currentIndex,
    required this.navItems,
    required this.user,
    required this.onTap,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.sidebarBg,
        border: const Border(right: BorderSide(color: AppColors.sidebarBorder, width: 1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 16, offset: const Offset(4, 0))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Logo ─────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: expanded
                ? Column(children: [
                    Center(child: SizedBox(
                      width: 96, height: 96,
                      // ✅ FIXED: was 'assets/logo.jpeg' — only Logo.pdf exists
                      child: Image.asset(
                        'assets/Logo.pdf',
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                        isAntiAlias: true,
                        errorBuilder: (_, __, ___) => _SidebarFallbackLogo(size: 96),
                      ),
                    )),
                    const SizedBox(height: 8),
                    const Text('Smart Meter App', textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.sidebarText, fontSize: 14,
                            fontWeight: FontWeight.w700, letterSpacing: 0.3)),
                    const Text('Borehole System', textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.sidebarTextSub, fontSize: 10)),
                    const SizedBox(height: 4),
                  ])
                : Center(child: SizedBox(
                    width: 40, height: 40,
                    child: Image.asset(
                      'assets/Logo.pdf',
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      isAntiAlias: true,
                      errorBuilder: (_, __, ___) => _SidebarFallbackLogo(size: 40),
                    ),
                  )),
          ),

          const Divider(color: AppColors.sidebarBorder, height: 1),
          const SizedBox(height: 8),

          // ── Nav items ─────────────────────────────────────
          ...navItems.asMap().entries.map((e) {
            final i = e.key; final item = e.value;
            return _SidebarTile(
              icon: item.icon, label: item.label,
              selected: currentIndex == i, expanded: expanded,
              onTap: () => onTap(i), showBadge: i == 2,
            );
          }),

          const Spacer(),
          const Divider(color: AppColors.sidebarBorder, height: 1),

          // ── Collapse toggle ───────────────────────────────
          InkWell(
            onTap: onToggle,
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                Icon(
                  expanded ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
                  color: AppColors.sidebarTextSub, size: 20,
                ),
                if (expanded) ...[
                  const SizedBox(width: 10),
                  const Text('Collapse', style: TextStyle(color: AppColors.sidebarTextSub, fontSize: 13)),
                ],
              ]),
            ),
          ),

          // ── User pill ─────────────────────────────────────
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.sidebarSelected,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.sidebarBorder),
            ),
            child: Row(children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Text(user?.initials ?? '?',
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              if (expanded) ...[
                const SizedBox(width: 8),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.name ?? 'Loading...',
                        style: const TextStyle(color: AppColors.sidebarText, fontSize: 12, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis),
                    Text(user?.role ?? '',
                        style: const TextStyle(color: AppColors.sidebarTextSub, fontSize: 10),
                        overflow: TextOverflow.ellipsis),
                  ],
                )),
              ],
            ]),
          ),
        ],
      ),
    );
  }
}

// Fallback when Logo.pdf can't render (e.g. on platforms that don't support PDF)
class _SidebarFallbackLogo extends StatelessWidget {
  final double size;
  const _SidebarFallbackLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('>', style: TextStyle(
              color: const Color(0xFFFFAA00),
              fontSize: size * 0.3,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
            )),
            const SizedBox(width: 2),
            Text('S', style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.28,
              fontWeight: FontWeight.w900,
            )),
          ],
        ),
      ),
    );
  }
}

// ─── Sidebar Tile ─────────────────────────────────────────────
class _SidebarTile extends StatelessWidget {
  final IconData icon; final String label;
  final bool selected, expanded, showBadge;
  final VoidCallback onTap;

  const _SidebarTile({
    required this.icon, required this.label,
    required this.selected, required this.expanded, required this.onTap,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.sidebarSelected : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: selected ? Border.all(color: Colors.white.withOpacity(0.15)) : null,
          ),
          child: Row(children: [
            Stack(clipBehavior: Clip.none, children: [
              Icon(icon, size: 20, color: selected ? Colors.white : AppColors.sidebarIcon),
              if (showBadge) Positioned(top: -4, right: -4,
                child: Container(width: 8, height: 8,
                  decoration: const BoxDecoration(color: Color(0xFFFBBF24), shape: BoxShape.circle))),
            ]),
            if (expanded) ...[
              const SizedBox(width: 10),
              Expanded(child: Text(label, style: TextStyle(
                  color: selected ? Colors.white : AppColors.sidebarTextSub,
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal))),
              if (showBadge) Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                    color: const Color(0xFFFBBF24).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)),
                child: const Text('3', style: TextStyle(
                    color: Color(0xFFFBBF24), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ]),
        ),
      ),
    );
  }
}

// ─── Top Bar ─────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final String title, location;
  final VoidCallback onAlerts;
  const _TopBar({required this.title, required this.onAlerts, required this.location});

  @override
  Widget build(BuildContext context) {
    final locationLabel = location.isNotEmpty ? '$location • Live' : 'Live';
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(bottom: BorderSide(color: AppColors.border, width: 1)),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(children: [
        Text(title, style: const TextStyle(
            color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFBFD7F5)),
          ),
          child: Row(children: [
            Container(width: 6, height: 6,
                decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(locationLabel, style: const TextStyle(
                color: Color(0xFF1D4ED8), fontSize: 12, fontWeight: FontWeight.w500)),
          ]),
        ),
        const SizedBox(width: 12),
        Stack(clipBehavior: Clip.none, children: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.textSub, size: 20),
            onPressed: onAlerts,
          ),
          Positioned(top: 8, right: 8,
            child: Container(width: 8, height: 8,
                decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle))),
        ]),
      ]),
    );
  }
}

// ─── Bottom Nav ───────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final List<_NavItem> navItems;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.currentIndex, required this.navItems, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.sidebarBg,
        border: const Border(top: BorderSide(color: AppColors.sidebarBorder)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 56,
          child: Row(
            children: navItems.asMap().entries.map((e) {
              final selected = currentIndex == e.key;
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(e.key),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(e.value.icon, size: 20,
                          color: selected ? Colors.white : AppColors.sidebarTextSub),
                      const SizedBox(height: 3),
                      Text(e.value.label, style: TextStyle(
                          fontSize: 10,
                          color: selected ? Colors.white : AppColors.sidebarTextSub,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}