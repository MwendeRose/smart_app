// ignore_for_file: unnecessary_underscores, deprecated_member_use

import 'package:flutter/material.dart';
import '../widgets/borehole_system_card.dart';
import '../widgets/water_meter_card.dart';
import '../widgets/stats_row.dart';
import '../widgets/critical_alert_card.dart';
import '../widgets/sub_meters_grid.dart';
import 'analytics.dart';
import 'settings.dart';
import 'alerts_page.dart';

// ─── Design Tokens ───────────────────────────────────────────
// Deep navy/slate dark theme with teal accent
class AppColors {
  static const bg          = Color(0xFF0D1117); // deep charcoal
  static const surface     = Color(0xFF161B22); // card surface
  static const surfaceAlt  = Color(0xFF1C2333); // slightly lighter
  static const border      = Color(0xFF30363D); // subtle borders
  static const accent      = Color(0xFF2DD4BF); // teal accent
  static const accentSoft  = Color(0x262DD4BF); // teal 15% opacity
  static const textPrimary = Color(0xFFE6EDF3); // near-white
  static const textSub     = Color(0xFF8B949E); // muted grey
  static const textMuted   = Color(0xFF484F58); // very muted
  static const sidebarW    = 220.0;
  static const sidebarCollapsedW = 64.0;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _sidebarExpanded = true;
  late AnimationController _sidebarAnim;
  late Animation<double> _sidebarWidth;

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.dashboard_rounded,      label: 'Dashboard'),
    _NavItem(icon: Icons.bar_chart_rounded,       label: 'Analytics'),
    _NavItem(icon: Icons.notifications_rounded,   label: 'Alerts'),
    _NavItem(icon: Icons.tune_rounded,            label: 'Settings'),
  ];

  @override
  void initState() {
    super.initState();
    _sidebarAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      value: 1.0,
    );
    _sidebarWidth = Tween<double>(
      begin: AppColors.sidebarCollapsedW,
      end: AppColors.sidebarW,
    ).animate(CurvedAnimation(parent: _sidebarAnim, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _sidebarAnim.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() => _sidebarExpanded = !_sidebarExpanded);
    _sidebarExpanded ? _sidebarAnim.forward() : _sidebarAnim.reverse();
  }

  void _goToAlerts() {
    setState(() => _currentIndex = 2);
  }

  Widget _buildPage() {
    switch (_currentIndex) {
      case 0: return _DashboardPage(onGoToAlerts: _goToAlerts);
      case 1: return const AnalyticsPage();
      case 2: return const AlertsPage();
      case 3: return const SettingsPage();
      default: return _DashboardPage(onGoToAlerts: _goToAlerts);
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

  // ── Wide layout: sidebar + content ──
  Widget _wideLayout() {
    return Row(
      children: [
        AnimatedBuilder(
          animation: _sidebarWidth,
          builder: (_, __) => _Sidebar(
            width: _sidebarWidth.value,
            expanded: _sidebarExpanded,
            currentIndex: _currentIndex,
            navItems: _navItems,
            onTap: (i) {
              if (i == 2) { _goToAlerts(); return; }
              setState(() => _currentIndex = i);
            },
            onToggle: _toggleSidebar,
          ),
        ),
        Expanded(
          child: Column(
            children: [
              _TopBar(
                title: _navItems[_currentIndex].label,
                onAlerts: _goToAlerts,
              ),
              Expanded(child: _buildPage()),
            ],
          ),
        ),
      ],
    );
  }

  // ── Narrow layout: bottom nav ──
  Widget _narrowLayout() {
    return Column(
      children: [
        _TopBar(
          title: _navItems[_currentIndex].label,
          onAlerts: _goToAlerts,
        ),
        Expanded(child: _buildPage()),
        _BottomNav(
          currentIndex: _currentIndex,
          navItems: _navItems,
          onTap: (i) {
            if (i == 2) { _goToAlerts(); return; }
            setState(() => _currentIndex = i);
          },
        ),
      ],
    );
  }
}

// ─── Sidebar ─────────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class _Sidebar extends StatelessWidget {
  final double width;
  final bool expanded;
  final int currentIndex;
  final List<_NavItem> navItems;
  final ValueChanged<int> onTap;
  final VoidCallback onToggle;

  const _Sidebar({
    required this.width,
    required this.expanded,
    required this.currentIndex,
    required this.navItems,
    required this.onTap,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo area
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.water_drop_rounded,
                      color: Colors.white, size: 18),
                ),
                if (expanded) ...[
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Maji Smart',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            )),
                        Text('Borehole System',
                            style: TextStyle(
                                color: AppColors.textSub, fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 8),

          // Nav items
          ...navItems.asMap().entries.map((e) {
            final i = e.key;
            final item = e.value;
            final selected = currentIndex == i;
            return _SidebarTile(
              icon: item.icon,
              label: item.label,
              selected: selected,
              expanded: expanded,
              onTap: () => onTap(i),
              showBadge: i == 2,
            );
          }),

          const Spacer(),
          const Divider(color: AppColors.border, height: 1),

          // Collapse toggle
          InkWell(
            onTap: onToggle,
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(
                    expanded
                        ? Icons.chevron_left_rounded
                        : Icons.chevron_right_rounded,
                    color: AppColors.textSub,
                    size: 20,
                  ),
                  if (expanded) ...[
                    const SizedBox(width: 10),
                    const Text('Collapse',
                        style: TextStyle(
                            color: AppColors.textSub, fontSize: 13)),
                  ],
                ],
              ),
            ),
          ),

          // User pill
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.accentSoft,
                  child: const Text('JK',
                      style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                ),
                if (expanded) ...[
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('John Kamau',
                            style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                        Text('Admin',
                            style: TextStyle(
                                color: AppColors.textSub, fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool expanded;
  final bool showBadge;
  final VoidCallback onTap;

  const _SidebarTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.expanded,
    required this.onTap,
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
            color: selected ? AppColors.accentSoft : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: selected
                ? Border.all(color: AppColors.accent.withOpacity(0.3))
                : null,
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon,
                      size: 20,
                      color: selected
                          ? AppColors.accent
                          : AppColors.textSub),
                  if (showBadge)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF6B6B),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              if (expanded) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: selected
                          ? AppColors.accent
                          : AppColors.textSub,
                      fontSize: 13,
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
                if (showBadge)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0x33FF6B6B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('3',
                        style: TextStyle(
                            color: Color(0xFFFF6B6B),
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Top Bar ─────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final String title;
  final VoidCallback onAlerts;

  const _TopBar({required this.title, required this.onAlerts});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          // Greeting chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3FB950),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Ngara Estate • Live',
                  style: TextStyle(color: AppColors.textSub, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Alerts bell
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.textSub, size: 20),
                onPressed: onAlerts,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF6B6B),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Bottom Nav (narrow screens) ─────────────────────────────

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final List<_NavItem> navItems;
  final ValueChanged<int> onTap;

  const _BottomNav({
    required this.currentIndex,
    required this.navItems,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
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
                      Icon(e.value.icon,
                          size: 20,
                          color: selected
                              ? AppColors.accent
                              : AppColors.textMuted),
                      const SizedBox(height: 3),
                      Text(e.value.label,
                          style: TextStyle(
                            fontSize: 10,
                            color: selected
                                ? AppColors.accent
                                : AppColors.textMuted,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          )),
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

// ─── Dashboard Page ──────────────────────────────────────────

class _DashboardPage extends StatelessWidget {
  final VoidCallback? onGoToAlerts;
  const _DashboardPage({this.onGoToAlerts});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Good Afternoon, John',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Here\'s your borehole system overview for today.',
            style: TextStyle(color: AppColors.textSub, fontSize: 13),
          ),
          const SizedBox(height: 20),
          const BoreholeSystemCard(),
          const SizedBox(height: 16),
          const WaterMeterCard(),
          const SizedBox(height: 16),
          const StatsRow(),
          const SizedBox(height: 16),
          CriticalAlertCard(onViewDetails: onGoToAlerts),
          const SizedBox(height: 16),
          const SubMetersGrid(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}