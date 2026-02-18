import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
// AnalyticsPage — pure content widget, NO Scaffold inside.
// Embedded directly into HomeScreen's body via _pages list.
// ─────────────────────────────────────────────────────────────
class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  String _selectedPeriod = 'Weekly';
  final List<String> _periods = ['Daily', 'Weekly', 'Monthly', 'Yearly'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Water Analytics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20),
                  border:
                      // ignore: deprecated_member_use
                      Border.all(color: Colors.yellow.withOpacity(0.4)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedPeriod,
                    dropdownColor: Colors.grey[900],
                    style:
                        const TextStyle(color: Colors.yellow, fontSize: 13),
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: Colors.yellow, size: 18),
                    items: _periods
                        .map((p) =>
                            DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (val) =>
                        setState(() => _selectedPeriod = val!),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Summary cards row 1
          Row(
            children: [
              _SummaryCard(
                label: 'Total Usage',
                value: '12,450 L',
                icon: Icons.water_drop,
                trend: '+5.2%',
                isPositive: false,
              ),
              const SizedBox(width: 12),
              _SummaryCard(
                label: 'Avg Daily',
                value: '1,778 L',
                icon: Icons.show_chart,
                trend: '-2.1%',
                isPositive: true,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Summary cards row 2
          Row(
            children: [
              _SummaryCard(
                label: 'Peak Hour',
                value: '6:00 AM',
                icon: Icons.schedule,
                trend: 'Morning',
                isPositive: true,
              ),
              const SizedBox(width: 12),
              _SummaryCard(
                label: 'Efficiency',
                value: '87%',
                icon: Icons.bolt,
                trend: '+3.4%',
                isPositive: true,
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            'Daily Usage (Litres)',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white70),
          ),
          const SizedBox(height: 12),
          const _UsageBarChart(),

          const SizedBox(height: 24),

          const Text(
            'Sub-Meter Breakdown',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white70),
          ),
          const SizedBox(height: 12),
          const _SubMeterBreakdown(),

          const SizedBox(height: 24),

          const Text(
            'Monthly Consumption Trend',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white70),
          ),
          const SizedBox(height: 12),
          const _ConsumptionTrend(),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/* ── Summary Card ── */

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final String trend;
  final bool isPositive;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.trend,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: Colors.yellow, size: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isPositive
                        // ignore: deprecated_member_use
                        ? Colors.green.withOpacity(0.15)
                        // ignore: deprecated_member_use
                        : Colors.red.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    trend,
                    style: TextStyle(
                      fontSize: 10,
                      color: isPositive
                          ? Colors.greenAccent
                          : Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 2),
            Text(label,
                style:
                    const TextStyle(fontSize: 11, color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}

/* ── Usage Bar Chart ── */

class _UsageBarChart extends StatelessWidget {
  const _UsageBarChart();

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final values = [1200.0, 1800.0, 1500.0, 2100.0, 1700.0, 900.0, 1250.0];
    final maxVal = values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: SizedBox(
        height: 140,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(days.length, (i) {
            final ratio = values[i] / maxVal;
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${(values[i] / 1000).toStringAsFixed(1)}k',
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 9),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 28,
                  height: 100 * ratio,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        // ignore: deprecated_member_use
                        Colors.yellow.withOpacity(0.9),
                        // ignore: deprecated_member_use
                        Colors.yellow.withOpacity(0.4),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Text(days[i],
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 10)),
              ],
            );
          }),
        ),
      ),
    );
  }
}

/* ── Sub-meter Breakdown ── */

class _SubMeterBreakdown extends StatelessWidget {
  const _SubMeterBreakdown();

  @override
  Widget build(BuildContext context) {
    final meters = [
      {'name': 'Block A', 'usage': 3200.0, 'percent': 0.72},
      {'name': 'Block B', 'usage': 2850.0, 'percent': 0.64},
      {'name': 'Commercial', 'usage': 1900.0, 'percent': 0.43},
      {'name': 'Garden', 'usage': 800.0, 'percent': 0.18},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: meters.map((m) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(m['name'] as String,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 13)),
                    Text(
                        '${(m['usage'] as double).toStringAsFixed(0)} L',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: m['percent'] as double,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.yellow),
                    minHeight: 7,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

/* ── Monthly Consumption Trend ── */

class _ConsumptionTrend extends StatelessWidget {
  const _ConsumptionTrend();

  @override
  Widget build(BuildContext context) {
    final months = ['Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Jan'];
    final values = [9800.0, 10200.0, 11500.0, 10800.0, 12100.0, 12450.0];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: List.generate(months.length, (i) {
          final isLast = i == months.length - 1;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Text(
                    months[i],
                    style: TextStyle(
                      color: isLast ? Colors.yellow : Colors.white54,
                      fontSize: 12,
                      fontWeight: isLast
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: values[i] / 14000,
                      backgroundColor: Colors.white12,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isLast
                            ? Colors.yellow
                            // ignore: deprecated_member_use
                            : Colors.yellow.withOpacity(0.5),
                      ),
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 52,
                  child: Text(
                    '${(values[i] / 1000).toStringAsFixed(1)}k L',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: isLast ? Colors.yellow : Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}