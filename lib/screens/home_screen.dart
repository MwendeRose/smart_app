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

// ─── Design Tokens ─────────────────────────────────────────────
class AppColors {
  static const bg               = Color(0xFFEFF6FF);
  static const surface          = Color(0xFFFFFFFF);
  static const surfaceAlt       = Color(0xFFDBEAFE);
  static const border           = Color(0xFFBFD7F5);
  static const accent           = Color(0xFF2563EB);
  static const accentSoft       = Color(0x262563EB);
  static const textPrimary      = Color(0xFF0F172A);
  static const textSub          = Color(0xFF475569);
  static const textMuted        = Color(0xFF94A3B8);
  static const sidebarBg        = Color(0xFF1E40AF);
  static const sidebarSurface   = Color(0xFF1D3FAB);
  static const sidebarBorder    = Color(0xFF2D52C4);
  static const sidebarSelected  = Color(0xFF3B5FD4);
  static const sidebarText      = Color(0xFFEFF6FF);
  static const sidebarTextSub   = Color(0xFF93C5FD);
  static const sidebarIcon      = Color(0xFFBFD7F5);
  static const sidebarW         = 220.0;
  static const sidebarCollapsedW = 64.0;

  // Extended palette for the redesign
  static const cardShadow       = Color(0x141D4ED8);
  static const green            = Color(0xFF16A34A);
  static const greenSoft        = Color(0xFFDCFCE7);
  static const greenBorder      = Color(0xFF86EFAC);
  static const orange           = Color(0xFFEA580C);
  static const orangeSoft       = Color(0xFFFFF7ED);
  static const teal             = Color(0xFF0891B2);
  static const tealSoft         = Color(0xFFE0F2FE);
  static const purple           = Color(0xFF7C3AED);
  static const purpleSoft       = Color(0xFFF5F3FF);
}

// ─── Greeting helper ────────────────────────────────────────────
String _greeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good Morning';
  if (hour < 17) return 'Good Afternoon';
  return 'Good Evening';
}

// ═══════════════════════════════════════════════════════════════
//  HomeScreen — standalone shell
// ═══════════════════════════════════════════════════════════════
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pumpState = PumpStateNotifier(initiallyRunning: true);

  @override
  void dispose() {
    _pumpState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomeContentPage(
      pumpState: _pumpState,
      onGoToAlerts:    () => Navigator.of(context).maybePop(),
      onGoToAnalytics: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AnalyticsPage()),
      ),
      onGoToSettings:  () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SettingsPage()),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  HomeContentPage — the main content, reused by DashboardPage
// ═══════════════════════════════════════════════════════════════
class HomeContentPage extends StatelessWidget {
  final PumpStateNotifier pumpState;
  final VoidCallback? onGoToAlerts;
  final VoidCallback? onGoToAnalytics;
  final VoidCallback? onGoToSettings;

  const HomeContentPage({
    super.key,
    required this.pumpState,
    this.onGoToAlerts,
    this.onGoToAnalytics,
    this.onGoToSettings,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthService.instance,
      builder: (context, _) {
        final firstName = AuthService.instance.user?.firstName ?? 'there';

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Hero greeting banner ──────────────────────────
              _HeroBanner(firstName: firstName),

              // ── Content with padding ─────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // ── At a Glance ─────────────────────────────
                    _SectionLabel(
                      icon: Icons.speed_rounded,
                      label: 'At a Glance',
                      color: AppColors.accent,
                    ),
                    const SizedBox(height: 10),
                    const StatsRow(),
                    const SizedBox(height: 24),

                    // ── Active Alerts ───────────────────────────
                    _SectionLabel(
                      icon: Icons.warning_amber_rounded,
                      label: 'Active Alerts',
                      color: AppColors.orange,
                      actionLabel: 'View All',
                      onAction: onGoToAlerts,
                    ),
                    const SizedBox(height: 10),
                    CriticalAlertCard(onViewAlerts: onGoToAlerts ?? () {}),
                    const SizedBox(height: 24),

                    // ── Borehole System ─────────────────────────
                    _SectionLabel(
                      icon: Icons.water_rounded,
                      label: 'Borehole System',
                      color: AppColors.teal,
                      actionLabel: 'View Details',
                      onAction: onGoToAnalytics,
                    ),
                    const SizedBox(height: 10),
                    BoreholeSystemCard(pumpState: pumpState),
                    const SizedBox(height: 24),

                    // ── Main Water Meter ────────────────────────
                    _SectionLabel(
                      icon: Icons.water_drop_rounded,
                      label: 'Main Water Meter',
                      color: AppColors.accent,
                      actionLabel: 'View Details',
                      onAction: onGoToAnalytics,
                    ),
                    const SizedBox(height: 10),
                    WaterMeterCard(pumpState: pumpState),
                    const SizedBox(height: 24),

                    // ── Unit Sub-Meters ─────────────────────────
                    _SectionLabel(
                      icon: Icons.grid_view_rounded,
                      label: 'Unit Sub-Meters',
                      color: AppColors.purple,
                      actionLabel: 'View Details',
                      onAction: onGoToAnalytics,
                    ),
                    const SizedBox(height: 10),
                    const SubMetersGrid(),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  HERO BANNER
// ═══════════════════════════════════════════════════════════════
class _HeroBanner extends StatelessWidget {
  final String firstName;
  const _HeroBanner({required this.firstName});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final dateStr = _formatDate(now);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1E3A8A),
            Color(0xFF1D4ED8),
            Color(0xFF2563EB),
            Color(0xFF3B82F6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -30, right: -20,
            child: Container(
              width: 140, height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -40, left: -30,
            child: Container(
              width: 160, height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Positioned(
            top: 20, right: 80,
            child: Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFAA00).withOpacity(0.1),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting + live pill row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _greeting(),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$firstName 👋',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.3,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Live status badge
                    _LiveBadge(),
                  ],
                ),

                const SizedBox(height: 18),

                // Stat chips row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _HeroChip(
                        icon: Icons.calendar_today_rounded,
                        label: dateStr,
                        color: Colors.white.withOpacity(0.18),
                      ),
                      const SizedBox(width: 8),
                      _HeroChip(
                        icon: Icons.access_time_rounded,
                        label: timeStr,
                        color: Colors.white.withOpacity(0.18),
                      ),
                      const SizedBox(width: 8),
                      _HeroChip(
                        icon: Icons.water_drop_rounded,
                        label: 'Borehole Active',
                        color: const Color(0xFF16A34A).withOpacity(0.35),
                        iconColor: const Color(0xFF86EFAC),
                      ),
                      const SizedBox(width: 8),
                      _HeroChip(
                        icon: Icons.bolt_rounded,
                        label: 'Pump Running',
                        color: const Color(0xFF0891B2).withOpacity(0.35),
                        iconColor: const Color(0xFF7DD3FC),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Summary text
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          color: Color(0xFFBAE6FD), size: 15),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Live overview of your borehole & water distribution system.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    const days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    return '${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]}';
  }
}

class _LiveBadge extends StatefulWidget {
  @override
  State<_LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<_LiveBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.5, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF16A34A).withOpacity(0.25),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF86EFAC).withOpacity(0.5)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 7, height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF4ADE80).withOpacity(_pulse.value),
            ),
          ),
          const SizedBox(width: 5),
          const Text('Live',
              style: TextStyle(color: Color(0xFF86EFAC),
                  fontSize: 11, fontWeight: FontWeight.w800)),
        ]),
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color? iconColor;
  const _HeroChip({
    required this.icon,
    required this.label,
    required this.color,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 12, color: iconColor ?? Colors.white.withOpacity(0.8)),
        const SizedBox(width: 5),
        Text(label,
            style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 11,
                fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SECTION LABEL — with icon, colour accent, and optional action
// ═══════════════════════════════════════════════════════════════
class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionLabel({
    required this.icon,
    required this.label,
    required this.color,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon badge
        Container(
          width: 28, height: 28,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 15, color: color),
        ),
        const SizedBox(width: 9),
        // Label
        Text(
          label,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.1,
          ),
        ),
        const SizedBox(width: 10),
        // Divider
        Expanded(child: Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.25), Colors.transparent],
            ),
          ),
        )),
        // Action button
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onAction,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.09),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(
                  actionLabel!,
                  style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 3),
                Icon(Icons.arrow_forward_ios_rounded, size: 9, color: color),
              ]),
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Top Bar (kept for standalone / narrow use) ─────────────────
class _TopBar extends StatelessWidget {
  final String title, location;
  final VoidCallback onAlerts;
  const _TopBar({
    required this.title,
    required this.onAlerts,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final locationLabel = location.isNotEmpty ? '$location • Live' : 'Live';
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(bottom: BorderSide(color: AppColors.border, width: 1)),
        boxShadow: [
          BoxShadow(color: Colors.blue.withOpacity(0.05),
              blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(children: [
        Text(title, style: const TextStyle(color: AppColors.textPrimary,
            fontSize: 16, fontWeight: FontWeight.w600)),
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
            Text(locationLabel, style: const TextStyle(color: Color(0xFF1D4ED8),
                fontSize: 12, fontWeight: FontWeight.w500)),
          ]),
        ),
        const SizedBox(width: 12),
        Stack(clipBehavior: Clip.none, children: [
          IconButton(icon: const Icon(Icons.notifications_outlined,
              color: AppColors.textSub, size: 20), onPressed: onAlerts),
          Positioned(top: 8, right: 8,
              child: Container(width: 8, height: 8,
                  decoration: const BoxDecoration(
                      color: Color(0xFFEF4444), shape: BoxShape.circle))),
        ]),
      ]),
    );
  }
}