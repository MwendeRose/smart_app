// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class SubMetersGrid extends StatelessWidget {
  const SubMetersGrid({super.key});

  static const List<Map<String, dynamic>> _units = [
    {
      'name': 'Unit A1',
      'person': 'Mary Wanjiru',
      'icon': Icons.home_rounded,
      'iconBg': Color(0xFF1C2333),
      'flow': 2.3,
      'today': 286,
      'month': 8500,
      'monthCost': 'KES 450.50',
      'hasAlert': false,
    },
    {
      'name': 'Unit A2',
      'person': 'Peter Omondi',
      'icon': Icons.home_rounded,
      'iconBg': Color(0xFF1C2333),
      'flow': 0.0,
      'today': 413,
      'month': 12000,
      'monthCost': 'KES 636.00',
      'hasAlert': true,
      'alertText': 'Possible leak detected',
    },
    {
      'name': 'Unit B1',
      'person': 'Grace Muthoni',
      'icon': Icons.home_rounded,
      'iconBg': Color(0xFF1C2333),
      'flow': 1.8,
      'today': 298,
      'month': 9200,
      'monthCost': 'KES 487.60',
      'hasAlert': false,
    },
    {
      'name': 'Unit B2',
      'person': 'James Kipchoge',
      'icon': Icons.home_rounded,
      'iconBg': Color(0xFF1C2333),
      'flow': 3.2,
      'today': 267,
      'month': 7800,
      'monthCost': 'KES 413.40',
      'hasAlert': false,
    },
    {
      'name': 'Shop 1',
      'person': 'Mama Mboga Store',
      'icon': Icons.storefront_rounded,
      'iconBg': Color(0xFF1C2333),
      'flow': 4.5,
      'today': 359,
      'month': 10500,
      'monthCost': 'KES 556.50',
      'hasAlert': false,
    },
    {
      'name': 'Shop 2',
      'person': 'Barber Shop',
      'icon': Icons.storefront_rounded,
      'iconBg': Color(0xFF1C2333),
      'flow': 0.7,
      'today': 125,
      'month': 3900,
      'monthCost': 'KES 206.70',
      'hasAlert': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Sub-Meters Overview',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFFE6EDF3),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'View Analytics →',
                style: TextStyle(
                  color: Color(0xFF2DD4BF),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.55,
          ),
          itemCount: _units.length,
          itemBuilder: (context, i) => _UnitCard(unit: _units[i]),
        ),
      ],
    );
  }
}

/* ── Unit Card ── */

class _UnitCard extends StatelessWidget {
  final Map<String, dynamic> unit;
  const _UnitCard({required this.unit});

  @override
  Widget build(BuildContext context) {
    final bool hasAlert = unit['hasAlert'] as bool;
    final double flow = unit['flow'] as double;
    final bool flowing = flow > 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hasAlert
              ? const Color(0xFFF57C00).withOpacity(0.5)
              : const Color(0xFF30363D),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: icon + name + alert icon ──
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF2DD4BF).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  unit['icon'] as IconData,
                  color: const Color(0xFF2DD4BF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      unit['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Color(0xFFE6EDF3),
                      ),
                    ),
                    Text(
                      unit['person'],
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF8B949E)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (hasAlert)
                const Icon(Icons.warning_amber_rounded,
                    color: Color(0xFFF57C00), size: 18),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(color: Color(0xFF30363D), height: 1),
          const SizedBox(height: 10),

          // ── Stats rows ──
          _StatRow(
            label: 'Current Flow',
            value: '${flow.toStringAsFixed(1)} L/min',
            valueColor: flowing
                ? const Color(0xFF2DD4BF)
                : const Color(0xFF8B949E),
            icon: Icons.water_drop_rounded,
          ),
          const SizedBox(height: 6),
          _StatRow(
            label: 'Today',
            value: '${unit['today']} L',
          ),
          const SizedBox(height: 6),
          _StatRow(
            label: 'This Month',
            value: '${unit['month']} L',
            sub: unit['monthCost'],
          ),

          // ── Alert badge ──
          if (hasAlert) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFF57C00).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: const Color(0xFFF57C00).withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Color(0xFFF57C00), size: 12),
                  const SizedBox(width: 5),
                  Text(
                    unit['alertText'] ?? '',
                    style: const TextStyle(
                      color: Color(0xFFF57C00),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const Spacer(),

          // ── View Details ──
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => _UnitDetailPage(unit: unit),
              ),
            ),
            child: const Text(
              'View Details →',
              style: TextStyle(
                color: Color(0xFF2DD4BF),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ── Stat Row ── */

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final IconData? icon;
  final String? sub;

  const _StatRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.icon,
    this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: Color(0xFF8B949E))),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon,
                      size: 11,
                      color: valueColor ?? const Color(0xFFE6EDF3)),
                  const SizedBox(width: 3),
                ],
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: valueColor ?? const Color(0xFFE6EDF3),
                  ),
                ),
              ],
            ),
            if (sub != null)
              Text(sub!,
                  style: const TextStyle(
                      fontSize: 10, color: Color(0xFF484F58))),
          ],
        ),
      ],
    );
  }
}

/* ══════════════════════════════════════════════════════════════
   Unit Detail Page
══════════════════════════════════════════════════════════════ */

class _UnitDetailPage extends StatelessWidget {
  final Map<String, dynamic> unit;
  const _UnitDetailPage({required this.unit});

  @override
  Widget build(BuildContext context) {
    final bool hasAlert = unit['hasAlert'] as bool;
    final double flow = unit['flow'] as double;
    final bool flowing = flow > 0;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        foregroundColor: const Color(0xFFE6EDF3),
        elevation: 0,
        title: Text(
          unit['name'],
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFF30363D)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile Card ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF161B22),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF30363D)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2DD4BF).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(unit['icon'] as IconData,
                        color: const Color(0xFF2DD4BF), size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(unit['name'],
                            style: const TextStyle(
                              color: Color(0xFFE6EDF3),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            )),
                        const SizedBox(height: 2),
                        Text(unit['person'],
                            style: const TextStyle(
                                color: Color(0xFF8B949E),
                                fontSize: 13)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: flowing
                          ? const Color(0xFF2DD4BF).withOpacity(0.12)
                          : const Color(0xFF30363D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: flowing
                                ? const Color(0xFF2DD4BF)
                                : const Color(0xFF8B949E),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          flowing ? 'Active' : 'Inactive',
                          style: TextStyle(
                            color: flowing
                                ? const Color(0xFF2DD4BF)
                                : const Color(0xFF8B949E),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (hasAlert) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1208),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFFF57C00).withOpacity(0.45)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Color(0xFFF57C00), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Alert',
                              style: TextStyle(
                                color: Color(0xFFF57C00),
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              )),
                          const SizedBox(height: 2),
                          Text(unit['alertText'] ?? '',
                              style: const TextStyle(
                                  color: Color(0xFF8B949E),
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),
            const _SectionLabel('Live Readings'),
            const SizedBox(height: 10),

            // ── Live stats grid ──
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.2,
              children: [
                _DetailStatCard(
                  label: 'Current Flow',
                  value: '${flow.toStringAsFixed(1)} L/min',
                  icon: Icons.water_drop_rounded,
                  color: flowing
                      ? const Color(0xFF2DD4BF)
                      : const Color(0xFF8B949E),
                ),
                _DetailStatCard(
                  label: 'Usage Today',
                  value: '${unit['today']} L',
                  icon: Icons.today_rounded,
                  color: const Color(0xFF2DD4BF),
                ),
                _DetailStatCard(
                  label: 'This Month',
                  value: '${unit['month']} L',
                  icon: Icons.calendar_month_rounded,
                  color: const Color(0xFF2DD4BF),
                ),
                _DetailStatCard(
                  label: 'Monthly Cost',
                  value: unit['monthCost'],
                  icon: Icons.payments_rounded,
                  color: const Color(0xFF2DD4BF),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const _SectionLabel('Consumption History'),
            const SizedBox(height: 10),
            const _MiniBarChart(),

            const SizedBox(height: 24),
            const _SectionLabel('Billing Summary'),
            const SizedBox(height: 10),
            _BillingSummary(unit: unit),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

/* ── Section Label ── */

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
          color: Color(0xFFE6EDF3),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ));
  }
}

/* ── Detail Stat Card ── */

class _DetailStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _DetailStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value,
                    style: TextStyle(
                      color: color,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    )),
                Text(label,
                    style: const TextStyle(
                        color: Color(0xFF8B949E), fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ── Mini Bar Chart ── */

class _MiniBarChart extends StatelessWidget {
  const _MiniBarChart();

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final values = [220.0, 310.0, 280.0, 350.0, 290.0, 180.0, 240.0];
    final maxVal = values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(days.length, (i) {
            final ratio = values[i] / maxVal;
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${values[i].toInt()}',
                    style: const TextStyle(
                        color: Color(0xFF484F58), fontSize: 8)),
                const SizedBox(height: 3),
                Container(
                  width: 24,
                  height: 70 * ratio,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        const Color(0xFF2DD4BF).withOpacity(0.9),
                        const Color(0xFF2DD4BF).withOpacity(0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 5),
                Text(days[i],
                    style: const TextStyle(
                        color: Color(0xFF8B949E), fontSize: 9)),
              ],
            );
          }),
        ),
      ),
    );
  }
}

/* ── Billing Summary ── */

class _BillingSummary extends StatelessWidget {
  final Map<String, dynamic> unit;
  const _BillingSummary({required this.unit});

  @override
  Widget build(BuildContext context) {
    final rows = [
      {'label': 'Water Consumed', 'value': '${unit['month']} L'},
      {'label': 'Rate per 1000 L', 'value': 'KES 54.00'},
      {'label': 'Service Charge', 'value': 'KES 50.00'},
      {'label': 'Total Due', 'value': unit['monthCost'], 'bold': true},
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: Column(
        children: rows.asMap().entries.map((e) {
          final isBold = e.value['bold'] == true;
          final isLast = e.key == rows.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.value['label']!,
                        style: TextStyle(
                          color: isBold
                              ? const Color(0xFFE6EDF3)
                              : const Color(0xFF8B949E),
                          fontSize: 13,
                          fontWeight: isBold
                              ? FontWeight.w600
                              : FontWeight.normal,
                        )),
                    Text(e.value['value']!,
                        style: TextStyle(
                          color: isBold
                              ? const Color(0xFF2DD4BF)
                              : const Color(0xFFE6EDF3),
                          fontSize: 13,
                          fontWeight: isBold
                              ? FontWeight.w700
                              : FontWeight.normal,
                        )),
                  ],
                ),
              ),
              if (!isLast)
                const Divider(
                    color: Color(0xFF30363D), height: 1, indent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}