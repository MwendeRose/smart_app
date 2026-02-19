import 'package:flutter/material.dart';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

const String _kBaseUrl = 'http://localhost:3000/api';

class WaterMeterCard extends StatefulWidget {
  const WaterMeterCard({super.key});

  @override
  State<WaterMeterCard> createState() => _WaterMeterCardState();
}

class _WaterMeterCardState extends State<WaterMeterCard> {
  String  _meterName  = 'Main Water Meter';
  String  _location   = 'Ngara Estate - Block 3 (Borehole Supply)';
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
    _fetchMeter();
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
          _meterName  = (data['name']       as String?) ?? _meterName;
          _location   = (data['location']   as String?) ?? _location;
          _meterId    = (data['meterId']     as String?) ?? _meterId;
          _flowRate   = (data['flowRate']    as num?)?.toDouble() ?? _flowRate;
          _todayUsage = (data['todayUsage']  as int?)   ?? _todayUsage;
          _isFlowing  = (data['isFlowing']   as bool?)  ?? _isFlowing;
          _updatedAt  = (data['updatedAt']   as String?) ?? _updatedAt;
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
    } catch (_) {
      // Keep local state if offline
    }
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
            _meterId    = updated['meterId']     as String;
            _flowRate   = updated['flowRate']    as double;
            _todayUsage = updated['todayUsage']  as int;
          });
          await _saveMeter(updated);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Meter details saved to database.'),
              backgroundColor: Color(0xFF1C2333),
              behavior: SnackBarBehavior.floating,
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
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0x1F2DD4BF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.speed_rounded,
                      color: Color(0xFF2DD4BF), size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_meterName,
                          style: const TextStyle(
                            color: Color(0xFFE6EDF3),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          )),
                      Text(_location,
                          style: const TextStyle(
                              color: Color(0xFF8B949E), fontSize: 11)),
                      Text('Meter ID: $_meterId',
                          style: const TextStyle(
                              color: Color(0xFF484F58), fontSize: 10)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0x1F3FB950),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0x593FB950)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.wifi_rounded,
                          color: Color(0xFF3FB950), size: 12),
                      SizedBox(width: 5),
                      Text('Connected',
                          style: TextStyle(
                              color: Color(0xFF3FB950), fontSize: 11)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _openEdit,
                  icon: const Icon(Icons.edit_outlined,
                      color: Color(0xFF8B949E), size: 18),
                  tooltip: 'Edit meter details',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(color: Color(0xFF30363D), height: 1),
            const SizedBox(height: 16),

            // ── Metrics ──
            if (_loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CircularProgressIndicator(
                      color: Color(0xFF2DD4BF), strokeWidth: 2),
                ),
              )
            else
              Row(
                children: [
                  _MeterMetric(
                    icon: Icons.water_drop_rounded,
                    label: 'Current Flow Rate',
                    value: _flowRate.toStringAsFixed(1),
                    unit: 'L/min',
                  ),
                  const SizedBox(width: 10),
                  _MeterMetric(
                    icon: Icons.today_rounded,
                    label: 'Total Usage Today',
                    value: _todayUsage.toString(),
                    unit: 'Litres',
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _isFlowing
                            ? const Color(0x143FB950)
                            : const Color(0x1A484F58),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _isFlowing
                              ? const Color(0x4D3FB950)
                              : const Color(0xFF30363D),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: _isFlowing
                                      ? const Color(0xFF3FB950)
                                      : const Color(0xFF484F58),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Text('Status',
                                  style: TextStyle(
                                      color: Color(0xFF8B949E),
                                      fontSize: 10)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _isFlowing ? 'Water Flowing' : 'No Flow',
                            style: TextStyle(
                              color: _isFlowing
                                  ? const Color(0xFF3FB950)
                                  : const Color(0xFF8B949E),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text('Updated: $_updatedAt',
                              style: const TextStyle(
                                  color: Color(0xFF484F58), fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 12),

            // ── Footer ──
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF30363D)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 6, color: Color(0xFF3FB950)),
                  const SizedBox(width: 3),
                  const Icon(Icons.circle, size: 6, color: Color(0xFF3FB950)),
                  const SizedBox(width: 3),
                  const Icon(Icons.circle, size: 6, color: Color(0xFFF0A500)),
                  const SizedBox(width: 8),
                  const Text('Data Transmission Active',
                      style: TextStyle(
                          fontSize: 11, color: Color(0xFF8B949E))),
                  const Spacer(),
                  if (_error != null)
                    Text(_error!,
                        style: const TextStyle(
                            fontSize: 10, color: Color(0xFFFF6B6B)))
                  else
                    const Text('4G · MongoDB Sync',
                        style: TextStyle(
                            fontSize: 10, color: Color(0xFF484F58))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ── Metric tile ── */

class _MeterMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;

  const _MeterMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
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
            Row(
              children: [
                Icon(icon, color: const Color(0xFF2DD4BF), size: 14),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(label,
                      style: const TextStyle(
                          color: Color(0xFF8B949E), fontSize: 10)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFE6EDF3),
                )),
            Text(unit,
                style: const TextStyle(
                    color: Color(0xFF8B949E), fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

/* ── Edit Dialog ── */

class _EditMeterDialog extends StatefulWidget {
  final String name;
  final String location;
  final String meterId;
  final double flowRate;
  final int todayUsage;
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
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    _meterIdCtrl.dispose();
    _flowCtrl.dispose();
    _todayCtrl.dispose();
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
      backgroundColor: const Color(0xFF161B22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
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
                    color: const Color(0x1F2DD4BF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.edit_rounded,
                      color: Color(0xFF2DD4BF), size: 16),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text('Edit Meter Details',
                      style: TextStyle(
                        color: Color(0xFFE6EDF3),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      )),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded,
                      color: Color(0xFF8B949E), size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Changes are saved to MongoDB and reflected across all users.',
              style: TextStyle(color: Color(0xFF484F58), fontSize: 11),
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFF30363D), height: 1),
            const SizedBox(height: 16),

            _Field(label: 'Meter Name', ctrl: _nameCtrl,
                hint: 'e.g. Main Water Meter'),
            const SizedBox(height: 12),
            _Field(label: 'Location', ctrl: _locationCtrl,
                hint: 'e.g. Block 3, Ngara Estate'),
            const SizedBox(height: 12),
            _Field(label: 'Meter ID', ctrl: _meterIdCtrl,
                hint: 'e.g. NWM-2024-047'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _Field(
                    label: 'Flow Rate (L/min)',
                    ctrl: _flowCtrl,
                    hint: '12.5',
                    keyboard: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _Field(
                    label: 'Today Usage (L)',
                    ctrl: _todayCtrl,
                    hint: '1847',
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
                    onPressed: _saving ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2DD4BF),
                      foregroundColor: const Color(0xFF0D1117),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF0D1117)),
                          )
                        : const Text('Save to DB',
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

/* ── Text field helper ── */

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final String hint;
  final TextInputType keyboard;

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
                color: Color(0xFF8B949E),
                fontSize: 11,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 5),
        TextField(
          controller: ctrl,
          keyboardType: keyboard,
          style: const TextStyle(color: Color(0xFFE6EDF3), fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF484F58)),
            filled: true,
            fillColor: const Color(0xFF0D1117),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF30363D)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF30363D)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF2DD4BF)),
            ),
          ),
        ),
      ],
    );
  }
}