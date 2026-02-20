// lib/widgets/borehole_system_card.dart
// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Colours — bright theme ───────────────────────────────────
class _C {
  static const bg        = Color(0xFFEFF6FF);
  static const surface   = Color(0xFFFFFFFF);
  static const surfaceAlt= Color(0xFFDBEAFE);
  static const border    = Color(0xFF93C5FD);
  static const accent    = Color(0xFF1D4ED8);
  static const accentBg  = Color(0xFFEFF6FF);
  static const accentBr  = Color(0xFFBFDBFE);
  static const green     = Color(0xFF15803D);
  static const greenBg   = Color(0xFFDCFCE7);
  static const greenBdr  = Color(0xFF86EFAC);
  static const red       = Color(0xFFDC2626);
  static const redBg     = Color(0xFFFEE2E2);
  static const redBdr    = Color(0xFFFCA5A5);
  static const textPri   = Color(0xFF0F172A);
  static const textSub   = Color(0xFF334155);
  static const textMuted = Color(0xFF64748B);
}

class BoreholeSystemCard extends StatefulWidget {
  const BoreholeSystemCard({super.key});

  @override
  State<BoreholeSystemCard> createState() => _BoreholeSystemCardState();
}

class _BoreholeSystemCardState extends State<BoreholeSystemCard> {
  bool   _pumpRunning = true;
  String _location    = '';

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _location = prefs.getString('estate_location') ?? '';
    });
  }

  void _snack(String msg, {bool success = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500)),
        backgroundColor: success ? _C.green : _C.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showScheduleDialog() {
    showDialog(
      context: context,
      builder: (_) => const _ScheduleDialog(),
    );
  }

  void _showStopConfirm() {
    showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _C.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Stop Pump',
            style: TextStyle(
                color: _C.textPri,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
        content: const Text(
          'Are you sure you want to stop the pump? This will halt water supply to all units.',
          style: TextStyle(color: _C.textSub, fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel',
                style: TextStyle(color: _C.textSub)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: _C.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Stop Pump'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed != true) return;
      setState(() => _pumpRunning = false);
      _snack('Pump stopped successfully.');
    });
  }

  void _startPump() {
    setState(() => _pumpRunning = true);
    _snack('Pump started successfully.');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D4ED8).withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header ──────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Borehole System',
                          style: TextStyle(
                              color: _C.textPri,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3)),
                      const SizedBox(height: 2),
                      Text(
                        _location.isNotEmpty
                            ? '$_location · Private Water Supply'
                            : 'Private Water Supply',
                        style: const TextStyle(
                            color: _C.textSub, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                // Status badge — shows current pump state
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _pumpRunning ? _C.greenBg : _C.redBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: _pumpRunning ? _C.greenBdr : _C.redBdr),
                  ),
                  child: Text(
                    _pumpRunning ? 'Pump Running' : 'Pump Stopped',
                    style: TextStyle(
                        color: _pumpRunning ? _C.green : _C.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Divider(color: _C.border, height: 1),
            const SizedBox(height: 16),

            // ── Body — changes based on pump state ───────────
            if (_pumpRunning) ...[

              // Stats grid
              Row(
                children: [
                  _StatCard(
                    label: 'Borehole Level',
                    value: '18.5m',
                    sub: 'below ground',
                    progress: 0.70,
                    progressColor: _C.green,
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    label: 'Storage Tank',
                    value: '7,200 L',
                    sub: 'of 10,000 L',
                    progress: 0.72,
                    progressColor: _C.accent,
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    label: 'Current Power',
                    value: '2.2 kW',
                    sub: 'Active consumption',
                    activePill: true,
                  ),
                  const SizedBox(width: 10),
                  _StatCard(
                    label: 'Runtime Today',
                    value: '4.2 hrs',
                    sub: '26 hrs this month',
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // System info + controls
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // System info panel
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _C.accentBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _C.accentBr),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('System Information',
                              style: TextStyle(
                                  color: _C.textPri,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
                          SizedBox(height: 10),
                          _InfoRow(
                              label: 'Water Quality',
                              value: 'Good',
                              valueColor: _C.green),
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
                          child: ElevatedButton(
                            onPressed: _showStopConfirm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _C.redBg,
                              foregroundColor: _C.red,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13),
                              side: const BorderSide(color: _C.redBdr),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Stop Pump',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13)),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Schedule
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _showScheduleDialog,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _C.accent,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13),
                              side: const BorderSide(color: _C.accentBr),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Schedule Auto-Run',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13)),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: _C.bg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _C.border),
                          ),
                          child: const Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Auto-run: OFF · 4G: beam (SIM-SAM)',
                                  style: TextStyle(
                                      color: _C.textMuted, fontSize: 10),
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

            ] else ...[

              // ── Pump stopped state ───────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: _C.redBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _C.redBdr),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pump is currently offline',
                        style: TextStyle(
                            color: _C.red,
                            fontSize: 15,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text(
                      'All stats are hidden while the pump is stopped.\nStart the pump to resume monitoring.',
                      style: TextStyle(
                          color: _C.red.withOpacity(0.75),
                          fontSize: 12,
                          height: 1.5),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Start pump button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _startPump,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.greenBg,
                    foregroundColor: _C.green,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: _C.greenBdr),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Start Pump',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Stat Card ────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String  label;
  final String  value;
  final String  sub;
  final double? progress;
  final Color?  progressColor;
  final bool    activePill;

  const _StatCard({
    required this.label,
    required this.value,
    required this.sub,
    this.progress,
    this.progressColor,
    this.activePill = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _C.accentBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _C.accentBr),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    color: _C.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 5),
            Text(value,
                style: const TextStyle(
                    color: _C.textPri,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3)),
            const SizedBox(height: 4),
            if (progress != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: _C.border,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      progressColor ?? _C.accent),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 4),
            ],
            if (activePill) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _C.greenBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _C.greenBdr),
                ),
                child: const Text('Active',
                    style: TextStyle(
                        color: _C.green,
                        fontSize: 9,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 2),
            ],
            Text(sub,
                style: const TextStyle(
                    color: _C.textMuted, fontSize: 9)),
          ],
        ),
      ),
    );
  }
}

// ─── Info Row ─────────────────────────────────────────────────

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
                  color: _C.textSub, fontSize: 11)),
          Text(value,
              style: TextStyle(
                  color: valueColor ?? _C.textPri,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─── Schedule Dialog ─────────────────────────────────────────

class _ScheduleDialog extends StatefulWidget {
  const _ScheduleDialog();

  @override
  State<_ScheduleDialog> createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<_ScheduleDialog> {
  DateTime  _startDate  = DateTime.now();
  TimeOfDay _startTime  = const TimeOfDay(hour: 6, minute: 0);
  TimeOfDay _stopTime   = const TimeOfDay(hour: 8, minute: 0);
  bool      _repeat     = false;
  String    _repeatFreq = 'Daily';

  final List<String> _freqOptions = [
    'Daily', 'Weekdays', 'Weekends', 'Weekly'
  ];

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} / '
      '${d.month.toString().padLeft(2, '0')} / ${d.year}';

  String _fmtTime(TimeOfDay t) {
    final h      = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m      = t.minute.toString().padLeft(2, '0');
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
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
              primary: Color(0xFF1D4ED8)),
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
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
              primary: Color(0xFF1D4ED8)),
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
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
              primary: Color(0xFF1D4ED8)),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _stopTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _C.surface,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: [
                const Expanded(
                  child: Text('Schedule Auto-Run',
                      style: TextStyle(
                          color: _C.textPri,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: _C.textSub,
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Close'),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Divider(color: _C.border, height: 1),
            const SizedBox(height: 16),

            // Start Date
            _FieldLabel('Start Date'),
            const SizedBox(height: 6),
            _PickerTile(
              value: _fmtDate(_startDate),
              onTap: _pickDate,
            ),

            const SizedBox(height: 14),

            // Times
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel('Start Time'),
                      const SizedBox(height: 6),
                      _PickerTile(
                        value: _fmtTime(_startTime),
                        onTap: _pickStartTime,
                        valueColor: _C.green,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel('Stop Time'),
                      const SizedBox(height: 6),
                      _PickerTile(
                        value: _fmtTime(_stopTime),
                        onTap: _pickStopTime,
                        valueColor: _C.red,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Repeat toggle
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: _C.accentBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _C.accentBr),
              ),
              child: Row(
                children: [
                  const Text('Repeat',
                      style: TextStyle(
                          color: _C.textPri,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Switch(
                    value: _repeat,
                    onChanged: (v) => setState(() => _repeat = v),
                    activeColor: _C.accent,
                  ),
                ],
              ),
            ),

            if (_repeat) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: _C.accentBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _C.accentBr),
                ),
                child: Row(
                  children: [
                    const Text('Frequency',
                        style: TextStyle(
                            color: _C.textSub, fontSize: 13)),
                    const Spacer(),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _repeatFreq,
                        dropdownColor: _C.surface,
                        style: const TextStyle(
                            color: _C.accent, fontSize: 13),
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

            const SizedBox(height: 16),

            // Summary
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _C.surfaceAlt,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _C.accentBr),
              ),
              child: Text(
                _repeat
                    ? '$_repeatFreq · ${_fmtTime(_startTime)} → '
                        '${_fmtTime(_stopTime)} starting ${_fmtDate(_startDate)}'
                    : 'Once on ${_fmtDate(_startDate)} · '
                        '${_fmtTime(_startTime)} → ${_fmtTime(_stopTime)}',
                style: const TextStyle(
                    color: _C.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _C.textSub,
                      side: const BorderSide(color: _C.border),
                      padding:
                          const EdgeInsets.symmetric(vertical: 12),
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
                        SnackBar(
                          content: const Text('Auto-run schedule saved.',
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: _C.accent,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _C.accent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding:
                          const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Save Schedule',
                        style:
                            TextStyle(fontWeight: FontWeight.w700)),
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

// ─── Dialog helpers ───────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            color: _C.textSub,
            fontSize: 11,
            fontWeight: FontWeight.w600));
  }
}

class _PickerTile extends StatelessWidget {
  final String       value;
  final VoidCallback onTap;
  final Color?       valueColor;

  const _PickerTile({
    required this.value,
    required this.onTap,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: _C.accentBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _C.accentBr),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(value,
                  style: TextStyle(
                      color: valueColor ?? _C.accent,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ),
            const Text('tap to change',
                style: TextStyle(color: _C.textMuted, fontSize: 9)),
          ],
        ),
      ),
    );
  }
}