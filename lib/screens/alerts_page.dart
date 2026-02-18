// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Alerts'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.yellow,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Active Alerts',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.5)),
                  ),
                  child: const Text(
                    '3 Active',
                    style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Critical alert — matches CriticalAlertCard content
            _AlertDetailCard(
              severity: AlertSeverity.critical,
              title: 'Continuous Night Flow Detected',
              time: 'Today, 2:14 AM',
              description:
                  'Continuous water flow detected during night hours (00:00–05:00). '
                  'Estimated loss: 128 L/day. This increases pump runtime and electricity '
                  'costs by approximately KES 45/day.',
              stats: const [
                _StatItem(label: 'Flow Rate', value: '4.2 L/min'),
                _StatItem(label: 'Est. Daily Loss', value: '128 L'),
                _StatItem(label: 'Extra Cost', value: 'KES 45/day'),
                _StatItem(label: 'Duration', value: '3h 12min'),
              ],
              recommendation:
                  'Check for open taps, leaking valves, or faulty float valves in Block A. '
                  'Consider installing a night-flow shutoff valve.',
            ),

            const SizedBox(height: 14),

            // Warning alert
            _AlertDetailCard(
              severity: AlertSeverity.warning,
              title: 'Pump Pressure Drop',
              time: 'Today, 6:40 AM',
              description:
                  'Borehole pump pressure has dropped below the recommended threshold of 3.5 bar. '
                  'Current reading is 2.8 bar. This may indicate partial blockage or pump wear.',
              stats: const [
                _StatItem(label: 'Current Pressure', value: '2.8 bar'),
                _StatItem(label: 'Min Threshold', value: '3.5 bar'),
                _StatItem(label: 'Drop', value: '-0.7 bar'),
                _StatItem(label: 'Pump Age', value: '3.2 yrs'),
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
                  'Total water consumption for this month has reached 85% of the set limit '
                  '(12,750 / 15,000 L). At the current rate, the limit will be reached in ~4 days.',
              stats: const [
                _StatItem(label: 'Used', value: '12,750 L'),
                _StatItem(label: 'Limit', value: '15,000 L'),
                _StatItem(label: 'Remaining', value: '2,250 L'),
                _StatItem(label: 'Days Left', value: '~4 days'),
              ],
              recommendation:
                  'Review usage across sub-meters. Consider temporarily restricting garden '
                  'irrigation to stay within the monthly allocation.',
            ),
          ],
        ),
      ),
    );
  }
}

/* ── Severity enum ── */

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

  Color get _accentColor => switch (widget.severity) {
        AlertSeverity.critical => const Color(0xFFF57C00),
        AlertSeverity.warning  => const Color(0xFFFFCC02),
        AlertSeverity.info     => const Color(0xFF1565C0),
      };

  Color get _bgColor => switch (widget.severity) {
        AlertSeverity.critical => const Color(0xFF2A1500),
        AlertSeverity.warning  => const Color(0xFF1A1600),
        AlertSeverity.info     => const Color(0xFF001228),
      };

  IconData get _icon => switch (widget.severity) {
        AlertSeverity.critical => Icons.warning_amber_rounded,
        AlertSeverity.warning  => Icons.error_outline,
        AlertSeverity.info     => Icons.info_outline,
      };

  String get _badge => switch (widget.severity) {
        AlertSeverity.critical => 'CRITICAL',
        AlertSeverity.warning  => 'WARNING',
        AlertSeverity.info     => 'INFO',
      };

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _accentColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ──
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(_icon, color: _accentColor, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _accentColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _badge,
                              style: TextStyle(
                                color: _accentColor,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.time,
                            style: const TextStyle(color: Colors.white38, fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.description,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Stats grid ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 3.2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: widget.stats.map((s) => _statBox(s, _accentColor)).toList(),
            ),
          ),

          // ── Expandable recommendation ──
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '💡 Recommendation',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.recommendation,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── Footer actions ──
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _expanded = !_expanded),
                  child: Text(
                    _expanded ? 'Hide Details ↑' : 'View Details →',
                    style: TextStyle(
                      color: _accentColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _accentColor.withOpacity(0.4)),
                    ),
                    child: Text(
                      'Dismiss',
                      style: TextStyle(
                        color: _accentColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
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

  Widget _statBox(_StatItem s, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(s.value,
              style: TextStyle(
                  color: accent, fontSize: 13, fontWeight: FontWeight.bold)),
          Text(s.label,
              style: const TextStyle(color: Colors.white38, fontSize: 10)),
        ],
      ),
    );
  }
}

/* ── Stat item data class ── */

class _StatItem {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});
}