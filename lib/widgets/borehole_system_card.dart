import 'package:flutter/material.dart';

class BoreholeSystemCard extends StatelessWidget {
  const BoreholeSystemCard({super.key});

  void _showPop(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.yellow.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.black, Color(0xFF1C1C1C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.yellow, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                    Text(
                      'Borehole System',
                      style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Ngara Estate · Private Water Supply',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.circle, color: Colors.white, size: 8),
                      SizedBox(width: 4),
                      Text(
                        'Pump Running',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Stats grid
            Row(
              children: [
                _StatCard(
                  icon: Icons.vertical_align_bottom,
                  label: 'Borehole Level',
                  value: '18.5m',
                  subLabel: 'below ground',
                  progress: 0.70,
                  progressColor: Colors.green,
                ),
                const SizedBox(width: 8),
                _StatCard(
                  icon: Icons.water,
                  label: 'Storage Tank',
                  value: '7200L',
                  subLabel: 'of 10000L',
                  progress: 0.72,
                  progressColor: Colors.yellow,
                ),
                const SizedBox(width: 8),
                _StatCard(
                  icon: Icons.bolt,
                  label: 'Current Power',
                  value: '2.2',
                  subLabel: 'kW',
                  showPill: true,
                  pillText: 'Active consumption',
                ),
                const SizedBox(width: 8),
                _StatCard(
                  icon: Icons.timer_outlined,
                  label: 'Runtime Today',
                  value: '4.2',
                  subLabel: 'hours',
                  note: '26h this month',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // System Info + Pump Controls
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                      // ignore: deprecated_member_use
                      border: Border.all(color: Colors.yellow.withOpacity(0.3)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'System Information',
                          style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        _InfoRow(label: 'Water Quality:', value: 'Good', valueColor: Colors.green),
                        _InfoRow(label: 'Monthly Energy Cost:', value: 'KES 2142'),
                        _InfoRow(label: 'Last Maintenance:', value: '04/01/2026'),
                        _InfoRow(label: 'Pump Type:', value: 'Submersible 2.2kW'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _showPop(context, 'Pump Stopped'),
                        icon: const Icon(Icons.stop_circle_outlined, size: 16),
                        label: const Text('Stop Pump'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () => _showPop(context, 'Auto-Run Scheduled'),
                        icon: const Icon(Icons.schedule, size: 16),
                        label: const Text('Schedule Auto-Run'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.yellow,
                          side: const BorderSide(color: Colors.yellow),
                          minimumSize: const Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Auto-run: OFF · 4G link: beam (SIM-SAM)',
                        style: TextStyle(color: Colors.white54, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Footer
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, size: 6, color: Colors.green),
                SizedBox(width: 4),
                Icon(Icons.circle, size: 6, color: Colors.green),
                SizedBox(width: 4),
                Icon(Icons.circle, size: 6, color: Colors.white38),
                SizedBox(width: 8),
                Text(
                  'Real-time monitoring via 4G · Encrypted connection',
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/* ───────── PRIVATE WIDGETS ───────── */

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subLabel;
  final double? progress;
  final Color? progressColor;
  final bool showPill;
  final String? pillText;
  final String? note;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subLabel,
    this.progress,
    this.progressColor,
    this.showPill = false,
    this.pillText,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
          // ignore: deprecated_member_use
          border: Border.all(color: Colors.yellow.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.yellow, size: 16),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 9)),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                  color: Colors.yellow,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Text(subLabel,
                style: const TextStyle(color: Colors.white60, fontSize: 9)),
            if (progress != null) ...[
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white24,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(progressColor ?? Colors.yellow),
                  minHeight: 4,
                ),
              ),
            ],
            if (showPill && pillText != null) ...[
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.green.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(pillText!,
                    style: const TextStyle(color: Colors.white, fontSize: 8)),
              ),
            ],
            if (note != null) ...[
              const SizedBox(height: 4),
              Text(note!,
                  style:
                      const TextStyle(color: Colors.white60, fontSize: 9)),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white60, fontSize: 10)),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.yellow,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
