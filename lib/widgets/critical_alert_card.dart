// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CRITICAL ALERT CARD  — small card shown on the dashboard
// onViewDetails: () => Navigator.push(...CriticalAlertPage...)
// ─────────────────────────────────────────────────────────────────────────────
class CriticalAlertCard extends StatelessWidget {
  final VoidCallback? onViewDetails;
  const CriticalAlertCard({super.key, this.onViewDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF6B00).withOpacity(0.08),
            const Color(0xFFFFAA00).withOpacity(0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFF6B00).withOpacity(0.30)),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B00).withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.warning_amber_rounded,
                color: Color(0xFFFF6B00), size: 22),
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
                        color: const Color(0xFFFF6B00).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        '⚠  CRITICAL',
                        style: TextStyle(
                          color: Color(0xFFFF6B00),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Today, 2:14 AM',
                      style: TextStyle(
                          color: Color(0xFF9090A0), fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                const Text(
                  'Continuous Night Flow Detected',
                  style: TextStyle(
                    color: Color(0xFF1A1A2E),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Continuous water flow detected during night hours. '
                  'Estimated loss: 128 L/day. '
                  'This increases pump runtime and costs by ~KES 45/day.',
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6A6A8A),
                      height: 1.5),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: onViewDetails,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'View Details',
                        style: TextStyle(
                          color: Color(0xFFFF6B00),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded,
                          color: Color(0xFFFF6B00), size: 13),
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
}

// ─────────────────────────────────────────────────────────────────────────────
// CRITICAL ALERT PAGE  — full bright detail screen opened on "View Details"
// Usage: Navigator.push(context, MaterialPageRoute(builder: (_) => const CriticalAlertPage()))
// ─────────────────────────────────────────────────────────────────────────────
class CriticalAlertPage extends StatelessWidget {
  final VoidCallback? onDismiss;
  const CriticalAlertPage({super.key, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Alert Details',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B00).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: const Color(0xFFFF6B00).withOpacity(0.25)),
            ),
            child: Row(
              children: const [
                Icon(Icons.circle, size: 6, color: Color(0xFFFF6B00)),
                SizedBox(width: 5),
                Text(
                  'ACTIVE',
                  style: TextStyle(
                    color: Color(0xFFFF6B00),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Banner ────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B00), Color(0xFFFFAA00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B00).withOpacity(0.30),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.water_drop_outlined,
                            color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '⚠  CRITICAL ALERT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Today, 2:14 AM',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Continuous Night\nFlow Detected',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Water has been flowing continuously between\n10 PM – 5 AM for the past 3 nights.',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Key Metrics Row ────────────────────────────────────────────
            Row(
              children: [
                _MetricTile(
                  icon: Icons.water_outlined,
                  label: 'Daily Loss',
                  value: '128 L',
                  sub: 'per day',
                  color: const Color(0xFF2196F3),
                ),
                const SizedBox(width: 12),
                _MetricTile(
                  icon: Icons.attach_money_rounded,
                  label: 'Extra Cost',
                  value: '~KES 45',
                  sub: 'per day',
                  color: const Color(0xFFFF6B00),
                ),
                const SizedBox(width: 12),
                _MetricTile(
                  icon: Icons.schedule_rounded,
                  label: 'Duration',
                  value: '3 nights',
                  sub: 'ongoing',
                  color: const Color(0xFFE91E63),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── What's Happening ───────────────────────────────────────────
            _SectionCard(
              title: "What's Happening",
              icon: Icons.info_outline_rounded,
              iconColor: const Color(0xFF2196F3),
              child: const Text(
                'Your smart meter detected uninterrupted flow in the pipe between '
                '10:00 PM and 5:00 AM. Normal household usage should drop to near zero '
                'during these hours. Continuous flow at this time strongly suggests a '
                'leaking pipe, a running toilet, an open tap, or a faulty valve somewhere '
                'in your system.',
                style: TextStyle(
                  color: Color(0xFF4A4A6A),
                  fontSize: 13.5,
                  height: 1.6,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ── Flow Timeline ──────────────────────────────────────────────
            _SectionCard(
              title: 'Night Flow Timeline (Last 3 Days)',
              icon: Icons.bar_chart_rounded,
              iconColor: const Color(0xFFFF6B00),
              child: Column(
                children: const [
                  _FlowBar(day: 'Mon 19', liters: 112, peak: 150),
                  SizedBox(height: 10),
                  _FlowBar(day: 'Tue 20', liters: 135, peak: 150),
                  SizedBox(height: 10),
                  _FlowBar(day: 'Wed 21', liters: 128, peak: 150),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── Impact Breakdown ───────────────────────────────────────────
            _SectionCard(
              title: 'Impact Breakdown',
              icon: Icons.trending_up_rounded,
              iconColor: const Color(0xFFE91E63),
              child: Column(
                children: [
                  _ImpactRow(
                    label: 'Water wasted (7 days)',
                    value: '~896 L',
                    icon: Icons.water_drop_rounded,
                    color: const Color(0xFF2196F3),
                  ),
                  const Divider(height: 20, color: Color(0xFFEEEEF5)),
                  _ImpactRow(
                    label: 'Extra pump runtime',
                    value: '+4.2 hrs/day',
                    icon: Icons.bolt_rounded,
                    color: const Color(0xFFFFAA00),
                  ),
                  const Divider(height: 20, color: Color(0xFFEEEEF5)),
                  _ImpactRow(
                    label: 'Projected monthly cost',
                    value: '~KES 1,350',
                    icon: Icons.receipt_long_rounded,
                    color: const Color(0xFFFF6B00),
                  ),
                  const Divider(height: 20, color: Color(0xFFEEEEF5)),
                  _ImpactRow(
                    label: 'Pipe pressure drop',
                    value: '0.3 bar',
                    icon: Icons.speed_rounded,
                    color: const Color(0xFFE91E63),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── Possible Causes ────────────────────────────────────────────
            _SectionCard(
              title: 'Possible Causes',
              icon: Icons.search_rounded,
              iconColor: const Color(0xFF9C27B0),
              child: Column(
                children: const [
                  _CauseRow(
                      rank: 1,
                      cause: 'Leaking toilet cistern',
                      likelihood: 'High',
                      color: Color(0xFFE91E63)),
                  SizedBox(height: 10),
                  _CauseRow(
                      rank: 2,
                      cause: 'Open or dripping outdoor tap',
                      likelihood: 'Medium',
                      color: Color(0xFFFF6B00)),
                  SizedBox(height: 10),
                  _CauseRow(
                      rank: 3,
                      cause: 'Underground pipe leak',
                      likelihood: 'Medium',
                      color: Color(0xFFFF6B00)),
                  SizedBox(height: 10),
                  _CauseRow(
                      rank: 4,
                      cause: 'Faulty float valve',
                      likelihood: 'Low',
                      color: Color(0xFF4CAF50)),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── Recommended Actions ────────────────────────────────────────
            _SectionCard(
              title: 'Recommended Actions',
              icon: Icons.task_alt_rounded,
              iconColor: const Color(0xFF4CAF50),
              child: Column(
                children: const [
                  _ActionStep(
                    step: '1',
                    title: 'Check all toilets',
                    desc:
                        'Put a few drops of food colouring in the cistern. If colour appears in the bowl without flushing, the flapper valve is leaking.',
                  ),
                  SizedBox(height: 12),
                  _ActionStep(
                    step: '2',
                    title: 'Inspect outdoor taps',
                    desc:
                        'Walk the perimeter of your property at night and check all outdoor taps and hose bibs for drips.',
                  ),
                  SizedBox(height: 12),
                  _ActionStep(
                    step: '3',
                    title: 'Read your main meter twice',
                    desc:
                        'Record the meter at 10 PM, use no water, and re-read at 11 PM. Any movement confirms a leak inside.',
                  ),
                  SizedBox(height: 12),
                  _ActionStep(
                    step: '4',
                    title: 'Call a plumber if unresolved',
                    desc:
                        'If you cannot find the source, contact a licensed plumber for a pressure test and leak detection scan.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Action Buttons ─────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B00),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.build_rounded, size: 18),
                label: const Text('Schedule a Plumber',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF4A4A6A),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side:
                          const BorderSide(color: Color(0xFFDDDDEE)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.snooze_rounded, size: 16),
                    label: const Text('Snooze 24h',
                        style: TextStyle(fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.maybePop(context);
                      onDismiss?.call();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF4CAF50),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Color(0xFF4CAF50)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 16),
                    label: const Text('Mark Resolved',
                        style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────── Helper Widgets ───────────────────────────────────

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String label, value, sub;
  final Color color;
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.sub,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5)),
            Text(sub,
                style: const TextStyle(
                    color: Color(0xFF9090A0), fontSize: 10)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    color: Color(0xFF4A4A6A),
                    fontSize: 10,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget child;
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 16),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1A1A2E),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _FlowBar extends StatelessWidget {
  final String day;
  final int liters;
  final int peak;
  const _FlowBar(
      {required this.day, required this.liters, required this.peak});

  @override
  Widget build(BuildContext context) {
    final frac = liters / peak;
    return Row(
      children: [
        SizedBox(
          width: 52,
          child: Text(day,
              style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6A6A8A),
                  fontWeight: FontWeight.w600)),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 20,
                decoration: BoxDecoration(
                    color: const Color(0xFFF0F0FA),
                    borderRadius: BorderRadius.circular(6)),
              ),
              FractionallySizedBox(
                widthFactor: frac,
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B00), Color(0xFFFFAA00)],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 40,
          child: Text('$liters L',
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFFFF6B00),
                  fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

class _ImpactRow extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _ImpactRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
            child: Text(label,
                style: const TextStyle(
                    color: Color(0xFF4A4A6A), fontSize: 13))),
        Text(value,
            style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _CauseRow extends StatelessWidget {
  final int rank;
  final String cause, likelihood;
  final Color color;
  const _CauseRow({
    required this.rank,
    required this.cause,
    required this.likelihood,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: const Color(0xFFF0F0FA),
              borderRadius: BorderRadius.circular(6)),
          child: Text('$rank',
              style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6A6A8A),
                  fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 10),
        Expanded(
            child: Text(cause,
                style: const TextStyle(
                    color: Color(0xFF1A1A2E),
                    fontSize: 13,
                    fontWeight: FontWeight.w500))),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20)),
          child: Text(likelihood,
              style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

class _ActionStep extends StatelessWidget {
  final String step, title, desc;
  const _ActionStep({
    required this.step,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(8)),
          child: Text(step,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Color(0xFF1A1A2E),
                      fontSize: 13,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              Text(desc,
                  style: const TextStyle(
                      color: Color(0xFF6A6A8A),
                      fontSize: 12,
                      height: 1.5)),
            ],
          ),
        ),
      ],
    );
  }
}