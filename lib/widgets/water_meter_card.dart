// lib/widgets/water_meter_card.dart
// ignore_for_file: deprecated_member_use, unused_field
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String _kBaseUrl = 'http://localhost:3000/api';

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

class WaterMeterCard extends StatefulWidget {
  const WaterMeterCard({super.key});

  @override
  State<WaterMeterCard> createState() => _WaterMeterCardState();
}

class _WaterMeterCardState extends State<WaterMeterCard> {
  String  _meterName  = 'Main Water Meter';
  String  _location   = '';           // loaded from settings
  String  _meterId    = 'NWM-2024-047';
  double  _flowRate   = 12.5;
  int     _todayUsage = 1847;
  bool    _isFlowing  = true;
  String  _updatedAt  = '15:22:33';
  bool    _loading    = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLocation();
    _fetchMeter();
  }

  // ── Load location from SharedPreferences (set in Settings) ──
  Future<void> _loadLocation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _location = prefs.getString('estate_location') ?? '';
    });
  }

  Future<void> _fetchMeter() async {
    try {
      final res = await http
          .get(Uri.parse('$_kBaseUrl/meter'))
          .timeout(const Duration(seconds: 6));
      if (!mounted) return;
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        setState(() {
          _meterName  = (data['name']      as String?) ?? _meterName;
          _meterId    = (data['meterId']   as String?) ?? _meterId;
          _flowRate   = (data['flowRate']  as num?)?.toDouble() ?? _flowRate;
          _todayUsage = (data['todayUsage']as num?)?.toInt()   ?? _todayUsage;
          _isFlowing  = (data['isFlowing'] as bool?)  ?? _isFlowing;
          _updatedAt  = (data['updatedAt'] as String?) ?? _updatedAt;
          _loading    = false;
          _error      = null;
        });
      } else {
        setState(() {
          _loading = false;
          _error   = 'Server error ${res.statusCode}';
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() { _loading = false; });
    }
  }

  Future<void> _saveMeter(Map<String, dynamic> updates) async {
    try {
      await http.patch(
        Uri.parse('$_kBaseUrl/meter'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updates),
      ).timeout(const Duration(seconds: 6));
    } catch (_) {}
  }

  void _openEdit() {
    showDialog(
      context: context,
      builder: (_) => _EditMeterDialog(
        name:       _meterName,
        location:   _location,
        meterId:    _meterId,
        flowRate:   _flowRate,
        todayUsage: _todayUsage,
        onSave: (updated) async {
          setState(() {
            _meterName  = updated['name']       as String;
            _location   = updated['location']   as String;
            _meterId    = updated['meterId']    as String;
            _flowRate   = updated['flowRate']   as double;
            _todayUsage = updated['todayUsage'] as int;
          });
          // Persist location to prefs
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('estate_location', _location);
          await _saveMeter(updated);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Meter details saved.'),
              backgroundColor: _C.accent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          );
        },
      ),
    );
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
                      Text(_meterName,
                          style: const TextStyle(
                              color: _C.textPri,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3)),
                      if (_location.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(_location,
                            style: const TextStyle(
                                color: _C.textSub, fontSize: 12)),
                      ],
                      const SizedBox(height: 2),
                      Text('Meter ID: $_meterId',
                          style: const TextStyle(
                              color: _C.textMuted, fontSize: 11)),
                    ],
                  ),
                ),

                // Connection badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _C.greenBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _C.greenBdr),
                  ),
                  child: Text(
                    'Connected',
                    style: TextStyle(
                        color: _C.green,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  ),
                ),

                const SizedBox(width: 8),

                // Edit button — text style, no icon
                TextButton(
                  onPressed: _openEdit,
                  style: TextButton.styleFrom(
                    foregroundColor: _C.accent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Edit',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Divider(color: _C.border, height: 1),
            const SizedBox(height: 16),

            // ── Metrics ─────────────────────────────────────
            if (_loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CircularProgressIndicator(
                      color: _C.accent, strokeWidth: 2),
                ),
              )
            else if (!_isFlowing)
              // Pump stopped — show stopped state only
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: _C.redBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _C.redBdr),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pump Stopped',
                        style: TextStyle(
                            color: _C.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text('No water flow detected · Last updated: $_updatedAt',
                        style: TextStyle(
                            color: _C.red.withOpacity(0.7),
                            fontSize: 11)),
                  ],
                ),
              )
            else
              // Pump running — show all metrics
              Column(
                children: [
                  Row(
                    children: [
                      _Metric(
                        label: 'Flow Rate',
                        // ignore: unnecessary_string_interpolations
                        value: '${_flowRate.toStringAsFixed(1)}',
                        unit: 'L/min',
                        color: _C.accent,
                        bg: _C.accentBg,
                        borderColor: _C.accentBr,
                      ),
                      const SizedBox(width: 10),
                      _Metric(
                        label: 'Usage Today',
                        value: '$_todayUsage',
                        unit: 'Litres',
                        color: _C.accent,
                        bg: _C.accentBg,
                        borderColor: _C.accentBr,
                      ),
                      const SizedBox(width: 10),
                      _Metric(
                        label: 'Status',
                        value: 'Flowing',
                        unit: 'Updated: $_updatedAt',
                        color: _C.green,
                        bg: _C.greenBg,
                        borderColor: _C.greenBdr,
                      ),
                    ],
                  ),
                ],
              ),

            const SizedBox(height: 14),

            // ── Footer ──────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: _C.bg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _C.border),
              ),
              child: Row(
                children: [
                  // Live pulse dots
                  Row(
                    children: List.generate(3, (i) => Container(
                      margin: const EdgeInsets.only(right: 4),
                      width: 6, height: 6,
                      decoration: BoxDecoration(
                        color: i < 2 ? _C.green : const Color(0xFFF59E0B),
                        shape: BoxShape.circle,
                      ),
                    )),
                  ),
                  const SizedBox(width: 6),
                  const Text('Data Transmission Active',
                      style: TextStyle(
                          fontSize: 11,
                          color: _C.textSub,
                          fontWeight: FontWeight.w500)),
                  const Spacer(),
                  if (_error != null)
                    Text(_error!,
                        style: TextStyle(fontSize: 10, color: _C.red))
                  else
                    Text(
                      _isFlowing ? 'Live · Firebase Sync' : 'Pump Off',
                      style: TextStyle(
                          fontSize: 10,
                          color: _isFlowing ? _C.textMuted : _C.red,
                          fontWeight: FontWeight.w500),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Metric tile ─────────────────────────────────────────────

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color  color;
  final Color  bg;
  final Color  borderColor;

  const _Metric({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.bg,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    color: color.withOpacity(0.75),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3)),
            const SizedBox(height: 5),
            Text(value,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: color,
                    letterSpacing: -0.5)),
            Text(unit,
                style: TextStyle(
                    color: color.withOpacity(0.6),
                    fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

// ─── Edit Dialog ─────────────────────────────────────────────

class _EditMeterDialog extends StatefulWidget {
  final String name;
  final String location;
  final String meterId;
  final double flowRate;
  final int    todayUsage;
  final Future<void> Function(Map<String, dynamic>) onSave;

  const _EditMeterDialog({
    required this.name,
    required this.location,
    required this.meterId,
    required this.flowRate,
    required this.todayUsage,
    required this.onSave,
  });

  @override
  State<_EditMeterDialog> createState() => _EditMeterDialogState();
}

class _EditMeterDialogState extends State<_EditMeterDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _meterIdCtrl;
  late final TextEditingController _flowCtrl;
  late final TextEditingController _todayCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl     = TextEditingController(text: widget.name);
    _locationCtrl = TextEditingController(text: widget.location);
    _meterIdCtrl  = TextEditingController(text: widget.meterId);
    _flowCtrl     = TextEditingController(text: widget.flowRate.toString());
    _todayCtrl    = TextEditingController(text: widget.todayUsage.toString());
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _locationCtrl.dispose(); _meterIdCtrl.dispose();
    _flowCtrl.dispose(); _todayCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _saving = true);
    await widget.onSave({
      'name':       _nameCtrl.text.trim(),
      'location':   _locationCtrl.text.trim(),
      'meterId':    _meterIdCtrl.text.trim(),
      'flowRate':   double.tryParse(_flowCtrl.text) ?? widget.flowRate,
      'todayUsage': int.tryParse(_todayCtrl.text)   ?? widget.todayUsage,
    });
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _C.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              children: [
                const Expanded(
                  child: Text('Edit Meter Details',
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
            const SizedBox(height: 4),
            const Text(
              'Location entered here will also appear in the top bar.',
              style: TextStyle(color: _C.textMuted, fontSize: 11),
            ),
            const SizedBox(height: 16),
            Divider(color: _C.border, height: 1),
            const SizedBox(height: 16),

            _Field(label: 'Meter Name',
                ctrl: _nameCtrl, hint: 'e.g. Main Water Meter'),
            const SizedBox(height: 12),
            _Field(label: 'Location (Estate / Site)',
                ctrl: _locationCtrl, hint: 'e.g. Ngara Estate, Block 3'),
            const SizedBox(height: 12),
            _Field(label: 'Meter ID',
                ctrl: _meterIdCtrl, hint: 'e.g. NWM-2024-047'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _Field(
                    label: 'Flow Rate (L/min)',
                    ctrl: _flowCtrl, hint: '12.5',
                    keyboard: const TextInputType.numberWithOptions(
                        decimal: true),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _Field(
                    label: 'Today Usage (L)',
                    ctrl: _todayCtrl, hint: '1847',
                    keyboard: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _C.textSub,
                      side: BorderSide(color: _C.border),
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
                    onPressed: _saving ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _C.accent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 16, height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Text('Save',
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

// ─── Field helper ─────────────────────────────────────────────

class _Field extends StatelessWidget {
  final String                label;
  final TextEditingController ctrl;
  final String                hint;
  final TextInputType         keyboard;

  const _Field({
    required this.label,
    required this.ctrl,
    required this.hint,
    this.keyboard = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: _C.textSub,
                fontSize: 11,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 5),
        TextField(
          controller: ctrl,
          keyboardType: keyboard,
          style: const TextStyle(color: _C.textPri, fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: _C.textMuted),
            filled: true,
            fillColor: _C.bg,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: _C.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: _C.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _C.accent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}