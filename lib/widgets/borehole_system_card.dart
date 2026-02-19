// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class BoreholeSystemCard extends StatelessWidget {
  const BoreholeSystemCard({super.key});

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF1C2333),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showScheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const _ScheduleDialog(),
    );
  }

  void _showStopConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Row(
          children: [
            Icon(Icons.stop_circle_outlined, color: Color(0xFFFF6B6B), size: 20),
            SizedBox(width: 8),
            Text('Stop Pump',
                style: TextStyle(color: Color(0xFFE6EDF3), fontSize: 16)),
          ],
        ),
        content: const Text(
          'Are you sure you want to stop the pump? This will halt water supply to all units.',
          style: TextStyle(color: Color(0xFF8B949E), fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF8B949E))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnack(context, 'Pump stopped successfully.');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Stop Pump'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        // ignore: duplicate_ignore
                        // ignore: deprecated_member_use
                        color: const Color(0xFF2DD4BF).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.water_drop_rounded,
                          color: Color(0xFF2DD4BF), size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Borehole System',
                            style: TextStyle(
                              color: Color(0xFFE6EDF3),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            )),
                        Text('Ngara Estate · Private Water Supply',
                            style: TextStyle(
                                color: Color(0xFF8B949E), fontSize: 11)),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3FB950).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: const Color(0xFF3FB950).withOpacity(0.4)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.circle,
                          color: Color(0xFF3FB950), size: 7),
                      SizedBox(width: 5),
                      Text('Pump Running',
                          style: TextStyle(
                            color: Color(0xFF3FB950),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          )),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(color: Color(0xFF30363D), height: 1),
            const SizedBox(height: 16),

            // ── Stats grid ──
            Row(
              children: [
                _StatCard(
                  icon: Icons.vertical_align_bottom_rounded,
                  label: 'Borehole Level',
                  value: '18.5m',
                  sub: 'below ground',
                  progress: 0.70,
                  progressColor: const Color(0xFF3FB950),
                ),
                const SizedBox(width: 10),
                _StatCard(
                  icon: Icons.water_rounded,
                  label: 'Storage Tank',
                  value: '7,200 L',
                  sub: 'of 10,000 L',
                  progress: 0.72,
                  progressColor: const Color(0xFF2DD4BF),
                ),
                const SizedBox(width: 10),
                _StatCard(
                  icon: Icons.bolt_rounded,
                  label: 'Current Power',
                  value: '2.2 kW',
                  sub: 'Active consumption',
                  pillColor: const Color(0xFF3FB950),
                ),
                const SizedBox(width: 10),
                _StatCard(
                  icon: Icons.timer_outlined,
                  label: 'Runtime Today',
                  value: '4.2 hrs',
                  sub: '26 hrs this month',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── System Info + Controls ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // System Info
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D1117),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF30363D)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('System Information',
                            style: TextStyle(
                              color: Color(0xFFE6EDF3),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            )),
                        SizedBox(height: 10),
                        _InfoRow(
                            label: 'Water Quality',
                            value: 'Good',
                            valueColor: Color(0xFF3FB950)),
                        _InfoRow(
                            label: 'Monthly Energy Cost',
                            value: 'KES 2,142'),
                        _InfoRow(
                            label: 'Last Maintenance',
                            value: '04 Jan 2026'),
                        _InfoRow(
                            label: 'Pump Type',
                            value: 'Submersible 2.2kW'),
                        _InfoRow(
                            label: 'Connection',
                            value: '4G · Encrypted'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Controls
                Expanded(
                  child: Column(
                    children: [
                      // Stop Pump
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _showStopConfirm(context),
                          icon: const Icon(Icons.stop_circle_outlined,
                              size: 16),
                          label: const Text('Stop Pump'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B6B)
                                .withOpacity(0.15),
                            foregroundColor: const Color(0xFFFF6B6B),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(
                                color: const Color(0xFFFF6B6B)
                                    .withOpacity(0.4)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Schedule Auto-Run
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _showScheduleDialog(context),
                          icon: const Icon(Icons.schedule_rounded, size: 16),
                          label: const Text('Schedule Auto-Run'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2DD4BF),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(
                                color: const Color(0xFF2DD4BF)
                                    .withOpacity(0.4)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D1117),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: const Color(0xFF30363D)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline_rounded,
                                size: 12, color: Color(0xFF484F58)),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Auto-run: OFF · 4G: beam (SIM-SAM)',
                                style: TextStyle(
                                    color: Color(0xFF484F58),
                                    fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/* ── Stat Card ── */

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String sub;
  final double? progress;
  final Color? progressColor;
  final Color? pillColor;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.sub,
    this.progress,
    this.progressColor,
    this.pillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1117),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF30363D)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF2DD4BF), size: 16),
            const SizedBox(height: 6),
            Text(label,
                style: const TextStyle(
                    color: Color(0xFF8B949E), fontSize: 10)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                  color: Color(0xFFE6EDF3),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                )),
            const SizedBox(height: 2),
            if (progress != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: const Color(0xFF30363D),
                  valueColor: AlwaysStoppedAnimation<Color>(
                      progressColor ?? const Color(0xFF2DD4BF)),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 4),
            ],
            if (pillColor != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: pillColor!.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Active',
                    style: TextStyle(color: pillColor, fontSize: 9)),
              ),
            Text(sub,
                style: const TextStyle(
                    color: Color(0xFF484F58), fontSize: 9)),
          ],
        ),
      ),
    );
  }
}

/* ── Info Row ── */

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
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Color(0xFF8B949E), fontSize: 11)),
          Text(value,
              style: TextStyle(
                color: valueColor ?? const Color(0xFFE6EDF3),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              )),
        ],
      ),
    );
  }
}

/* ══════════════════════════════════════════════════════════════
   Schedule Dialog
══════════════════════════════════════════════════════════════ */

class _ScheduleDialog extends StatefulWidget {
  const _ScheduleDialog();

  @override
  State<_ScheduleDialog> createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<_ScheduleDialog> {
  DateTime _startDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 6, minute: 0);
  TimeOfDay _stopTime = const TimeOfDay(hour: 8, minute: 0);
  bool _repeat = false;
  String _repeatFreq = 'Daily';

  final List<String> _freqOptions = ['Daily', 'Weekdays', 'Weekends', 'Weekly'];

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} / ${d.month.toString().padLeft(2, '0')} / ${d.year}';

  String _fmtTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF2DD4BF),
            surface: Color(0xFF161B22),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF2DD4BF),
            surface: Color(0xFF161B22),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _startTime = picked);
  }

  Future<void> _pickStopTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _stopTime,
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF2DD4BF),
            surface: Color(0xFF161B22),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _stopTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF161B22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2DD4BF).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.schedule_rounded,
                      color: Color(0xFF2DD4BF), size: 18),
                ),
                const SizedBox(width: 10),
                const Text('Schedule Auto-Run',
                    style: TextStyle(
                      color: Color(0xFFE6EDF3),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    )),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded,
                      color: Color(0xFF8B949E), size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(color: Color(0xFF30363D), height: 1),
            const SizedBox(height: 20),

            // Start Date
            const _FieldLabel('Start Date'),
            const SizedBox(height: 6),
            _PickerTile(
              icon: Icons.calendar_today_rounded,
              value: _fmtDate(_startDate),
              onTap: _pickDate,
            ),

            const SizedBox(height: 14),

            // Start & Stop Time
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FieldLabel('Start Time'),
                      const SizedBox(height: 6),
                      _PickerTile(
                        icon: Icons.play_arrow_rounded,
                        iconColor: const Color(0xFF3FB950),
                        value: _fmtTime(_startTime),
                        onTap: _pickStartTime,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FieldLabel('Stop Time'),
                      const SizedBox(height: 6),
                      _PickerTile(
                        icon: Icons.stop_rounded,
                        iconColor: const Color(0xFFFF6B6B),
                        value: _fmtTime(_stopTime),
                        onTap: _pickStopTime,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Repeat toggle
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF30363D)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.repeat_rounded,
                      color: Color(0xFF8B949E), size: 16),
                  const SizedBox(width: 8),
                  const Text('Repeat',
                      style: TextStyle(
                          color: Color(0xFFE6EDF3), fontSize: 13)),
                  const Spacer(),
                  Switch(
                    value: _repeat,
                    onChanged: (v) => setState(() => _repeat = v),
                    activeColor: const Color(0xFF2DD4BF),
                    activeTrackColor:
                        const Color(0xFF2DD4BF).withOpacity(0.3),
                    inactiveThumbColor: const Color(0xFF484F58),
                    inactiveTrackColor: const Color(0xFF30363D),
                  ),
                ],
              ),
            ),

            // Repeat frequency (only when repeat is on)
            if (_repeat) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1117),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF30363D)),
                ),
                child: Row(
                  children: [
                    const Text('Frequency',
                        style: TextStyle(
                            color: Color(0xFF8B949E), fontSize: 13)),
                    const Spacer(),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _repeatFreq,
                        dropdownColor: const Color(0xFF1C2333),
                        style: const TextStyle(
                            color: Color(0xFF2DD4BF), fontSize: 13),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF2DD4BF), size: 18),
                        items: _freqOptions
                            .map((f) => DropdownMenuItem(
                                value: f, child: Text(f)))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _repeatFreq = v!),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Summary chip
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2DD4BF).withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: const Color(0xFF2DD4BF).withOpacity(0.25)),
              ),
              child: Text(
                _repeat
                    ? '$_repeatFreq · ${_fmtTime(_startTime)} → ${_fmtTime(_stopTime)} starting ${_fmtDate(_startDate)}'
                    : 'Once on ${_fmtDate(_startDate)} · ${_fmtTime(_startTime)} → ${_fmtTime(_stopTime)}',
                style: const TextStyle(
                    color: Color(0xFF2DD4BF), fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF8B949E),
                      side: const BorderSide(color: Color(0xFF30363D)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Auto-run schedule saved.'),
                          backgroundColor: Color(0xFF1C2333),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2DD4BF),
                      foregroundColor: const Color(0xFF0D1117),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Save Schedule',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/* ── Dialog helpers ── */

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            color: Color(0xFF8B949E),
            fontSize: 11,
            fontWeight: FontWeight.w500));
  }
}

class _PickerTile extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String value;
  final VoidCallback onTap;

  const _PickerTile({
    required this.icon,
    required this.value,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1117),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF30363D)),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 15,
                color: iconColor ?? const Color(0xFF2DD4BF)),
            const SizedBox(width: 8),
            Text(value,
                style: const TextStyle(
                    color: Color(0xFFE6EDF3), fontSize: 13)),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded,
                color: Color(0xFF484F58), size: 16),
          ],
        ),
      ),
    );
  }
}