// lib/widgets/borehole_system_card.dart
// ignore_for_file: deprecated_member_use, unnecessary_underscores
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────────────────────
// SHARED PUMP STATE — import this in both cards and in the
// parent screen so they all read/write the same notifier.
//
// Usage in parent (e.g. home_screen.dart):
//   final pumpState = PumpStateNotifier();
//   ...
//   BoreholeSystemCard(pumpState: pumpState),
//   WaterMeterCard(pumpState: pumpState),
// ─────────────────────────────────────────────────────────────
class PumpStateNotifier extends ValueNotifier<bool> {
  /// [value] = true means pump is running / water is flowing.
  PumpStateNotifier({bool initiallyRunning = true})
      : super(initiallyRunning);

  bool get isRunning => value;
  void start() => value = true;
  void stop()  => value = false;
}

// ─── Colours ─────────────────────────────────────────────────
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
  final PumpStateNotifier pumpState;
  const BoreholeSystemCard({super.key, required this.pumpState});

  @override
  State<BoreholeSystemCard> createState() => _BoreholeSystemCardState();
}

class _BoreholeSystemCardState extends State<BoreholeSystemCard>
    with SingleTickerProviderStateMixin {
  String _location = '';

  late final AnimationController _pulseCtrl;
  late final Animation<double>   _pulseAnim;

  bool get _pumpRunning => widget.pumpState.isRunning;

  @override
  void initState() {
    super.initState();
    _loadLocation();
    widget.pumpState.addListener(_onPumpChanged);

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    widget.pumpState.removeListener(_onPumpChanged);
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _onPumpChanged() => setState(() {});

  Future<void> _loadLocation() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _location = prefs.getString('estate_location') ?? '');
  }

  void _snack(String msg, {bool success = true}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      backgroundColor: success ? _C.green : _C.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  Future<void> _showStopConfirm() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _C.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Stop Pump',
            style: TextStyle(color: _C.textPri, fontSize: 16, fontWeight: FontWeight.w700)),
        content: const Text(
          'Are you sure you want to stop the pump?\nThis will halt water supply to all units.',
          style: TextStyle(color: _C.textSub, fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel',
                style: TextStyle(color: _C.textSub, fontWeight: FontWeight.w600)),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: _C.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Stop Pump', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      widget.pumpState.stop();   // ← notifies WaterMeterCard too
      _snack('Pump stopped. Status updated across all meters.');
    }
  }

  void _startPump() {
    widget.pumpState.start();   // ← notifies WaterMeterCard too
    _snack('Pump started. All meters updated to Flowing.');
  }

  void _showScheduleDialog() {
    showDialog(context: context, builder: (_) => const _ScheduleDialog());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: _pumpRunning ? _C.border : _C.redBdr, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: (_pumpRunning ? const Color(0xFF1D4ED8) : _C.red)
                .withOpacity(0.08),
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
                        style: const TextStyle(color: _C.textSub, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                // Pulsing status badge
                AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (_, __) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _pumpRunning ? _C.greenBg : _C.redBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: _pumpRunning ? _C.greenBdr : _C.redBdr),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Opacity(
                          opacity: _pumpRunning ? _pulseAnim.value : 1.0,
                          child: Container(
                            width: 7, height: 7,
                            decoration: BoxDecoration(
                              color: _pumpRunning ? _C.green : _C.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _pumpRunning ? 'Pump Running' : 'Pump Stopped',
                          style: TextStyle(
                              color: _pumpRunning ? _C.green : _C.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Persistent status bar
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: _pumpRunning ? _C.greenBg : _C.redBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: _pumpRunning ? _C.greenBdr : _C.redBdr),
              ),
              child: Row(
                children: [
                  Icon(
                    _pumpRunning
                        ? Icons.water_drop_rounded
                        : Icons.power_off_rounded,
                    color: _pumpRunning ? _C.green : _C.red,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _pumpRunning
                          ? 'Pump is active — water flowing normally to all units'
                          : 'Pump is stopped — no water flow. Tap "Start Pump" to resume.',
                      style: TextStyle(
                          color: _pumpRunning ? _C.green : _C.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.3),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: (_pumpRunning ? _C.green : _C.red)
                          .withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _pumpRunning ? 'LIVE' : 'OFFLINE',
                      style: TextStyle(
                          color: _pumpRunning ? _C.green : _C.red,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
            Divider(color: _pumpRunning ? _C.border : _C.redBdr, height: 1),
            const SizedBox(height: 14),

            // Body
            if (_pumpRunning) ...[
              Row(
                children: [
                  _StatCard(label: 'Borehole Level', value: '18.5m',   sub: 'below ground',       progress: 0.70, progressColor: _C.green),
                  const SizedBox(width: 10),
                  _StatCard(label: 'Storage Tank',   value: '7,200 L', sub: 'of 10,000 L',         progress: 0.72, progressColor: _C.accent),
                  const SizedBox(width: 10),
                  _StatCard(label: 'Current Power',  value: '2.2 kW',  sub: 'Active consumption',  activePill: true),
                  const SizedBox(width: 10),
                  _StatCard(label: 'Runtime Today',  value: '4.2 hrs', sub: '26 hrs this month'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          _InfoRow(label: 'Water Quality',       value: 'Good',               valueColor: _C.green),
                          _InfoRow(label: 'Monthly Energy Cost', value: 'KES 2,142'),
                          _InfoRow(label: 'Last Maintenance',    value: '04 Jan 2026'),
                          _InfoRow(label: 'Pump Type',           value: 'Submersible 2.2kW'),
                          _InfoRow(label: 'Connection',          value: '4G · Encrypted'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _showStopConfirm,
                            icon: const Icon(Icons.power_off_rounded, size: 16),
                            label: const Text('Stop Pump',
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _C.redBg,
                              foregroundColor: _C.red,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              side: const BorderSide(color: _C.redBdr),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _showScheduleDialog,
                            icon: const Icon(Icons.schedule_rounded, size: 16),
                            label: const Text('Schedule Auto-Run',
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _C.accent,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              side: const BorderSide(color: _C.accentBr),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
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
                          child: const Row(children: [
                            Expanded(
                              child: Text('Auto-run: OFF · 4G: beam (SIM-SAM)',
                                  style: TextStyle(color: _C.textMuted, fontSize: 10)),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(child: _StoppedStatTile(label: 'Last Stopped',    value: _currentTime(), icon: Icons.access_time_rounded)),
                  const SizedBox(width: 10),
                  Expanded(child: _StoppedStatTile(label: 'Borehole Level',  value: '18.5m',        icon: Icons.water_outlined)),
                  const SizedBox(width: 10),
                  Expanded(child: _StoppedStatTile(label: 'Tank Level',      value: '7,200 L',      icon: Icons.storage_rounded)),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _startPump,
                  icon: const Icon(Icons.power_rounded, size: 18),
                  label: const Text('Start Pump',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _showScheduleDialog,
                icon: const Icon(Icons.schedule_rounded, size: 15),
                label: const Text('Schedule Auto-Start',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _C.accent,
                  minimumSize: const Size(double.infinity, 40),
                  side: const BorderSide(color: _C.accentBr),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _currentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} today';
  }
}

// ─── Stopped stat tile ────────────────────────────────────────
class _StoppedStatTile extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _StoppedStatTile({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _C.redBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.redBdr),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _C.red, size: 14),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(color: _C.red, fontSize: 13, fontWeight: FontWeight.w800)),
          Text(label, style: TextStyle(color: _C.red.withOpacity(0.65), fontSize: 9)),
        ],
      ),
    );
  }
}

// ─── Stat Card ────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String  label, value, sub;
  final double? progress;
  final Color?  progressColor;
  final bool    activePill;

  const _StatCard({
    required this.label, required this.value, required this.sub,
    this.progress, this.progressColor, this.activePill = false,
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
            Text(label, style: const TextStyle(color: _C.textMuted, fontSize: 10, fontWeight: FontWeight.w600)),
            const SizedBox(height: 5),
            Text(value, style: const TextStyle(color: _C.textPri, fontSize: 15, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            if (progress != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: _C.border,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor ?? _C.accent),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 4),
            ],
            if (activePill) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _C.greenBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _C.greenBdr),
                ),
                child: const Text('Active', style: TextStyle(color: _C.green, fontSize: 9, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 2),
            ],
            Text(sub, style: const TextStyle(color: _C.textMuted, fontSize: 9)),
          ],
        ),
      ),
    );
  }
}

// ─── Info Row ─────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final String label, value;
  final Color? valueColor;
  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: _C.textSub, fontSize: 11)),
          Text(value, style: TextStyle(color: valueColor ?? _C.textPri, fontSize: 11, fontWeight: FontWeight.w600)),
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
  final List<String> _freqOptions = ['Daily', 'Weekdays', 'Weekends', 'Weekly'];

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} / ${d.month.toString().padLeft(2, '0')} / ${d.year}';

  String _fmtTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m ${t.period == DayPeriod.am ? 'AM' : 'PM'}';
  }

  Future<void> _pickDate() async {
    final p = await showDatePicker(
      context: context, initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: ThemeData.light().copyWith(colorScheme: const ColorScheme.light(primary: Color(0xFF1D4ED8))),
        child: child!,
      ),
    );
    if (p != null) setState(() => _startDate = p);
  }

  Future<void> _pickStart() async {
    final p = await showTimePicker(context: context, initialTime: _startTime,
      builder: (ctx, child) => Theme(data: ThemeData.light().copyWith(colorScheme: const ColorScheme.light(primary: Color(0xFF1D4ED8))), child: child!));
    if (p != null) setState(() => _startTime = p);
  }

  Future<void> _pickStop() async {
    final p = await showTimePicker(context: context, initialTime: _stopTime,
      builder: (ctx, child) => Theme(data: ThemeData.light().copyWith(colorScheme: const ColorScheme.light(primary: Color(0xFF1D4ED8))), child: child!));
    if (p != null) setState(() => _stopTime = p);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _C.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Expanded(child: Text('Schedule Auto-Run',
                  style: TextStyle(color: _C.textPri, fontSize: 16, fontWeight: FontWeight.w700))),
              TextButton(onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(foregroundColor: _C.textSub, minimumSize: Size.zero, padding: EdgeInsets.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: const Text('Close')),
            ]),
            const SizedBox(height: 16),
            Divider(color: _C.border, height: 1),
            const SizedBox(height: 16),
            const Text('Start Date', style: TextStyle(color: _C.textSub, fontSize: 11, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            _PickerTile(value: _fmtDate(_startDate), onTap: _pickDate),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Start Time', style: TextStyle(color: _C.textSub, fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                _PickerTile(value: _fmtTime(_startTime), onTap: _pickStart, valueColor: _C.green),
              ])),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Stop Time', style: TextStyle(color: _C.textSub, fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                _PickerTile(value: _fmtTime(_stopTime), onTap: _pickStop, valueColor: _C.red),
              ])),
            ]),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(color: _C.accentBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: _C.accentBr)),
              child: Row(children: [
                const Text('Repeat', style: TextStyle(color: _C.textPri, fontSize: 13, fontWeight: FontWeight.w600)),
                const Spacer(),
                Switch(value: _repeat, onChanged: (v) => setState(() => _repeat = v), activeColor: _C.accent),
              ]),
            ),
            if (_repeat) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(color: _C.accentBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: _C.accentBr)),
                child: Row(children: [
                  const Text('Frequency', style: TextStyle(color: _C.textSub, fontSize: 13)),
                  const Spacer(),
                  DropdownButtonHideUnderline(child: DropdownButton<String>(
                    value: _repeatFreq, dropdownColor: _C.surface,
                    style: const TextStyle(color: _C.accent, fontSize: 13),
                    items: _freqOptions.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                    onChanged: (v) => setState(() => _repeatFreq = v!),
                  )),
                ]),
              ),
            ],
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: _C.surfaceAlt, borderRadius: BorderRadius.circular(10), border: Border.all(color: _C.accentBr)),
              child: Text(
                _repeat
                    ? '$_repeatFreq · ${_fmtTime(_startTime)} → ${_fmtTime(_stopTime)} starting ${_fmtDate(_startDate)}'
                    : 'Once on ${_fmtDate(_startDate)} · ${_fmtTime(_startTime)} → ${_fmtTime(_stopTime)}',
                style: const TextStyle(color: _C.accent, fontSize: 12, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(foregroundColor: _C.textSub, side: const BorderSide(color: _C.border),
                    padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: const Text('Cancel'),
              )),
              const SizedBox(width: 10),
              Expanded(child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Auto-run schedule saved.', style: TextStyle(color: Colors.white)),
                    backgroundColor: _C.accent, behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ));
                },
                style: ElevatedButton.styleFrom(backgroundColor: _C.accent, foregroundColor: Colors.white, elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                child: const Text('Save Schedule', style: TextStyle(fontWeight: FontWeight.w700)),
              )),
            ]),
          ],
        ),
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  final String value;
  final VoidCallback onTap;
  final Color? valueColor;
  const _PickerTile({required this.value, required this.onTap, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(color: _C.accentBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: _C.accentBr)),
        child: Row(children: [
          Expanded(child: Text(value, style: TextStyle(color: valueColor ?? _C.accent, fontSize: 13, fontWeight: FontWeight.w600))),
          const Text('tap to change', style: TextStyle(color: _C.textMuted, fontSize: 9)),
        ]),
      ),
    );
  }
}