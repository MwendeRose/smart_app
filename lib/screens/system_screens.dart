// lib/screens/system_screens.dart
// ignore_for_file: deprecated_member_use, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ═══════════════════════════════════════════════════════════════
// SHARED FIRESTORE REFERENCE  (same collection as sub_meters_grid)
// ═══════════════════════════════════════════════════════════════
final _subCol = FirebaseFirestore.instance.collection('submeters');

// ═══════════════════════════════════════════════════════════════
// BOREHOLE CONFIGURATION SCREEN
// ═══════════════════════════════════════════════════════════════

class BoreholeConfigScreen extends StatefulWidget {
  const BoreholeConfigScreen({super.key});

  @override
  State<BoreholeConfigScreen> createState() => _BoreholeConfigScreenState();
}

class _BoreholeConfigScreenState extends State<BoreholeConfigScreen> {
  final _nameCtrl        = TextEditingController(text: 'BH-001 Main Borehole');
  final _locationCtrl    = TextEditingController(text: '-1.2921, 36.8219');
  final _depthCtrl       = TextEditingController(text: '120');
  final _diameterCtrl    = TextEditingController(text: '150');
  final _pumpModelCtrl   = TextEditingController(text: 'Grundfos SP 5A-18');
  final _pumpDepthCtrl   = TextEditingController(text: '90');
  final _capacityCtrl    = TextEditingController(text: '5000');

  String    _powerSource  = 'Solar';
  String    _pumpStatus   = 'Active';
  TimeOfDay _startTime    = const TimeOfDay(hour: 6,  minute: 0);
  TimeOfDay _stopTime     = const TimeOfDay(hour: 18, minute: 0);
  bool      _autoSchedule = true;
  bool      _dryRunProt   = true;
  bool      _saving       = false;

  static const _green = Color(0xFF4CAF50);

  @override
  void dispose() {
    for (final c in [_nameCtrl, _locationCtrl, _depthCtrl, _diameterCtrl,
      _pumpModelCtrl, _pumpDepthCtrl, _capacityCtrl]) c.dispose();
    super.dispose();
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _stopTime,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(primary: _green)),
        child: child!,
      ),
    );
    if (picked != null) setState(() => isStart ? _startTime = picked : _stopTime = picked);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 900));
    setState(() => _saving = false);
    if (mounted) {
      _snack('✅ Borehole configuration saved!', _green);
      Navigator.pop(context);
    }
  }

  void _snack(String msg, Color color) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [
          Container(width: 4, height: 32,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 10),
          Expanded(child: Text(msg, style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 13))),
        ]),
        backgroundColor: Colors.white, behavior: SnackBarBehavior.floating, elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color.withOpacity(0.3))),
        duration: const Duration(seconds: 2),
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: _buildAppBar('Borehole Configuration', Icons.settings_input_component_outlined, _green),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          _StatusBanner(status: _pumpStatus, label: 'Pump Status', activeColor: _green),
          const SizedBox(height: 20),

          _SectionLabel(title: 'Borehole Information', icon: Icons.location_on_outlined, color: _green),
          const SizedBox(height: 10),
          _Card(children: [
            _Field(controller: _nameCtrl,     label: 'Borehole Name / ID',  icon: Icons.tag_outlined),
            const _FDivider(),
            _Field(controller: _locationCtrl, label: 'GPS Coordinates',      icon: Icons.my_location_outlined),
            const _FDivider(),
            _Field(controller: _depthCtrl,    label: 'Borehole Depth (m)',   icon: Icons.height_outlined,             keyboard: TextInputType.number),
            const _FDivider(),
            _Field(controller: _diameterCtrl, label: 'Casing Diameter (mm)', icon: Icons.radio_button_unchecked,      keyboard: TextInputType.number),
          ]),
          const SizedBox(height: 20),

          _SectionLabel(title: 'Pump Details', icon: Icons.water_outlined, color: _green),
          const SizedBox(height: 10),
          _Card(children: [
            _Field(controller: _pumpModelCtrl, label: 'Pump Model / Brand',          icon: Icons.precision_manufacturing_outlined),
            const _FDivider(),
            _Field(controller: _pumpDepthCtrl, label: 'Pump Installation Depth (m)', icon: Icons.vertical_align_bottom_outlined, keyboard: TextInputType.number),
            const _FDivider(),
            _Field(controller: _capacityCtrl,  label: 'Pump Capacity (L/hr)',        icon: Icons.speed_outlined,                keyboard: TextInputType.number),
            const _FDivider(),
            _DropdownRow(label: 'Power Source', icon: Icons.bolt_outlined,
                value: _powerSource, options: const ['Solar','Grid','Generator','Hybrid'],
                color: _green, onChanged: (v) => setState(() => _powerSource = v!)),
            const _FDivider(),
            _DropdownRow(label: 'Pump Status', icon: Icons.toggle_on_outlined,
                value: _pumpStatus, options: const ['Active','Inactive','Maintenance'],
                color: _green, onChanged: (v) => setState(() => _pumpStatus = v!)),
          ]),
          const SizedBox(height: 20),

          _SectionLabel(title: 'Operational Schedule', icon: Icons.schedule_outlined, color: _green),
          const SizedBox(height: 10),
          _Card(children: [
            _ToggleRow(label: 'Auto Schedule', subtitle: 'Run pump on a timed schedule',
                value: _autoSchedule, color: _green,
                onChanged: (v) => setState(() => _autoSchedule = v)),
            const _FDivider(),
            _TimeRow(label: 'Start Time', time: _startTime, enabled: _autoSchedule,
                color: _green, onTap: () => _pickTime(true)),
            const _FDivider(),
            _TimeRow(label: 'Stop Time',  time: _stopTime,  enabled: _autoSchedule,
                color: _green, onTap: () => _pickTime(false)),
            const _FDivider(),
            _ToggleRow(label: 'Dry-Run Protection',
                subtitle: 'Auto-stop pump when water level is low',
                value: _dryRunProt, color: _green,
                onChanged: (v) => setState(() => _dryRunProt = v)),
          ]),
          const SizedBox(height: 28),

          _SaveButton(label: 'Save Configuration', color: _green, loading: _saving, onTap: _save),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SUB-METER MANAGEMENT SCREEN  — live Firestore, soft delete
// ═══════════════════════════════════════════════════════════════

class SubMeterManagementScreen extends StatefulWidget {
  const SubMeterManagementScreen({super.key});

  @override
  State<SubMeterManagementScreen> createState() => _SubMeterManagementScreenState();
}

class _SubMeterManagementScreenState extends State<SubMeterManagementScreen> {
  static const _green = Color(0xFF4CAF50);
  bool _saving = false;

  // ── Firestore — only meters where deletedAt == null ────────
  // No orderBy here: combining where(isNull) + orderBy requires a
  // composite Firestore index. We sort in Dart instead to avoid that.
  Stream<QuerySnapshot> get _liveMeters => _subCol
      .where('deletedAt', isNull: true)
      .snapshots();

  // ── Create ─────────────────────────────────────────────────
  Future<void> _create(Map<String, dynamic> payload) async {
    setState(() => _saving = true);
    try {
      await _subCol.add({
        ...payload,
        'createdAt': FieldValue.serverTimestamp(),
        'deletedAt': null,            // explicit null so the isNull filter works
      });
      _snack('✅ "${payload['name']}" added!', _green);
    } catch (_) {
      _snack('❌ Failed to save. Check connection.', const Color(0xFFFF3B3B));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ── Update ─────────────────────────────────────────────────
  Future<void> _update(String id, Map<String, dynamic> payload) async {
    try {
      await _subCol.doc(id).update(payload);
      _snack('✅ "${payload['name']}" updated!', _green);
    } catch (_) {
      _snack('❌ Update failed.', const Color(0xFFFF3B3B));
    }
  }

  // ── Soft Delete — stamps deletedAt, record stays in DB ────
  Future<void> _softDelete(String id, String name) async {
    try {
      await _subCol.doc(id).update({'deletedAt': FieldValue.serverTimestamp()});
      _snack('🗑️ "$name" removed from view. Record kept in database.', const Color(0xFFFF6B00));
    } catch (_) {
      _snack('❌ Remove failed.', const Color(0xFFFF3B3B));
    }
  }

  // ── Add / Edit bottom sheet ────────────────────────────────
  void _showForm({DocumentSnapshot? doc}) {
    final isEdit    = doc != null;
    final d         = (doc?.data() as Map<String, dynamic>?) ?? {};
    final nameCtrl  = TextEditingController(text: d['name']     ?? '');
    final locCtrl   = TextEditingController(text: d['location'] ?? '');
    final idCtrl    = TextEditingController(text: d['meterId']  ?? '');
    final flowCtrl  = TextEditingController(text: (d['flowRate'] as num?)?.toString() ?? '');
    final usageCtrl = TextEditingController(text: (d['usage']   as num?)?.toString() ?? '');
    bool  active    = d['isActive'] ?? true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(
              left: 20, right: 20, top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch, children: [

            // Header
            Row(children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(color: _green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(isEdit ? Icons.edit_outlined : Icons.add_outlined,
                    color: _green, size: 16),
              ),
              const SizedBox(width: 10),
              Text(isEdit ? 'Edit Sub-Meter' : 'Add Sub-Meter',
                  style: const TextStyle(color: Color(0xFF1A1A2E),
                      fontSize: 16, fontWeight: FontWeight.w800)),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(ctx),
                icon: const Icon(Icons.close_rounded, color: Color(0xFF9090A0), size: 20),
                padding: EdgeInsets.zero, constraints: const BoxConstraints(),
              ),
            ]),
            const SizedBox(height: 4),
            const Text('Changes sync instantly across all devices.',
                style: TextStyle(color: Color(0xFF9090A0), fontSize: 11)),
            const SizedBox(height: 16),

            _Field(controller: nameCtrl,  label: 'Meter Name *',     icon: Icons.label_outline),
            const SizedBox(height: 10),
            _Field(controller: locCtrl,   label: 'Location / Zone',   icon: Icons.map_outlined),
            const SizedBox(height: 10),
            _Field(controller: idCtrl,    label: 'Meter ID',           icon: Icons.tag_outlined),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _Field(controller: flowCtrl,  label: 'Flow Rate (L/min)',
                  icon: Icons.waves_outlined,     keyboard: TextInputType.number)),
              const SizedBox(width: 10),
              Expanded(child: _Field(controller: usageCtrl, label: 'Usage (L)',
                  icon: Icons.water_drop_outlined, keyboard: TextInputType.number)),
            ]),
            const SizedBox(height: 12),

            // Active toggle
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FC), borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFEEEEF5)),
              ),
              child: Row(children: [
                const Icon(Icons.toggle_on_rounded, color: Color(0xFF9090A0), size: 18),
                const SizedBox(width: 10),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Meter Active', style: TextStyle(color: Color(0xFF1A1A2E),
                      fontSize: 13, fontWeight: FontWeight.w600)),
                  Text('Toggle off if meter is offline', style: TextStyle(
                      color: Color(0xFF9090A0), fontSize: 10)),
                ])),
                Switch(
                  value: active,
                  onChanged: (v) => setSheet(() => active = v),
                  activeColor: Colors.white, activeTrackColor: _green,
                  inactiveThumbColor: const Color(0xFFBBBBCC),
                  inactiveTrackColor: const Color(0xFFEEEEF5),
                ),
              ]),
            ),
            const SizedBox(height: 20),

            _SaveButton(
              label: isEdit ? 'Save Changes' : 'Add Meter',
              color: _green,
              loading: _saving,
              onTap: () {
                final name = nameCtrl.text.trim();
                if (name.isEmpty) {
                  _snack('❌ Meter name is required.', const Color(0xFFFF3B3B));
                  return;
                }
                final payload = {
                  'name':     name,
                  'location': locCtrl.text.trim(),
                  'meterId':  idCtrl.text.trim(),
                  'flowRate': double.tryParse(flowCtrl.text)  ?? 0.0,
                  'usage':    int.tryParse(usageCtrl.text)    ?? 0,
                  'isActive': active,
                };
                Navigator.pop(ctx);
                isEdit ? _update(doc.id, payload) : _create(payload);
              },
            ),
          ]),
        ),
      ),
    );
  }

  // ── Confirm remove dialog ──────────────────────────────────
  void _confirmDelete(DocumentSnapshot doc) {
    final name = ((doc.data() as Map<String, dynamic>)['name'] ?? 'meter') as String;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove Sub-Meter',
            style: TextStyle(color: Color(0xFF1A1A2E),
                fontWeight: FontWeight.w800, fontSize: 16)),
        content: Column(mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Remove "$name" from this screen?',
              style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 13, height: 1.5)),
          const SizedBox(height: 10),
          // Info pill explaining soft delete
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1), borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFE082)),
            ),
            child: const Row(children: [
              Icon(Icons.info_outline, color: Color(0xFFFF8F00), size: 14),
              SizedBox(width: 6),
              Expanded(child: Text(
                'The record stays in the database for audit purposes.',
                style: TextStyle(color: Color(0xFF6D4C41), fontSize: 11, height: 1.4),
              )),
            ]),
          ),
        ]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: const Color(0xFF9090A0)),
            child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          FilledButton(
            onPressed: () { Navigator.pop(context); _softDelete(doc.id, name); },
            style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFF3B3B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('Remove', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _snack(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        Container(width: 4, height: 32,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 10),
        Expanded(child: Text(msg, style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 13))),
      ]),
      backgroundColor: Colors.white, behavior: SnackBarBehavior.floating, elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color.withOpacity(0.3))),
      duration: const Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: _buildAppBar('Sub-Meter Management', Icons.grid_view_outlined, _green),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saving ? null : () => _showForm(),
        backgroundColor: _green,
        icon: _saving
            ? const SizedBox(width: 16, height: 16,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Icon(Icons.add, color: Colors.white),
        label: Text(_saving ? 'Saving...' : 'Add Meter',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        elevation: 4,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _liveMeters,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(color: _green, strokeWidth: 2),
            ));
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}',
                style: const TextStyle(color: Color(0xFFFF3B3B))));
          }

          // Sort in Dart — avoids needing a composite Firestore index
          final docs = (snap.data?.docs ?? [])
            ..sort((a, b) {
              final aTs = (a.data() as Map)['createdAt'] as Timestamp?;
              final bTs = (b.data() as Map)['createdAt'] as Timestamp?;
              if (aTs == null && bTs == null) return 0;
              if (aTs == null) return -1;
              if (bTs == null) return 1;
              return aTs.compareTo(bTs);
            });
          final activeCount = docs.where((d) =>
              ((d.data() as Map)['isActive'] ?? true) == true).length;
          final totalUsage  = docs.fold<int>(0, (s, d) =>
              s + ((d.data() as Map)['usage'] as int? ?? 0));

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 100),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              // Summary chips
              Row(children: [
                Expanded(child: _StatChip(label: 'Total',  value: '${docs.length}',
                    icon: Icons.grid_view_outlined, color: _green)),
                const SizedBox(width: 12),
                Expanded(child: _StatChip(label: 'Active', value: '$activeCount',
                    icon: Icons.check_circle_outline, color: _green)),
                const SizedBox(width: 12),
                Expanded(child: _StatChip(label: 'Usage (L)', value: '$totalUsage',
                    icon: Icons.water_drop_outlined, color: _green)),
              ]),
              const SizedBox(height: 20),

              _SectionLabel(title: 'Registered Sub-Meters',
                  icon: Icons.list_alt_outlined, color: _green),
              const SizedBox(height: 10),

              if (docs.isEmpty)
                _EmptyMeters(onAdd: () => _showForm())
              else
                ...docs.map((doc) {
                  final d      = doc.data() as Map<String, dynamic>;
                  final active = d['isActive'] as bool?  ?? true;
                  final usage  = d['usage']    as int?   ?? 0;
                  final flow   = (d['flowRate'] as num?)?.toDouble() ?? 0.0;
                  return _SystemSubMeterCard(
                    name:        d['name']     ?? 'Sub Meter',
                    zone:        d['location'] ?? '',
                    meterId:     d['meterId']  ?? '',
                    usage:       usage,
                    flow:        flow,
                    active:      active,
                    accentColor: _green,
                    onEdit:      () => _showForm(doc: doc),
                    onDelete:    () => _confirmDelete(doc),
                    onToggle:    (v) => _update(doc.id, {
                      'name':     d['name'],
                      'location': d['location'],
                      'meterId':  d['meterId'],
                      'flowRate': d['flowRate'],
                      'usage':    d['usage'],
                      'isActive': v,
                    }),
                  );
                }),
            ]),
          );
        },
      ),
    );
  }
}

// ── Sub-meter card ─────────────────────────────────────────────
class _SystemSubMeterCard extends StatelessWidget {
  final String name, zone, meterId;
  final int    usage;
  final double flow;
  final bool   active;
  final Color  accentColor;
  final VoidCallback       onEdit, onDelete;
  final ValueChanged<bool> onToggle;

  const _SystemSubMeterCard({
    required this.name, required this.zone, required this.meterId,
    required this.usage, required this.flow, required this.active,
    required this.accentColor, required this.onEdit,
    required this.onDelete,    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: active ? const Color(0xFFEEEEF5) : const Color(0xFFFFCACA)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
            blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: accentColor.withOpacity(active ? 0.10 : 0.05),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.speed_outlined,
                  color: active ? accentColor : const Color(0xFF9090A0), size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(color: Color(0xFF1A1A2E),
                  fontSize: 14, fontWeight: FontWeight.w700)),
              Text(
                '${meterId.isNotEmpty ? meterId : "No ID"} · ${zone.isNotEmpty ? zone : "No zone"}',
                style: const TextStyle(color: Color(0xFF9090A0), fontSize: 11),
              ),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: active ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: active ? const Color(0xFFBBF7D0) : const Color(0xFFFECACA)),
              ),
              child: Text(active ? 'Active' : 'Inactive',
                  style: TextStyle(
                      color: active ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                      fontSize: 10, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 6),
            Switch(
              value: active, onChanged: onToggle,
              activeColor: Colors.white, activeTrackColor: accentColor,
              inactiveThumbColor: const Color(0xFFBBBBCC),
              inactiveTrackColor: const Color(0xFFEEEEF5),
            ),
          ]),

          const SizedBox(height: 10),
          Row(children: [
            _MiniStat(label: 'Flow Rate', value: '${flow.toStringAsFixed(1)} L/min',
                color: accentColor),
            const SizedBox(width: 20),
            _MiniStat(label: 'Usage', value: '$usage L',
                color: const Color(0xFF6A6A8A)),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _OutlineButton(label: 'Edit',   icon: Icons.edit_outlined,
                color: accentColor,              onTap: onEdit)),
            const SizedBox(width: 8),
            Expanded(child: _OutlineButton(label: 'Remove', icon: Icons.delete_outline,
                color: const Color(0xFFFF3B3B), onTap: onDelete)),
          ]),
        ]),
      ),
    );
  }
}

class _EmptyMeters extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyMeters({required this.onAdd});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 48),
    decoration: BoxDecoration(color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEF5))),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: const Color(0xFF4CAF50).withOpacity(0.10), shape: BoxShape.circle),
        child: const Icon(Icons.water_drop_outlined, color: Color(0xFF4CAF50), size: 32),
      ),
      const SizedBox(height: 14),
      const Text('No sub-meters yet',
          style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 15, fontWeight: FontWeight.w700)),
      const SizedBox(height: 4),
      const Text('Add your first sub-meter to start monitoring',
          style: TextStyle(color: Color(0xFF9090A0), fontSize: 12)),
      const SizedBox(height: 16),
      ElevatedButton.icon(
        onPressed: onAdd,
        icon: const Icon(Icons.add_rounded, size: 16),
        label: const Text('Add Sub-Meter'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50), foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    ]),
  );
}

// ═══════════════════════════════════════════════════════════════
// ALERT THRESHOLDS SCREEN
// ═══════════════════════════════════════════════════════════════

class AlertThresholdsScreen extends StatefulWidget {
  const AlertThresholdsScreen({super.key});

  @override
  State<AlertThresholdsScreen> createState() => _AlertThresholdsScreenState();
}

class _AlertThresholdsScreenState extends State<AlertThresholdsScreen> {
  static const _green  = Color(0xFF4CAF50);
  static const _orange = Color(0xFFFF6B00);
  static const _red    = Color(0xFFFF3B3B);
  static const _blue   = Color(0xFF00BCD4);

  final _minLevelCtrl      = TextEditingController(text: '20');
  final _criticalLevelCtrl = TextEditingController(text: '10');
  final _maxLevelCtrl      = TextEditingController(text: '95');
  final _minFlowCtrl       = TextEditingController(text: '50');
  final _maxFlowCtrl       = TextEditingController(text: '6000');
  final _noFlowDurCtrl     = TextEditingController(text: '30');
  final _dailyLimitCtrl    = TextEditingController(text: '10000');
  final _hourlySpike       = TextEditingController(text: '800');
  final _batteryLowCtrl    = TextEditingController(text: '20');
  final _batteryCritCtrl   = TextEditingController(text: '10');

  bool _alertWaterLevel  = true;
  bool _alertFlow        = true;
  bool _alertConsumption = true;
  bool _alertPower       = true;
  bool _alertDryRun      = true;
  bool _alertLeak        = true;
  bool _saving           = false;

  @override
  void dispose() {
    for (final c in [_minLevelCtrl, _criticalLevelCtrl, _maxLevelCtrl,
      _minFlowCtrl, _maxFlowCtrl, _noFlowDurCtrl,
      _dailyLimitCtrl, _hourlySpike, _batteryLowCtrl, _batteryCritCtrl]) c.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 900));
    setState(() => _saving = false);
    if (mounted) { _snack('✅ Alert thresholds saved!', _green); Navigator.pop(context); }
  }

  void _snack(String msg, Color color) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(children: [
          Container(width: 4, height: 32,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 10),
          Expanded(child: Text(msg, style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 13))),
        ]),
        backgroundColor: Colors.white, behavior: SnackBarBehavior.floating, elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color.withOpacity(0.3))),
        duration: const Duration(seconds: 2),
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: _buildAppBar('Alert Thresholds', Icons.tune_outlined, _green),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: _blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _blue.withOpacity(0.2))),
            child: Row(children: [
              Icon(Icons.info_outline, color: _blue, size: 18),
              const SizedBox(width: 10),
              const Expanded(child: Text(
                'Alerts fire via your notification settings. Enable Push, Email or SMS in Settings.',
                style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 12, height: 1.5),
              )),
            ]),
          ),
          const SizedBox(height: 20),

          _ThresholdSection(title: 'Water Level',    icon: Icons.water_outlined,         color: _blue,
              enabled: _alertWaterLevel,  onToggle: (v) => setState(() => _alertWaterLevel  = v), children: [
                _Field(controller: _minLevelCtrl,      label: 'Low Level Warning (%)',          icon: Icons.arrow_downward_outlined, keyboard: TextInputType.number),
                const _FDivider(),
                _Field(controller: _criticalLevelCtrl, label: 'Critical Level (%)',             icon: Icons.warning_amber_outlined,  keyboard: TextInputType.number),
                const _FDivider(),
                _Field(controller: _maxLevelCtrl,      label: 'High Level Alert (%)',           icon: Icons.arrow_upward_outlined,   keyboard: TextInputType.number),
              ]),
          const SizedBox(height: 20),

          _ThresholdSection(title: 'Flow Rate',      icon: Icons.waves_outlined,         color: _orange,
              enabled: _alertFlow,        onToggle: (v) => setState(() => _alertFlow         = v), children: [
                _Field(controller: _minFlowCtrl,    label: 'Minimum Flow (L/hr)',              icon: Icons.trending_down_outlined, keyboard: TextInputType.number),
                const _FDivider(),
                _Field(controller: _maxFlowCtrl,    label: 'Maximum Flow (L/hr)',              icon: Icons.trending_up_outlined,   keyboard: TextInputType.number),
                const _FDivider(),
                _Field(controller: _noFlowDurCtrl,  label: 'No-Flow Alert Duration (min)',     icon: Icons.timer_off_outlined,     keyboard: TextInputType.number),
              ]),
          const SizedBox(height: 20),

          _ThresholdSection(title: 'Consumption',    icon: Icons.bar_chart_outlined,     color: _green,
              enabled: _alertConsumption, onToggle: (v) => setState(() => _alertConsumption  = v), children: [
                _Field(controller: _dailyLimitCtrl, label: 'Daily Usage Limit (L)',            icon: Icons.calendar_today_outlined, keyboard: TextInputType.number),
                const _FDivider(),
                _Field(controller: _hourlySpike,    label: 'Hourly Spike Threshold (L)',       icon: Icons.bolt_outlined,           keyboard: TextInputType.number),
              ]),
          const SizedBox(height: 20),

          _ThresholdSection(title: 'Power & Battery', icon: Icons.battery_alert_outlined, color: _red,
              enabled: _alertPower,       onToggle: (v) => setState(() => _alertPower        = v), children: [
                _Field(controller: _batteryLowCtrl,  label: 'Low Battery Warning (%)',         icon: Icons.battery_3_bar_outlined, keyboard: TextInputType.number),
                const _FDivider(),
                _Field(controller: _batteryCritCtrl, label: 'Critical Battery Level (%)',      icon: Icons.battery_0_bar_outlined, keyboard: TextInputType.number),
              ]),
          const SizedBox(height: 20),

          _SectionLabel(title: 'Safety Alerts', icon: Icons.shield_outlined, color: _red),
          const SizedBox(height: 10),
          _Card(children: [
            _ToggleRow(label: 'Dry-Run Protection Alert',
                subtitle: 'Notify when pump runs without water',
                value: _alertDryRun, color: _red,
                onChanged: (v) => setState(() => _alertDryRun = v)),
            const _FDivider(),
            _ToggleRow(label: 'Leak Detection Alert',
                subtitle: 'Flag abnormal usage patterns as possible leaks',
                value: _alertLeak, color: _red,
                onChanged: (v) => setState(() => _alertLeak = v)),
          ]),
          const SizedBox(height: 28),

          _SaveButton(label: 'Save Thresholds', color: _green, loading: _saving, onTap: _save),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }
}

class _ThresholdSection extends StatelessWidget {
  final String title; final IconData icon; final Color color;
  final bool enabled; final ValueChanged<bool> onToggle;
  final List<Widget> children;
  const _ThresholdSection({required this.title, required this.icon, required this.color,
      required this.enabled, required this.onToggle, required this.children});

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [
      _SectionLabel(title: title, icon: icon, color: color),
      const Spacer(),
      Switch(value: enabled, onChanged: onToggle,
          activeColor: Colors.white, activeTrackColor: color,
          inactiveThumbColor: const Color(0xFFBBBBCC),
          inactiveTrackColor: const Color(0xFFEEEEF5)),
    ]),
    const SizedBox(height: 10),
    AnimatedOpacity(
      opacity: enabled ? 1.0 : 0.4,
      duration: const Duration(milliseconds: 200),
      child: IgnorePointer(ignoring: !enabled, child: _Card(children: children)),
    ),
  ]);
}

// ═══════════════════════════════════════════════════════════════
// SHARED HELPER WIDGETS
// ═══════════════════════════════════════════════════════════════

PreferredSizeWidget _buildAppBar(String title, IconData icon, Color color) => AppBar(
  title: Row(children: [
    Container(padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: color, size: 16)),
    const SizedBox(width: 10),
    Text(title, style: const TextStyle(color: Color(0xFF1A1A2E),
        fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: -0.3)),
  ]),
  backgroundColor: Colors.white, foregroundColor: const Color(0xFF1A1A2E),
  elevation: 0, surfaceTintColor: Colors.transparent,
  bottom: PreferredSize(preferredSize: const Size.fromHeight(1),
      child: Container(color: const Color(0xFFEEEEF5), height: 1)),
);

class _SectionLabel extends StatelessWidget {
  final String title; final IconData icon; final Color color;
  const _SectionLabel({required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Container(padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(color: color.withOpacity(0.10),
            borderRadius: BorderRadius.circular(6)),
        child: Icon(icon, color: color, size: 14)),
    const SizedBox(width: 8),
    Text(title, style: TextStyle(color: color, fontSize: 12,
        fontWeight: FontWeight.w700, letterSpacing: 0.3)),
  ]);
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEF5)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
            blurRadius: 10, offset: const Offset(0, 3))]),
    child: Column(children: children),
  );
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label; final IconData icon; final TextInputType keyboard;
  const _Field({required this.controller, required this.label,
      required this.icon, this.keyboard = TextInputType.text});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    child: TextField(
      controller: controller, keyboardType: keyboard,
      inputFormatters: keyboard == TextInputType.number
          ? [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))] : null,
      style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF9090A0), fontSize: 12),
        prefixIcon: Icon(icon, color: const Color(0xFF9090A0), size: 17),
        filled: true, fillColor: const Color(0xFFF7F8FC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFEEEEF5))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFEEEEF5))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 1.5)),
      ),
    ),
  );
}

class _FDivider extends StatelessWidget {
  const _FDivider();
  @override
  Widget build(BuildContext context) =>
      const Divider(color: Color(0xFFEEEEF5), height: 1, indent: 14, endIndent: 14);
}

class _ToggleRow extends StatelessWidget {
  final String label, subtitle; final bool value; final Color color;
  final ValueChanged<bool> onChanged;
  const _ToggleRow({required this.label, required this.subtitle,
      required this.value, required this.color, required this.onChanged});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: Color(0xFF1A1A2E),
            fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(subtitle, style: const TextStyle(color: Color(0xFF9090A0), fontSize: 11)),
      ])),
      Switch(value: value, onChanged: onChanged,
          activeColor: Colors.white, activeTrackColor: color,
          inactiveThumbColor: const Color(0xFFBBBBCC),
          inactiveTrackColor: const Color(0xFFEEEEF5)),
    ]),
  );
}

class _DropdownRow extends StatelessWidget {
  final String label, value; final IconData icon;
  final List<String> options; final Color color; final ValueChanged<String?> onChanged;
  const _DropdownRow({required this.label, required this.icon, required this.value,
      required this.options, required this.color, required this.onChanged});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(children: [
      Icon(icon, color: const Color(0xFF9090A0), size: 18),
      const SizedBox(width: 10),
      Expanded(child: Text(label, style: const TextStyle(color: Color(0xFF1A1A2E),
          fontSize: 14, fontWeight: FontWeight.w600))),
      DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value, dropdownColor: Colors.white,
          style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: color, size: 18),
          items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
          onChanged: onChanged,
        ),
      ),
    ]),
  );
}

class _TimeRow extends StatelessWidget {
  final String label; final TimeOfDay time;
  final bool enabled; final Color color; final VoidCallback onTap;
  const _TimeRow({required this.label, required this.time,
      required this.enabled, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    child: Row(children: [
      Icon(Icons.access_time_outlined, color: const Color(0xFF9090A0), size: 18),
      const SizedBox(width: 10),
      Expanded(child: Text(label, style: const TextStyle(color: Color(0xFF1A1A2E),
          fontSize: 14, fontWeight: FontWeight.w600))),
      GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: enabled ? color.withOpacity(0.08) : const Color(0xFFEEEEF5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: enabled ? color.withOpacity(0.3) : const Color(0xFFEEEEF5)),
          ),
          child: Text(time.format(context), style: TextStyle(
              color: enabled ? color : const Color(0xFF9090A0),
              fontWeight: FontWeight.w700, fontSize: 13)),
        ),
      ),
    ]),
  );
}

class _StatusBanner extends StatelessWidget {
  final String status, label; final Color activeColor;
  const _StatusBanner({required this.status, required this.label, required this.activeColor});

  @override
  Widget build(BuildContext context) {
    final isActive = status == 'Active';
    final color    = isActive ? activeColor : const Color(0xFFFF6B00);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.25))),
      child: Row(children: [
        Container(width: 10, height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Text('$label: $status',
            style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13)),
      ]),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label, value; final IconData icon; final Color color;
  const _StatChip({required this.label, required this.value,
      required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEF5)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03),
            blurRadius: 8, offset: const Offset(0, 2))]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: color, size: 16),
      const SizedBox(height: 6),
      Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w800)),
      Text(label, style: const TextStyle(color: Color(0xFF9090A0),
          fontSize: 10, fontWeight: FontWeight.w500)),
    ]),
  );
}

class _MiniStat extends StatelessWidget {
  final String label, value; final Color color;
  const _MiniStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(color: Color(0xFF9090A0), fontSize: 10)),
    Text(value, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700)),
  ]);
}

class _OutlineButton extends StatelessWidget {
  final String label; final IconData icon; final Color color; final VoidCallback onTap;
  const _OutlineButton({required this.label, required this.icon,
      required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.25))),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
      ]),
    ),
  );
}

class _SaveButton extends StatelessWidget {
  final String label; final Color color; final bool loading; final VoidCallback onTap;
  const _SaveButton({required this.label, required this.color,
      required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: loading ? null : onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: loading ? color.withOpacity(0.5) : color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: color.withOpacity(0.35),
            blurRadius: 12, offset: const Offset(0, 5))],
      ),
      alignment: Alignment.center,
      child: loading
          ? const SizedBox(width: 20, height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
          : Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.check_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.white,
                  fontWeight: FontWeight.w700, fontSize: 14)),
            ]),
    ),
  );
}