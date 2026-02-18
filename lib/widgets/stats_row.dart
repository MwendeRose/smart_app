import 'package:flutter/material.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          icon: Icons.water_drop_outlined,
          iconColor: const Color(0xFF1565C0),
          label: "Today's Usage",
          value: '1847.3 L',
          subLabel: 'from borehole',
        ),
        const SizedBox(width: 8),
        _StatCard(
          icon: Icons.calendar_month_outlined,
          iconColor: const Color(0xFF7B1FA2),
          label: 'This Month',
          value: '52000 L',
          subLabel: 'Total pumped',
        ),
        const SizedBox(width: 8),
        _StatCard(
          icon: Icons.bolt,
          iconColor: const Color(0xFFF57C00),
          label: 'Pump Energy',
          value: '284',
          subLabel: 'kWh this month',
        ),
        const SizedBox(width: 8),
        _StatCard(
          icon: Icons.receipt_outlined,
          iconColor: const Color(0xFF2E7D32),
          label: 'Total Cost',
          value: 'KES 2142',
          subLabel: 'Power + maintenance',
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String subLabel;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.subLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                Icon(icon, color: iconColor, size: 14),
              ],
            ),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
            const SizedBox(height: 2),
            Text(subLabel, style: const TextStyle(color: Colors.grey, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}