// ignore_for_file: deprecated_member_use, unused_field

import 'package:flutter/material.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage>
    with SingleTickerProviderStateMixin {
  String _selectedPeriod = 'Weekly';
  final List<String> _periods = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim =
        CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }


  static const _bg        = Color(0xFFF7F8FC);
  static const _surface   = Color(0xFFFFFFFF);
  static const _blue      = Color(0xFF2563EB);
  static const _blueSoft  = Color(0xFFEFF6FF);
  static const _blueBdr   = Color(0xFFBFD7F5);
  static const _teal      = Color(0xFF0D9488);
  static const _tealSoft  = Color(0xFFECFDF5);
  static const _amber     = Color(0xFFF59E0B);
  static const _amberSoft = Color(0xFFFFFBEB);
  static const _orange    = Color(0xFFFF6B00);
  static const _orangeSoft= Color(0xFFFFF3E8);
  static const _purple    = Color(0xFF7C3AED);
  static const _purpleSoft= Color(0xFFF5F3FF);
  static const _green     = Color(0xFF15803D);
  static const _greenSoft = Color(0xFFDCFCE7);
  static const _greenBdr  = Color(0xFF86EFAC);
  static const _red       = Color(0xFFDC2626);
  static const _redSoft   = Color(0xFFFEE2E2);
  static const _textPri   = Color(0xFF0F172A);
  static const _textSub   = Color(0xFF475569);
  static const _textMuted = Color(0xFF94A3B8);
  static const _border    = Color(0xFFE8EDF5);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Container(
        color: _bg,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Page header ─────────────────────────────────
              _PageHeader(
                selectedPeriod: _selectedPeriod,
                periods: _periods,
                onPeriodChanged: (v) => setState(() => _selectedPeriod = v!),
              ),

              const SizedBox(height: 20),

              // ── KPI cards ───────────────────────────────────
              Row(children: [
                _KpiCard(
                  label: 'Total Usage',
                  value: '12,450',
                  unit: 'Litres',
                  icon: Icons.water_drop_rounded,
                  trend: '+5.2%',
                  trendUp: false,
                  color: _blue,
                  softColor: _blueSoft,
                  borderColor: _blueBdr,
                ),
                const SizedBox(width: 12),
                _KpiCard(
                  label: 'Avg Daily',
                  value: '1,778',
                  unit: 'L/day',
                  icon: Icons.show_chart_rounded,
                  trend: '-2.1%',
                  trendUp: true,
                  color: _teal,
                  softColor: _tealSoft,
                  borderColor: const Color(0xFF99F6E4),
                ),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                _KpiCard(
                  label: 'Peak Hour',
                  value: '6:00',
                  unit: 'AM · Morning',
                  icon: Icons.wb_sunny_rounded,
                  trend: 'Consistent',
                  trendUp: true,
                  color: _amber,
                  softColor: _amberSoft,
                  borderColor: const Color(0xFFFDE68A),
                ),
                const SizedBox(width: 12),
                _KpiCard(
                  label: 'Efficiency',
                  value: '87%',
                  unit: 'Score',
                  icon: Icons.bolt_rounded,
                  trend: '+3.4%',
                  trendUp: true,
                  color: _purple,
                  softColor: _purpleSoft,
                  borderColor: const Color(0xFFDDD6FE),
                ),
              ]),

              const SizedBox(height: 24),

              // ── Daily bar chart ─────────────────────────────
              _SectionTitle(
                title: 'Daily Usage',
                subtitle: 'Litres consumed per day this week',
                icon: Icons.bar_chart_rounded,
                color: _blue,
              ),
              const SizedBox(height: 12),
              _UsageBarChart(accentColor: _blue, softColor: _blueSoft),

              const SizedBox(height: 24),

              // ── Water quality strip ─────────────────────────
              _SectionTitle(
                title: 'System Health',
                subtitle: 'Live borehole & supply metrics',
                icon: Icons.monitor_heart_rounded,
                color: _teal,
              ),
              const SizedBox(height: 12),
              _SystemHealthRow(),

              const SizedBox(height: 24),

              // ── Sub-meter breakdown ─────────────────────────
              _SectionTitle(
                title: 'Sub-Meter Breakdown',
                subtitle: 'Usage distribution across zones',
                icon: Icons.grid_view_rounded,
                color: _orange,
              ),
              const SizedBox(height: 12),
              _SubMeterBreakdown(),

              const SizedBox(height: 24),

              // ── Monthly trend ───────────────────────────────
              _SectionTitle(
                title: 'Monthly Consumption',
                subtitle: '6-month rolling trend',
                icon: Icons.trending_up_rounded,
                color: _purple,
              ),
              const SizedBox(height: 12),
              _ConsumptionTrend(),

              const SizedBox(height: 24),

              // ── Cost breakdown ──────────────────────────────
              _SectionTitle(
                title: 'Cost Breakdown',
                subtitle: 'Estimated water & energy costs',
                icon: Icons.receipt_long_rounded,
                color: _green,
              ),
              const SizedBox(height: 12),
              _CostBreakdown(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Page Header ──────────────────────────────────────────────

class _PageHeader extends StatelessWidget {
  final String selectedPeriod;
  final List<String> periods;
  final ValueChanged<String?> onPeriodChanged;

  const _PageHeader({
    required this.selectedPeriod,
    required this.periods,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Water Analytics',
                  style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5)),
              const SizedBox(height: 3),
              Text(
                'Comprehensive usage & system insights',
                style: TextStyle(color: const Color(0xFF64748B), fontSize: 13),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFBFD7F5)),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFF2563EB).withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2))
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedPeriod,
              dropdownColor: Colors.white,
              style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontSize: 13,
                  fontWeight: FontWeight.w700),
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF2563EB), size: 18),
              items: periods
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: onPeriodChanged,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Section Title ────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final Color color;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 15),
      ),
      const SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: const Color(0xFF0F172A),
                  fontSize: 14,
                  fontWeight: FontWeight.w800)),
          Text(subtitle,
              style: const TextStyle(
                  color: Color(0xFF94A3B8), fontSize: 11)),
        ],
      ),
    ]);
  }
}

// ─── KPI Card ─────────────────────────────────────────────────

class _KpiCard extends StatelessWidget {
  final String label, value, unit, trend;
  final IconData icon;
  final bool trendUp;
  final Color color, softColor, borderColor;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.trend,
    required this.trendUp,
    required this.color,
    required this.softColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.07),
                blurRadius: 12,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: softColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: trendUp
                    ? const Color(0xFFDCFCE7)
                    : const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(
                  trendUp
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  size: 9,
                  color: trendUp
                      ? const Color(0xFF15803D)
                      : const Color(0xFFDC2626),
                ),
                const SizedBox(width: 2),
                Text(trend,
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: trendUp
                            ? const Color(0xFF15803D)
                            : const Color(0xFFDC2626))),
              ]),
            ),
          ]),
          const SizedBox(height: 12),
          Text(value,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: color,
                  letterSpacing: -0.5)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A))),
          Text(unit,
              style: const TextStyle(
                  fontSize: 10, color: Color(0xFF94A3B8))),
        ]),
      ),
    );
  }
}

// ─── Usage Bar Chart ─────────────────────────────────────────

class _UsageBarChart extends StatelessWidget {
  final Color accentColor, softColor;
  const _UsageBarChart(
      {required this.accentColor, required this.softColor});

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final values = [
      1200.0, 1800.0, 1500.0, 2100.0, 1700.0, 900.0, 1250.0
    ];
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final avg = values.reduce((a, b) => a + b) / values.length;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8EDF5)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Legend
          Row(children: [
            _LegendDot(color: accentColor, label: 'Usage'),
            const SizedBox(width: 16),
            _LegendDot(
                color: const Color(0xFFF59E0B), label: 'Avg (${(avg / 1000).toStringAsFixed(1)}k L)'),
          ]),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Y-axis labels
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: ['2.1k', '1.6k', '1.1k', '0.5k', '0']
                      .map((l) => Text(l,
                          style: const TextStyle(
                              color: Color(0xFFCBD5E1),
                              fontSize: 9)))
                      .toList(),
                ),
                const SizedBox(width: 8),
                // Bars
                Expanded(
                  child: Stack(
                    children: [
                      // Avg line
                      Positioned(
                        bottom: (avg / maxVal) * 120,
                        left: 0,
                        right: 0,
                        child: Row(children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color: const Color(0xFFF59E0B)
                                  .withOpacity(0.5),
                            ),
                          ),
                        ]),
                      ),
                      // Bars row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                        children:
                            List.generate(days.length, (i) {
                          final ratio = values[i] / maxVal;
                          final isMax = values[i] == maxVal;
                          final isToday = i == 3;
                          return Column(
                            mainAxisAlignment:
                                MainAxisAlignment.end,
                            children: [
                              if (isMax || isToday)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  margin:
                                      const EdgeInsets.only(bottom: 4),
                                  decoration: BoxDecoration(
                                    color: isMax
                                        ? accentColor
                                        : const Color(0xFFF59E0B),
                                    borderRadius:
                                        BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${(values[i] / 1000).toStringAsFixed(1)}k',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                        fontWeight:
                                            FontWeight.w700),
                                  ),
                                )
                              else
                                const SizedBox(height: 18),
                              Container(
                                width: 28,
                                height: 120 * ratio,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: isMax
                                        ? [accentColor,
                                            accentColor
                                                .withOpacity(0.7)]
                                        : [
                                            accentColor
                                                .withOpacity(0.25),
                                            accentColor
                                                .withOpacity(0.12)
                                          ],
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(6),
                                  border: isMax
                                      ? Border.all(
                                          color: accentColor,
                                          width: 1.5)
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(days[i],
                                  style: TextStyle(
                                      color: isMax
                                          ? accentColor
                                          : const Color(0xFF94A3B8),
                                      fontSize: 10,
                                      fontWeight: isMax
                                          ? FontWeight.w700
                                          : FontWeight.normal)),
                            ],
                          );
                        }),
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
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
          width: 8,
          height: 8,
          decoration:
              BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 5),
      Text(label,
          style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 11,
              fontWeight: FontWeight.w500)),
    ]);
  }
}

// ─── System Health Row ────────────────────────────────────────

class _SystemHealthRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final metrics = [
      _HealthMetric('Water Quality', 'Good', Icons.science_outlined,
          const Color(0xFF15803D), const Color(0xFFDCFCE7), 0.92),
      _HealthMetric('Tank Level', '72%', Icons.water_outlined,
          const Color(0xFF2563EB), const Color(0xFFEFF6FF), 0.72),
      _HealthMetric('Pressure', '3.2 bar', Icons.speed_rounded,
          const Color(0xFF7C3AED), const Color(0xFFF5F3FF), 0.64),
      _HealthMetric('Pump Health', 'Good', Icons.settings_outlined,
          const Color(0xFF0D9488), const Color(0xFFECFDF5), 0.88),
    ];

    return Row(
      children: metrics
          .map((m) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: m == metrics.last ? 0 : 10),
                  child: _HealthCard(metric: m),
                ),
              ))
          .toList(),
    );
  }
}

class _HealthMetric {
  final String label, value;
  final IconData icon;
  final Color color, bg;
  final double progress;
  const _HealthMetric(
      this.label, this.value, this.icon, this.color, this.bg, this.progress);
}

class _HealthCard extends StatelessWidget {
  final _HealthMetric metric;
  const _HealthCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: metric.color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
              color: metric.color.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: metric.bg,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(metric.icon, color: metric.color, size: 13),
          ),
          const SizedBox(height: 8),
          Text(metric.value,
              style: TextStyle(
                  color: metric.color,
                  fontSize: 14,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(metric.label,
              style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 9,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: metric.progress,
              backgroundColor: metric.color.withOpacity(0.10),
              valueColor:
                  AlwaysStoppedAnimation<Color>(metric.color),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sub-Meter Breakdown ──────────────────────────────────────

class _SubMeterBreakdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final meters = [
      _MeterData('Block A – Residential', 3200, 0.72,
          const Color(0xFF2563EB), const Color(0xFFEFF6FF), Icons.home_rounded),
      _MeterData('Block B – Residential', 2850, 0.64,
          const Color(0xFF7C3AED), const Color(0xFFF5F3FF), Icons.apartment_rounded),
      _MeterData('Commercial Units', 1900, 0.43,
          const Color(0xFFFF6B00), const Color(0xFFFFF3E8), Icons.store_rounded),
      _MeterData('Garden & Common', 800, 0.18,
          const Color(0xFF15803D), const Color(0xFFDCFCE7), Icons.park_rounded),
    ];
    final total = meters.fold(0.0, (s, m) => s + m.usage);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8EDF5)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        children: [
          // Total row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total: all zones',
                  style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
              Text('${total.toStringAsFixed(0)} L',
                  style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 13,
                      fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 14),
          // Stacked progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 10,
              child: Row(
                children: meters.map((m) {
                  return Expanded(
                    flex: (m.usage).toInt(),
                    child: Container(color: m.color),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Individual meters
          ...meters.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: m.bg,
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(m.icon, color: m.color, size: 13),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(m.name,
                                  style: const TextStyle(
                                      color: Color(0xFF1E293B),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                              Row(children: [
                                Text(
                                  '${(m.usage / total * 100).toStringAsFixed(0)}%',
                                  style: TextStyle(
                                      color: m.color,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${m.usage.toStringAsFixed(0)} L',
                                  style: const TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 10),
                                ),
                              ]),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: m.percent,
                              backgroundColor:
                                  m.color.withOpacity(0.10),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(
                                      m.color),
                              minHeight: 5,
                            ),
                          ),
                        ]),
                  ),
                ]),
              )),
        ],
      ),
    );
  }
}

class _MeterData {
  final String name;
  final double usage, percent;
  final Color color, bg;
  final IconData icon;
  const _MeterData(
      this.name, this.usage, this.percent, this.color, this.bg, this.icon);
}

// ─── Consumption Trend ────────────────────────────────────────

class _ConsumptionTrend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final months = ['Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Jan'];
    final values = [
      9800.0, 10200.0, 11500.0, 10800.0, 12100.0, 12450.0
    ];
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final minV = values.reduce((a, b) => a < b ? a : b);
    final diff = values.last - values.first;
    final pct = (diff / values.first * 100).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8EDF5)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mini summary chips
          Row(children: [
            _TrendChip(
              label: 'Growth',
              value: '+$pct%',
              color: const Color(0xFFDC2626),
              bg: const Color(0xFFFEE2E2),
            ),
            const SizedBox(width: 8),
            _TrendChip(
              label: 'Peak month',
              value: 'Jan',
              color: const Color(0xFF7C3AED),
              bg: const Color(0xFFF5F3FF),
            ),
            const SizedBox(width: 8),
            _TrendChip(
              label: 'Lowest',
              value: 'Aug',
              color: const Color(0xFF15803D),
              bg: const Color(0xFFDCFCE7),
            ),
          ]),
          const SizedBox(height: 16),
          ...List.generate(months.length, (i) {
            final isLast = i == months.length - 1;
            final isMax = values[i] == maxV;
            final isMin = values[i] == minV;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(children: [
                SizedBox(
                  width: 32,
                  child: Text(months[i],
                      style: TextStyle(
                          color: isLast
                              ? const Color(0xFF7C3AED)
                              : const Color(0xFF64748B),
                          fontSize: 12,
                          fontWeight: isLast
                              ? FontWeight.w700
                              : FontWeight.normal)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: LinearProgressIndicator(
                      value: values[i] / 14000,
                      backgroundColor:
                          const Color(0xFFF1F5F9),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isMax
                            ? const Color(0xFF7C3AED)
                            : isMin
                                ? const Color(0xFF15803D)
                                : isLast
                                    ? const Color(0xFF7C3AED)
                                        .withOpacity(0.6)
                                    : const Color(0xFF7C3AED)
                                        .withOpacity(0.3),
                      ),
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 56,
                  child: Text(
                    '${(values[i] / 1000).toStringAsFixed(1)}k L',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: isLast
                            ? const Color(0xFF7C3AED)
                            : const Color(0xFF475569),
                        fontSize: 11,
                        fontWeight: isLast
                            ? FontWeight.w700
                            : FontWeight.normal),
                  ),
                ),
                const SizedBox(width: 6),
                if (isMax)
                  _PillBadge('↑ Peak',
                      const Color(0xFF7C3AED),
                      const Color(0xFFF5F3FF))
                else if (isMin)
                  _PillBadge('↓ Low',
                      const Color(0xFF15803D),
                      const Color(0xFFDCFCE7))
                else
                  const SizedBox(width: 40),
              ]),
            );
          }),
        ],
      ),
    );
  }
}

class _TrendChip extends StatelessWidget {
  final String label, value;
  final Color color, bg;
  const _TrendChip(
      {required this.label,
      required this.value,
      required this.color,
      required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(8)),
      child: Column(children: [
        Text(value,
            style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w800)),
        Text(label,
            style: const TextStyle(
                color: Color(0xFF94A3B8), fontSize: 9)),
      ]),
    );
  }
}

class _PillBadge extends StatelessWidget {
  final String text;
  final Color color, bg;
  const _PillBadge(this.text, this.color, this.bg);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: color,
              fontSize: 8,
              fontWeight: FontWeight.w700)),
    );
  }
}

// ─── Cost Breakdown ───────────────────────────────────────────

class _CostBreakdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      _CostItem('Water Supply', 'KES 4,280', 0.62,
          const Color(0xFF2563EB), const Color(0xFFEFF6FF)),
      _CostItem('Pump Energy', 'KES 2,142', 0.31,
          const Color(0xFFFF6B00), const Color(0xFFFFF3E8)),
      _CostItem('Maintenance', 'KES 480', 0.07,
          const Color(0xFF15803D), const Color(0xFFDCFCE7)),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8EDF5)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        children: [
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Monthly Cost',
                      style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                  Text('KES 6,902',
                      style: TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: const Color(0xFF86EFAC)),
                ),
                child: const Column(
                  children: [
                    Text('vs last month',
                        style: TextStyle(
                            color: Color(0xFF15803D),
                            fontSize: 9,
                            fontWeight: FontWeight.w600)),
                    Text('-KES 340',
                        style: TextStyle(
                            color: Color(0xFF15803D),
                            fontSize: 13,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: const Color(0xFFE8EDF5), height: 1),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Row(children: [
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: item.color,
                        shape: BoxShape.circle),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.label,
                                style: const TextStyle(
                                    color: Color(0xFF1E293B),
                                    fontSize: 12,
                                    fontWeight:
                                        FontWeight.w600)),
                            Text(item.amount,
                                style: TextStyle(
                                    color: item.color,
                                    fontSize: 12,
                                    fontWeight:
                                        FontWeight.w800)),
                          ],
                        ),
                        const SizedBox(height: 5),
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: item.percent,
                            backgroundColor:
                                item.color.withOpacity(0.10),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(
                                    item.color),
                            minHeight: 5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              )),
          // Savings tip
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: const Color(0xFFFDE68A)),
            ),
            child: Row(children: [
              const Icon(Icons.lightbulb_rounded,
                  color: Color(0xFFF59E0B), size: 16),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Tip: Reducing peak-hour pump usage by 20% could save ~KES 420/month.',
                  style: TextStyle(
                      color: Color(0xFF92400E),
                      fontSize: 11,
                      height: 1.4),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _CostItem {
  final String label, amount;
  final double percent;
  final Color color, bg;
  const _CostItem(
      this.label, this.amount, this.percent, this.color, this.bg);
}