// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> with TickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;
  String _filter = 'All';

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F4FA),
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Page Header ─────────────────────────────────────────
              _PageHeader(filter: _filter, onFilterChanged: (f) => setState(() => _filter = f)),
              const SizedBox(height: 22),

              // ── Summary Row ─────────────────────────────────────────
              const _SummaryRow(),
              const SizedBox(height: 24),

              // ── Alert Cards ─────────────────────────────────────────
              if (_filter == 'All' || _filter == 'Critical')
                _AlertCard(
                  index: 0,
                  severity: AlertSeverity.critical,
                  title: 'Continuous Night Flow Detected',
                  time: 'Today, 2:14 AM',
                  description:
                      'Uninterrupted water flow detected between 12:00 AM and 5:00 AM '
                      'for 3 consecutive nights — hours when usage should be near zero.',
                  stats: const [
                    _Stat('Flow Rate', '4.2 L/min'),
                    _Stat('Daily Loss', '128 L'),
                    _Stat('Extra Cost', 'KES 45/d'),
                    _Stat('Duration', '3h 12m'),
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

              if (_filter == 'All' || _filter == 'Warning') ...[
                if (_filter == 'All') const SizedBox(height: 14),
                _AlertCard(
                  index: 1,
                  severity: AlertSeverity.warning,
                  title: 'Pump Pressure Drop',
                  time: 'Today, 6:40 AM',
                  description:
                      'Borehole pump pressure has fallen to 2.8 bar — '
                      '0.7 bar below the minimum safe threshold of 3.5 bar.',
                  stats: const [
                    _Stat('Current', '2.8 bar'),
                    _Stat('Min Safe', '3.5 bar'),
                    _Stat('Deficit', '-0.7 bar'),
                    _Stat('Pump Age', '3.2 yrs'),
                  ],
                  recommendation:
                      'Inspect the intake filter for debris. Check the pump control panel '
                      'for error codes. Schedule a full pump service if pressure does not recover within 24 hours.',
                  causes: const [
                    'Clogged intake filter — High likelihood',
                    'Pump impeller wear — Medium',
                    'Air lock in suction line — Medium',
                    'Failing motor windings — Low',
                  ],
                ),
              ],

              if (_filter == 'All' || _filter == 'Info') ...[
                if (_filter == 'All') const SizedBox(height: 14),
                _AlertCard(
                  index: 2,
                  severity: AlertSeverity.info,
                  title: 'Monthly Usage Limit at 85%',
                  time: 'Yesterday, 11:00 PM',
                  description:
                      'You have used 12,750 L of your 15,000 L monthly allocation. '
                      'At 562 L/day average, the limit will be exceeded before month end.',
                  stats: const [
                    _Stat('Used', '12,750 L'),
                    _Stat('Limit', '15,000 L'),
                    _Stat('Remaining', '2,250 L'),
                    _Stat('Days Left', '~4 days'),
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
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  PAGE HEADER
// ════════════════════════════════════════════════════════════════
class _PageHeader extends StatelessWidget {
  final String filter;
  final ValueChanged<String> onFilterChanged;
  const _PageHeader({required this.filter, required this.onFilterChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Icon badge
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFDC2626).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.notifications_active_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Active Alerts',
                    style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.6,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFFDC2626),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '3 alerts require your attention',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626).withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFDC2626).withOpacity(0.2),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 7, color: Color(0xFFDC2626)),
                  SizedBox(width: 5),
                  Text(
                    '3 ACTIVE',
                    style: TextStyle(
                      color: Color(0xFFDC2626),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Filter tabs
        Row(
          children: ['All', 'Critical', 'Warning', 'Info'].map((label) {
            final active = filter == label;
            final color = switch (label) {
              'Critical' => const Color(0xFFDC2626),
              'Warning'  => const Color(0xFFD97706),
              'Info'     => const Color(0xFF0891B2),
              _          => const Color(0xFF1D4ED8),
            };
            return GestureDetector(
              onTap: () => onFilterChanged(label),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: active ? color : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: active ? color : const Color(0xFFE2E8F0),
                    width: active ? 1.5 : 1,
                  ),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: color.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ]
                      : [],
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: active ? Colors.white : const Color(0xFF64748B),
                    fontSize: 11.5,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  SUMMARY ROW
// ════════════════════════════════════════════════════════════════
class _SummaryRow extends StatelessWidget {
  const _SummaryRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _SummaryTile(
            label: 'Critical',
            count: '1',
            icon: Icons.warning_amber_rounded,
            color: Color(0xFFDC2626),
            bg: Color(0xFFFEF2F2),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _SummaryTile(
            label: 'Warning',
            count: '1',
            icon: Icons.error_outline_rounded,
            color: Color(0xFFD97706),
            bg: Color(0xFFFFFBEB),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _SummaryTile(
            label: 'Info',
            count: '1',
            icon: Icons.info_outline_rounded,
            color: Color(0xFF0891B2),
            bg: Color(0xFFECFEFF),
          ),
        ),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label, count;
  final IconData icon;
  final Color color, bg;
  const _SummaryTile({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count,
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  height: 1.0,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  ALERT CARD
// ════════════════════════════════════════════════════════════════
enum AlertSeverity { critical, warning, info }

class _Stat {
  final String label;
  final String value;
  const _Stat(this.label, this.value);
}

class _AlertCard extends StatefulWidget {
  final int index;
  final AlertSeverity severity;
  final String title, time, description, recommendation;
  final List<_Stat> stats;
  final List<String> causes;

  const _AlertCard({
    required this.index,
    required this.severity,
    required this.title,
    required this.time,
    required this.description,
    required this.stats,
    required this.recommendation,
    required this.causes,
  });

  @override
  State<_AlertCard> createState() => _AlertCardState();
}

class _AlertCardState extends State<_AlertCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  Color get _accent => switch (widget.severity) {
        AlertSeverity.critical => const Color(0xFFDC2626),
        AlertSeverity.warning  => const Color(0xFFD97706),
        AlertSeverity.info     => const Color(0xFF0891B2),
      };

  Color get _bgLight => switch (widget.severity) {
        AlertSeverity.critical => const Color(0xFFFEF2F2),
        AlertSeverity.warning  => const Color(0xFFFFFBEB),
        AlertSeverity.info     => const Color(0xFFECFEFF),
      };

  String get _badge => switch (widget.severity) {
        AlertSeverity.critical => 'CRITICAL',
        AlertSeverity.warning  => 'WARNING',
        AlertSeverity.info     => 'INFO',
      };

  IconData get _icon => switch (widget.severity) {
        AlertSeverity.critical => Icons.warning_amber_rounded,
        AlertSeverity.warning  => Icons.error_outline_rounded,
        AlertSeverity.info     => Icons.info_outline_rounded,
      };

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _openDetail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => _AlertDetailPage(
        severity: widget.severity,
        title: widget.title,
        time: widget.time,
        description: widget.description,
        stats: widget.stats,
        recommendation: widget.recommendation,
        causes: widget.causes,
        accent: _accent,
        bgLight: _bgLight,
        badge: _badge,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnim,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _accent.withOpacity(0.14), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: _accent.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
              const BoxShadow(
                color: Color(0x08000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Coloured top stripe ──────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                decoration: BoxDecoration(
                  color: _bgLight,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  border: Border(
                    bottom: BorderSide(color: _accent.withOpacity(0.1)),
                  ),
                ),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: _accent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: _accent.withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(_icon, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: _accent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  _badge,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time_rounded,
                                    size: 11,
                                    color: Color(0xFF94A3B8),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    widget.time,
                                    style: const TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 10.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            widget.severity == AlertSeverity.critical
                                ? 'Immediate action required'
                                : widget.severity == AlertSeverity.warning
                                    ? 'Attention needed soon'
                                    : 'Monitor and plan ahead',
                            style: TextStyle(
                              color: _accent.withOpacity(0.8),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Arrow button
                    GestureDetector(
                      onTap: () => _openDetail(context),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(
                            color: _accent.withOpacity(0.2),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: _accent,
                          size: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Title + description ──────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.description,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12.5,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ── Stats ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: List.generate(widget.stats.length, (i) {
                    final s = widget.stats[i];
                    final isLast = i == widget.stats.length - 1;
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: isLast ? 0 : 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 9),
                        decoration: BoxDecoration(
                          color: _bgLight,
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(
                            color: _accent.withOpacity(0.12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.value,
                              style: TextStyle(
                                color: _accent,
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              s.label,
                              style: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 9.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // ── Divider ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Container(
                  height: 1,
                  color: const Color(0xFFE2E8F0),
                ),
              ),

              // ── Actions ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _openDetail(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _accent,
                              _accent.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: _accent.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.open_in_new_rounded,
                                size: 12, color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                              'View Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Dismiss
                    _ActionBtn(
                      label: 'Dismiss',
                      icon: Icons.close_rounded,
                      color: const Color(0xFF94A3B8),
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    // Resolve
                    _ActionBtn(
                      label: 'Resolve',
                      icon: Icons.check_rounded,
                      color: const Color(0xFF16A34A),
                      filled: true,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool filled;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: filled ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: filled ? color : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: filled ? Colors.white : color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: filled ? Colors.white : color,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  FULL DETAIL PAGE
// ════════════════════════════════════════════════════════════════
class _AlertDetailPage extends StatelessWidget {
  final AlertSeverity severity;
  final String title, time, description, recommendation, badge;
  final List<_Stat> stats;
  final List<String> causes;
  final Color accent, bgLight;

  const _AlertDetailPage({
    required this.severity,
    required this.title,
    required this.time,
    required this.description,
    required this.stats,
    required this.recommendation,
    required this.causes,
    required this.accent,
    required this.bgLight,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 16, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Alert Details',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.09),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accent.withOpacity(0.22)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 7, color: accent),
                const SizedBox(width: 5),
                Text(
                  'ACTIVE',
                  style: TextStyle(
                    color: accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
                ),
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
            // ── Hero Banner ───────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [accent, accent.withOpacity(0.75)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: accent.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.22),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded,
                              size: 12, color: Colors.white60),
                          const SizedBox(width: 4),
                          Text(
                            time,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.7,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12.5,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Stats Grid ────────────────────────────────────────
            Row(
              children: List.generate(stats.length, (i) {
                final s = stats[i];
                final isLast = i == stats.length - 1;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: isLast ? 0 : 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: accent.withOpacity(0.13)),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.value,
                          style: TextStyle(
                            color: accent,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          s.label,
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 9.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 14),

            // ── Possible Causes ───────────────────────────────────
            _DetailSection(
              title: 'POSSIBLE CAUSES',
              icon: Icons.search_rounded,
              accent: accent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: causes.asMap().entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: accent.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: accent.withOpacity(0.15),
                            ),
                          ),
                          child: Text(
                            '${e.key + 1}',
                            style: TextStyle(
                              color: accent,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            e.value,
                            style: const TextStyle(
                              color: Color(0xFF475569),
                              fontSize: 12.5,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 12),

            // ── What To Do ────────────────────────────────────────
            _DetailSection(
              title: 'RECOMMENDED ACTION',
              icon: Icons.checklist_rounded,
              accent: accent,
              child: Text(
                recommendation,
                style: const TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 12.5,
                  height: 1.65,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Actions ───────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.bolt_rounded, size: 18),
                label: const Text('Take Action Now'),
                style: FilledButton.styleFrom(
                  backgroundColor: accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(
                      fontSize: 13.5, fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.snooze_rounded, size: 16),
                    label: const Text('Snooze 24h'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF64748B),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      textStyle: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.check_circle_outline_rounded,
                        size: 16),
                    label: const Text('Mark Resolved'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF16A34A),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Color(0xFF16A34A)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      textStyle: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                    ),
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

// ── Detail Section ──────────────────────────────────────────────
class _DetailSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accent;
  final Widget child;

  const _DetailSection({
    required this.title,
    required this.icon,
    required this.accent,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(icon, size: 13, color: accent),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: accent,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}