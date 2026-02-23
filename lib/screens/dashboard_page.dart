// lib/screens/dashboard_page.dart
// ignore_for_file: deprecated_member_use, unused_element

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/borehole_system_card.dart';
import '../widgets/water_meter_card.dart';
import '../widgets/sub_meters_grid.dart';
import '../widgets/stats_row.dart';
import '../widgets/critical_alert_card.dart';

String _greeting() {
  final h = DateTime.now().hour;
  if (h < 12) return 'Good Morning';
  if (h < 17) return 'Good Afternoon';
  return 'Good Evening';
}

const _kBlue   = Color(0xFF1B4FD8);
const _kAmber  = Color(0xFFFFAA00);
const _kWhite  = Color(0xFFFFFFFF);
const _kBorder = Color(0xFFDDE3F0);
const _kText   = Color(0xFF0F172A);
const _kSub    = Color(0xFF475569);

class HomePage extends StatelessWidget {
  final VoidCallback?     onGoToAlerts;
  final PumpStateNotifier pumpState;

  const HomePage({
    super.key,
    this.onGoToAlerts,
    required this.pumpState,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthService.instance,
      builder: (context, _) {
        final firstName = AuthService.instance.user?.firstName ?? 'there';
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Greeting ─────────────────────────────────
              Text('${_greeting()}, $firstName 👋',
                  style: const TextStyle(
                      color: _kText, fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              const Text("Welcome to your Smart Meter home page.",
                  style: TextStyle(color: _kSub, fontSize: 13)),
              const SizedBox(height: 20),

              // ── About This App ────────────────────────────
              _AboutCard(),
              const SizedBox(height: 20),

              // ── Live data cards ───────────────────────────
              BoreholeSystemCard(pumpState: pumpState),
              const SizedBox(height: 16),
              WaterMeterCard(pumpState: pumpState),
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
      },
    );
  }
}

// ─── About Card ───────────────────────────────────────────────
class _AboutCard extends StatefulWidget {
  @override
  State<_AboutCard> createState() => _AboutCardState();
}

class _AboutCardState extends State<_AboutCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B4FD8), Color(0xFF0C2080)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _kBlue.withOpacity(0.30),
            blurRadius: 28,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(top: -24, right: -24,
            child: Container(width: 110, height: 110,
              decoration: BoxDecoration(shape: BoxShape.circle,
                  color: _kWhite.withOpacity(0.05)))),
          Positioned(bottom: -30, left: 40,
            child: Container(width: 80, height: 80,
              decoration: BoxDecoration(shape: BoxShape.circle,
                  color: _kAmber.withOpacity(0.07)))),

          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Header row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _kAmber.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _kAmber.withOpacity(0.4)),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Container(width: 6, height: 6,
                            decoration: const BoxDecoration(
                                color: Color(0xFF22C55E), shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        const Text('System Online',
                            style: TextStyle(color: _kAmber, fontSize: 10.5, fontWeight: FontWeight.w700)),
                      ]),
                    ),
                    const Spacer(),
                    // Expand / collapse toggle
                    GestureDetector(
                      onTap: () => setState(() => _expanded = !_expanded),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: _kWhite.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _kWhite.withOpacity(0.2)),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text(_expanded ? 'Less' : 'More',
                              style: TextStyle(
                                  color: _kWhite.withOpacity(0.8),
                                  fontSize: 10.5, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 4),
                          Icon(_expanded ? Icons.expand_less : Icons.expand_more,
                              color: _kWhite.withOpacity(0.8), size: 14),
                        ]),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Title
                const Text(
                  'Snapp Africa — Smart Meter App',
                  style: TextStyle(
                    color: _kWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 10),

                // ── Main paragraph (always visible) ──────────
                Text(
                  'The Snapp Africa Smart Meter App is a real-time borehole and water system management platform built for communities, estates, and facilities across Africa. '
                  'It gives you complete visibility and control over your water infrastructure — from tracking pump status and water levels to monitoring daily consumption across every sub-meter on your network.',
                  style: TextStyle(
                    color: _kWhite.withOpacity(0.78),
                    fontSize: 13,
                    height: 1.7,
                  ),
                ),

                // ── Expanded details ─────────────────────────
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 320),
                  crossFadeState: _expanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox(width: double.infinity),
                  secondChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        'With intelligent alerting, the app notifies you the moment something goes wrong — a pump failure, a tank overflow, or unusual water usage — so you can act before small issues become costly problems. '
                        'The analytics dashboard helps you understand consumption patterns over time, identify leaks, and generate reports that inform smarter decisions about your water resources.',
                        style: TextStyle(
                          color: _kWhite.withOpacity(0.78),
                          fontSize: 13,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Whether you manage a single borehole or a multi-site water network, this app brings everything into one clear, easy-to-use interface — making professional-grade water management accessible to everyone.',
                        style: TextStyle(
                          color: _kWhite.withOpacity(0.78),
                          fontSize: 13,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Feature chips
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: const [
                          _Chip(icon: Icons.water_drop_rounded,           label: 'Live Monitoring'),
                          _Chip(icon: Icons.bolt_rounded,                 label: 'Pump Control'),
                          _Chip(icon: Icons.analytics_rounded,            label: 'Analytics'),
                          _Chip(icon: Icons.notifications_active_rounded, label: 'Smart Alerts'),
                          _Chip(icon: Icons.people_rounded,               label: 'Multi-User'),
                          _Chip(icon: Icons.bar_chart_rounded,            label: 'Reports'),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Stats row (always visible)
                Row(children: [
                  _Stat(value: '99.9%', label: 'Uptime'),
                  const SizedBox(width: 10),
                  _Stat(value: 'Live', label: 'Monitoring'),
                  const SizedBox(width: 10),
                  _Stat(value: '<1s', label: 'Alert Time'),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Small helpers ─────────────────────────────────────────────

class _Stat extends StatelessWidget {
  final String value, label;
  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: _kWhite.withOpacity(0.10),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _kWhite.withOpacity(0.15)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value,
              style: const TextStyle(
                  color: _kWhite, fontSize: 15, fontWeight: FontWeight.w900, height: 1)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  color: _kWhite.withOpacity(0.5), fontSize: 9.5, fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String   label;
  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _kWhite.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kWhite.withOpacity(0.2)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: _kAmber, size: 13),
        const SizedBox(width: 5),
        Text(label,
            style: TextStyle(
                color: _kWhite.withOpacity(0.85),
                fontSize: 11, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}