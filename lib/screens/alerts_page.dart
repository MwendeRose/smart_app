// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

// Pure content widget — embedded directly in HomeScreen's content area.
// NO Scaffold inside so sidebar stays visible.
class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Active Alerts',
                      style: TextStyle(
                        color: Color(0xFFE6EDF3),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      )),
                  SizedBox(height: 2),
                  Text('3 alerts require your attention.',
                      style: TextStyle(color: Color(0xFF8B949E), fontSize: 13)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0x33FF6B6B),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFF6B6B).withOpacity(0.4)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.circle, color: Color(0xFFFF6B6B), size: 8),
                    SizedBox(width: 6),
                    Text('3 Active',
                        style: TextStyle(
                            color: Color(0xFFFF6B6B),
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Critical alert
          _AlertDetailCard(
            severity: AlertSeverity.critical,
            title: 'Continuous Night Flow Detected',
            time: 'Today, 2:14 AM',
            description:
                'Continuous water flow detected during night hours (00:00–05:00). '
                'Estimated loss: 128 L/day. This increases pump runtime and '
                'electricity costs by approximately KES 45/day.',
            stats: const [
              _StatItem(label: 'Flow Rate',      value: '4.2 L/min'),
              _StatItem(label: 'Est. Daily Loss', value: '128 L'),
              _StatItem(label: 'Extra Cost',      value: 'KES 45/day'),
              _StatItem(label: 'Duration',        value: '3h 12min'),
            ],
            recommendation:
                'Check for open taps, leaking valves, or faulty float valves '
                'in Block A. Consider installing a night-flow shutoff valve.',
          ),

          const SizedBox(height: 14),

          // Warning alert
          _AlertDetailCard(
            severity: AlertSeverity.warning,
            title: 'Pump Pressure Drop',
            time: 'Today, 6:40 AM',
            description:
                'Borehole pump pressure has dropped below the recommended '
                'threshold of 3.5 bar. Current reading is 2.8 bar. This may '
                'indicate partial blockage or pump wear.',
            stats: const [
              _StatItem(label: 'Current Pressure', value: '2.8 bar'),
              _StatItem(label: 'Min Threshold',    value: '3.5 bar'),
              _StatItem(label: 'Drop',             value: '-0.7 bar'),
              _StatItem(label: 'Pump Age',         value: '3.2 yrs'),
            ],
            recommendation:
                'Schedule a pump inspection. Check the intake filter for debris. '
                'If pressure continues to drop, consider pump servicing.',
          ),

          const SizedBox(height: 14),

          // Info alert
          _AlertDetailCard(
            severity: AlertSeverity.info,
            title: 'Monthly Usage Limit: 85%',
            time: 'Yesterday, 11:00 PM',
            description:
                'Total water consumption for this month has reached 85% of '
                'the set limit (12,750 / 15,000 L). At the current rate, '
                'the limit will be reached in ~4 days.',
            stats: const [
              _StatItem(label: 'Used',      value: '12,750 L'),
              _StatItem(label: 'Limit',     value: '15,000 L'),
              _StatItem(label: 'Remaining', value: '2,250 L'),
              _StatItem(label: 'Days Left', value: '~4 days'),
            ],
            recommendation:
                'Review usage across sub-meters. Consider temporarily '
                'restricting garden irrigation to stay within the monthly allocation.',
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

/* ── Severity ── */

enum AlertSeverity { critical, warning, info }

/* ── Alert Detail Card ── */

class _AlertDetailCard extends StatefulWidget {
  final AlertSeverity severity;
  final String title;
  final String time;
  final String description;
  final List<_StatItem> stats;
  final String recommendation;

  const _AlertDetailCard({
    required this.severity,
    required this.title,
    required this.time,
    required this.description,
    required this.stats,
    required this.recommendation,
  });

  @override
  State<_AlertDetailCard> createState() => _AlertDetailCardState();
}

class _AlertDetailCardState extends State<_AlertDetailCard> {
  bool _expanded = false;

  Color get _accent => switch (widget.severity) {
        AlertSeverity.critical => const Color(0xFFF57C00),
        AlertSeverity.warning  => const Color(0xFFFFCC02),
        AlertSeverity.info     => const Color(0xFF2DD4BF),
      };

  Color get _bg => switch (widget.severity) {
        AlertSeverity.critical => const Color(0xFF1E1208),
        AlertSeverity.warning  => const Color(0xFF1A1600),
        AlertSeverity.info     => const Color(0xFF0D1E1C),
      };

  IconData get _icon => switch (widget.severity) {
        AlertSeverity.critical => Icons.warning_amber_rounded,
        AlertSeverity.warning  => Icons.error_outline_rounded,
        AlertSeverity.info     => Icons.info_outline_rounded,
      };

  String get _badge => switch (widget.severity) {
        AlertSeverity.critical => 'CRITICAL',
        AlertSeverity.warning  => 'WARNING',
        AlertSeverity.info     => 'INFO',
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _accent.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(_icon, color: _accent, size: 20),
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
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: _accent.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(_badge,
                                style: TextStyle(
                                  color: _accent,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                )),
                          ),
                          const SizedBox(width: 8),
                          Text(widget.time,
                              style: const TextStyle(
                                  color: Color(0xFF484F58), fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(widget.title,
                          style: const TextStyle(
                            color: Color(0xFFE6EDF3),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          )),
                      const SizedBox(height: 4),
                      Text(widget.description,
                          style: const TextStyle(
                            color: Color(0xFF8B949E),
                            fontSize: 12,
                            height: 1.5,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Stats grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 3.4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: widget.stats
                  .map((s) => _statBox(s))
                  .toList(),
            ),
          ),

          // Expandable recommendation
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            child: _expanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161B22),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF30363D)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('💡  Recommendation',
                              style: TextStyle(
                                color: Color(0xFF8B949E),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              )),
                          const SizedBox(height: 6),
                          Text(widget.recommendation,
                              style: const TextStyle(
                                color: Color(0xFF8B949E),
                                fontSize: 12,
                                height: 1.5,
                              )),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Footer actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: Text(
                    _expanded ? 'Hide Details ↑' : 'View Details →',
                    style: TextStyle(
                      color: _accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161B22),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF30363D)),
                    ),
                    child: const Text('Dismiss',
                        style: TextStyle(
                          color: Color(0xFF8B949E),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBox(_StatItem s) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(s.value,
              style: TextStyle(
                  color: _accent,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
          Text(s.label,
              style: const TextStyle(
                  color: Color(0xFF484F58), fontSize: 10)),
        ],
      ),
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});
}