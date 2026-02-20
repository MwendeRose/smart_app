// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

// Pure content widget — embedded directly in HomeScreen's content area.
// NO Scaffold inside so sidebar stays visible.
class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F8FC),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Active Alerts',
                      style: TextStyle(
                        color: Color(0xFF1A1A2E),
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF3B3B),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          '3 alerts require your attention',
                          style: TextStyle(
                              color: Color(0xFF6A6A8A), fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEEEEF5)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.notifications_active_rounded,
                          size: 15, color: Color(0xFFFF3B3B)),
                      SizedBox(width: 6),
                      Text(
                        '3 Active',
                        style: TextStyle(
                            color: Color(0xFFFF3B3B),
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Summary chips ────────────────────────────────────────────────
            Row(
              children: [
                _SummaryChip(
                    label: '1 Critical',
                    color: const Color(0xFFFF6B00),
                    icon: Icons.warning_amber_rounded),
                const SizedBox(width: 8),
                _SummaryChip(
                    label: '1 Warning',
                    color: const Color(0xFFFFC107),
                    icon: Icons.error_outline_rounded),
                const SizedBox(width: 8),
                _SummaryChip(
                    label: '1 Info',
                    color: const Color(0xFF00BCD4),
                    icon: Icons.info_outline_rounded),
              ],
            ),

            const SizedBox(height: 20),

            // ── Critical ─────────────────────────────────────────────────────
            _AlertDetailCard(
              severity: AlertSeverity.critical,
              title: 'Continuous Night Flow Detected',
              time: 'Today, 2:14 AM',
              description:
                  'Your smart meter detected uninterrupted water flow between '
                  '12:00 AM and 5:00 AM — hours when usage should be near zero. '
                  'This pattern has persisted for 3 consecutive nights.',
              stats: const [
                _StatItem(label: 'Flow Rate',  value: '4.2 L/min', icon: Icons.water_outlined),
                _StatItem(label: 'Daily Loss', value: '128 L',     icon: Icons.water_drop_rounded),
                _StatItem(label: 'Extra Cost', value: 'KES 45/d',  icon: Icons.attach_money_rounded),
                _StatItem(label: 'Duration',   value: '3h 12m',    icon: Icons.schedule_rounded),
              ],
              recommendation:
                  'Check all toilets for running cisterns, inspect outdoor taps '
                  'and hose bibs after dark, and read your main meter twice '
                  '(1 hr apart, no usage) to confirm a leak.',
              causes: const [
                'Leaking toilet cistern — High likelihood',
                'Open outdoor tap or hose bib — Medium',
                'Underground pipe leak — Medium',
                'Faulty float valve — Low',
              ],
            ),

            const SizedBox(height: 12),

            // ── Warning ──────────────────────────────────────────────────────
            _AlertDetailCard(
              severity: AlertSeverity.warning,
              title: 'Pump Pressure Drop',
              time: 'Today, 6:40 AM',
              description:
                  'Your borehole pump pressure has fallen to 2.8 bar — '
                  '0.7 bar below the minimum safe threshold of 3.5 bar. '
                  'Low pressure reduces water delivery to upper floors.',
              stats: const [
                _StatItem(label: 'Current',  value: '2.8 bar',  icon: Icons.speed_rounded),
                _StatItem(label: 'Min Safe', value: '3.5 bar',  icon: Icons.verified_outlined),
                _StatItem(label: 'Deficit',  value: '-0.7 bar', icon: Icons.trending_down_rounded),
                _StatItem(label: 'Pump Age', value: '3.2 yrs',  icon: Icons.build_outlined),
              ],
              recommendation:
                  'Inspect the intake filter for debris and clear if blocked. '
                  'Check the pump control panel for error codes. '
                  'Schedule a full pump service if pressure does not recover within 24 hours.',
              causes: const [
                'Clogged intake filter — High likelihood',
                'Pump impeller wear — Medium',
                'Air lock in suction line — Medium',
                'Failing motor windings — Low',
              ],
            ),

            const SizedBox(height: 12),

            // ── Info ─────────────────────────────────────────────────────────
            _AlertDetailCard(
              severity: AlertSeverity.info,
              title: 'Monthly Usage Limit at 85%',
              time: 'Yesterday, 11:00 PM',
              description:
                  'You have used 12,750 L of your 15,000 L monthly allocation. '
                  'At the current daily average of 562 L, '
                  'you will exceed your limit before the month ends.',
              stats: const [
                _StatItem(label: 'Used',      value: '12,750 L', icon: Icons.water_drop_rounded),
                _StatItem(label: 'Limit',     value: '15,000 L', icon: Icons.data_usage_rounded),
                _StatItem(label: 'Remaining', value: '2,250 L',  icon: Icons.hourglass_bottom_rounded),
                _StatItem(label: 'Days Left', value: '~4 days',  icon: Icons.calendar_today_rounded),
              ],
              recommendation:
                  'Review sub-meter data to identify the highest-consuming zones. '
                  'Temporarily suspend garden irrigation and non-essential uses.',
              causes: const [
                'Garden irrigation running daily — Review schedule',
                'High usage in Block A — Check sub-meter',
                'Possible slow leak contributing — Monitor overnight',
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/* ── Summary Chip ── */

class _SummaryChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  const _SummaryChip(
      {required this.label, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

/* ── Severity ── */

enum AlertSeverity { critical, warning, info }

/* ── Alert Detail Card ── */

class _AlertDetailCard extends StatelessWidget {
  final AlertSeverity severity;
  final String title;
  final String time;
  final String description;
  final List<_StatItem> stats;
  final String recommendation;
  final List<String> causes;

  const _AlertDetailCard({
    required this.severity,
    required this.title,
    required this.time,
    required this.description,
    required this.stats,
    required this.recommendation,
    required this.causes,
  });

  Color get _accent => switch (severity) {
        AlertSeverity.critical => const Color(0xFFFF6B00),
        AlertSeverity.warning  => const Color(0xFFFFC107),
        AlertSeverity.info     => const Color(0xFF00BCD4),
      };

  Color get _accentLight => switch (severity) {
        AlertSeverity.critical => const Color(0xFFFF8C00),
        AlertSeverity.warning  => const Color(0xFFFFD54F),
        AlertSeverity.info     => const Color(0xFF4DD0E1),
      };

  Color get _bgLight => switch (severity) {
        AlertSeverity.critical => const Color(0xFFFFF4ED),
        AlertSeverity.warning  => const Color(0xFFFFFBE6),
        AlertSeverity.info     => const Color(0xFFE8FAFE),
      };

  IconData get _icon => switch (severity) {
        AlertSeverity.critical => Icons.warning_amber_rounded,
        AlertSeverity.warning  => Icons.error_outline_rounded,
        AlertSeverity.info     => Icons.info_outline_rounded,
      };

  String get _badge => switch (severity) {
        AlertSeverity.critical => 'CRITICAL',
        AlertSeverity.warning  => 'WARNING',
        AlertSeverity.info     => 'INFO',
      };

  String get _severityLabel => switch (severity) {
        AlertSeverity.critical => 'Immediate action required.',
        AlertSeverity.warning  => 'Attention needed soon.',
        AlertSeverity.info     => 'Monitor and plan ahead.',
      };

  void _openDetail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => _AlertFullPage(
        severity: severity,
        title: title,
        time: time,
        description: description,
        stats: stats,
        recommendation: recommendation,
        causes: causes,
        accent: _accent,
        accentLight: _accentLight,
        bgLight: _bgLight,
        icon: _icon,
        badge: _badge,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetail(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _accent.withOpacity(0.20)),
          boxShadow: [
            BoxShadow(
                color: _accent.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Severity Banner ────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: _bgLight,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _accent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Icon(_icon, color: _accent, size: 15),
                  ),
                  const SizedBox(width: 9),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _accent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(_badge,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                )),
                          ),
                          const SizedBox(width: 7),
                          Text(time,
                              style: const TextStyle(
                                  color: Color(0xFF9090A0), fontSize: 10)),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Text(_severityLabel,
                          style: TextStyle(
                              color: _accent,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const Spacer(),
                  Icon(Icons.chevron_right_rounded,
                      color: _accent.withOpacity(0.5), size: 18),
                ],
              ),
            ),

            // ── Title + Description ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 11, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        color: Color(0xFF1A1A2E),
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      )),
                  const SizedBox(height: 5),
                  Text(description,
                      style: const TextStyle(
                        color: Color(0xFF4A4A6A),
                        fontSize: 12,
                        height: 1.5,
                      )),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ── Mini Stats Row (compact, no grid) ─────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: stats.map((s) {
                  final isLast = s == stats.last;
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: isLast ? 0 : 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 6),
                      decoration: BoxDecoration(
                        color: _bgLight,
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: _accent.withOpacity(0.15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.value,
                              style: TextStyle(
                                  color: _accent,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.2)),
                          Text(s.label,
                              style: const TextStyle(
                                  color: Color(0xFF9090A0),
                                  fontSize: 9)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // ── Footer ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _accent.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: _accent.withOpacity(0.20)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.open_in_full_rounded,
                            size: 11, color: _accent),
                        const SizedBox(width: 5),
                        Text('View Details',
                            style: TextStyle(
                              color: _accent,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            )),
                      ],
                    ),
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF9090A0),
                      side: const BorderSide(color: Color(0xFFDDDDEE)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 11, vertical: 5),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Dismiss',
                        style: TextStyle(fontSize: 11)),
                  ),
                  const SizedBox(width: 7),
                  FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: _accent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 11, vertical: 5),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Resolve',
                        style: TextStyle(fontSize: 11)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ─────────────────────────── Full Detail Page ──────────────────────────────── */

class _AlertFullPage extends StatelessWidget {
  final AlertSeverity severity;
  final String title, time, description, recommendation, badge;
  final List<_StatItem> stats;
  final List<String> causes;
  final Color accent, accentLight, bgLight;
  final IconData icon;

  const _AlertFullPage({
    required this.severity,
    required this.title,
    required this.time,
    required this.description,
    required this.stats,
    required this.recommendation,
    required this.causes,
    required this.accent,
    required this.accentLight,
    required this.bgLight,
    required this.icon,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 17, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Alert Details',
            style: TextStyle(
              color: Color(0xFF1A1A2E),
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            )),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accent.withOpacity(0.25)),
            ),
            child: Row(
              children: [
                Icon(Icons.circle, size: 6, color: accent),
                const SizedBox(width: 5),
                Text('ACTIVE',
                    style: TextStyle(
                      color: accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    )),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Banner ──────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accent, accentLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: accent.withOpacity(0.28),
                      blurRadius: 18,
                      offset: const Offset(0, 7))
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
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child:
                            Icon(icon, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(badge,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2)),
                          const SizedBox(height: 1),
                          Text(time,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        letterSpacing: -0.4,
                      )),
                  const SizedBox(height: 6),
                  Text(description,
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12.5,
                          height: 1.5)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Compact stats row ────────────────────────────────────────
            Row(
              children: stats.map((s) {
                final isLast = s == stats.last;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: isLast ? 0 : 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: accent.withOpacity(0.15)),
                      boxShadow: [
                        BoxShadow(
                            color: accent.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 3))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(s.icon, size: 13, color: accentLight),
                        const SizedBox(height: 5),
                        Text(s.value,
                            style: TextStyle(
                                color: accent,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.2)),
                        Text(s.label,
                            style: const TextStyle(
                                color: Color(0xFF9090A0), fontSize: 9)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 14),

            // ── Possible Causes ──────────────────────────────────────────
            _FullPageSection(
              title: 'Possible Causes',
              icon: Icons.search_rounded,
              accent: accent,
              child: Column(
                children: causes.asMap().entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 19,
                          height: 19,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: accent.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text('${e.key + 1}',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: accent,
                                  fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(e.value,
                              style: const TextStyle(
                                  color: Color(0xFF4A4A6A),
                                  fontSize: 12.5,
                                  height: 1.4)),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 12),

            // ── Recommendation ───────────────────────────────────────────
            _FullPageSection(
              title: 'What To Do',
              icon: Icons.task_alt_rounded,
              accent: accent,
              child: Text(recommendation,
                  style: const TextStyle(
                      color: Color(0xFF4A4A6A),
                      fontSize: 12.5,
                      height: 1.6)),
            ),

            const SizedBox(height: 22),

            // ── Action Buttons ───────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: accent,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.build_rounded, size: 16),
                label: const Text('Take Action',
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 9),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF4A4A6A),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      side: const BorderSide(color: Color(0xFFDDDDEE)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.snooze_rounded, size: 15),
                    label: const Text('Snooze 24h',
                        style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.maybePop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF4CAF50),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      side: const BorderSide(color: Color(0xFF4CAF50)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.check_circle_outline_rounded,
                        size: 15),
                    label: const Text('Mark Resolved',
                        style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _FullPageSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accent;
  final Widget child;
  const _FullPageSection({
    required this.title,
    required this.icon,
    required this.accent,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: accent),
              const SizedBox(width: 6),
              Text(title,
                  style: TextStyle(
                      color: accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

/* ── Stat Item ── */

class _StatItem {
  final String label;
  final String value;
  final IconData icon;
  const _StatItem(
      {required this.label, required this.value, required this.icon});
}