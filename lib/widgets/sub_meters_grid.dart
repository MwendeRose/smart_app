// lib/widgets/sub_meters_grid.dart
// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ─── Colours ─────────────────────────────────────────────────
class _C {
  static const Color bg        = Color(0xFFEFF6FF);
  static const Color surface   = Color(0xFFFFFFFF);
  static const Color border    = Color(0xFFBFD7F5);
  static const Color accent    = Color(0xFF2563EB);
  static const Color accentBg  = Color(0x262563EB);
  static const Color green     = Color(0xFF16A34A);
  static const Color greenBg   = Color(0xFFDCFCE7);
  static const Color greenBdr  = Color(0xFFBBF7D0);
  static const Color red       = Color(0xFFDC2626);
  static const Color redBg     = Color(0xFFFEE2E2);
  static const Color redBdr    = Color(0xFFFECACA);
  static const Color textPri   = Color(0xFF0F172A);
  static const Color textSub   = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
}

// ─── Model ───────────────────────────────────────────────────
class SubMeter {
  final String id;
  String name;
  String location;
  String meterId;
  double flowRate;
  int    usage;
  bool   isActive;

  SubMeter({
    required this.id,
    required this.name,
    required this.location,
    required this.meterId,
    required this.flowRate,
    required this.usage,
    required this.isActive,
  });

  factory SubMeter.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return SubMeter(
      id:       doc.id,
      name:     d['name']     as String? ?? 'Sub Meter',
      location: d['location'] as String? ?? '',
      meterId:  d['meterId']  as String? ?? '',
      flowRate: (d['flowRate'] as num?)?.toDouble() ?? 0.0,
      usage:    (d['usage']   as num?)?.toInt()     ?? 0,
      isActive: d['isActive'] as bool?              ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
    'name':      name,
    'location':  location,
    'meterId':   meterId,
    'flowRate':  flowRate,
    'usage':     usage,
    'isActive':  isActive,
    'createdAt': FieldValue.serverTimestamp(),
  };
}

// ─── Firestore reference ──────────────────────────────────────
final _col = FirebaseFirestore.instance.collection('submeters');

// ─── Main widget ─────────────────────────────────────────────
class SubMetersGrid extends StatefulWidget {
  const SubMetersGrid({super.key});

  @override
  State<SubMetersGrid> createState() => _SubMetersGridState();
}

class _SubMetersGridState extends State<SubMetersGrid> {
  bool _saving = false;

  // ── Firestore CRUD ───────────────────────────────────────────

  Future<String?> _create(Map<String, dynamic> data) async {
    try {
      final ref = await _col.add({
        'name':      data['name'],
        'location':  data['location'],
        'meterId':   data['meterId'],
        'flowRate':  data['flowRate'],
        'usage':     data['usage'],
        'isActive':  data['isActive'],
        'createdAt': FieldValue.serverTimestamp(),
      });
      return ref.id;
    } catch (e) {
      return null;
    }
  }

  Future<void> _update(String id, Map<String, dynamic> data) async {
    try {
      await _col.doc(id).update({
        'name':     data['name'],
        'location': data['location'],
        'meterId':  data['meterId'],
        'flowRate': data['flowRate'],
        'usage':    data['usage'],
        'isActive': data['isActive'],
      });
    } catch (_) {}
  }

  Future<void> _delete(String id) async {
    try {
      await _col.doc(id).delete();
    } catch (_) {}
  }

  // ── Dialogs ──────────────────────────────────────────────────

  void _openAdd() {
    showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _SubMeterDialog(title: 'Add Sub Meter'),
    ).then((data) async {
      if (data == null || !mounted) return;
      setState(() => _saving = true);
      final id = await _create(data);
      if (!mounted) return;
      setState(() => _saving = false);
      _snack(
        id != null
            ? '✓ "${data['name']}" added to Firestore.'
            : '✗ Failed to save. Check your connection.',
        success: id != null,
      );
    });
  }

  void _openEdit(SubMeter m) {
    showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _SubMeterDialog(title: 'Edit Sub Meter', initial: m),
    ).then((data) async {
      if (data == null || !mounted) return;
      await _update(m.id, data);
      if (!mounted) return;
      _snack('✓ "${data['name']}" updated.');
    });
  }

  void _confirmDelete(SubMeter m) {
    showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _C.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
        title: const Text('Delete Sub Meter',
            style: TextStyle(
                color: _C.textPri,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
        content: Text('Delete "${m.name}"? This cannot be undone.',
            style: const TextStyle(color: _C.textSub, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel',
                style: TextStyle(color: _C.textSub)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _C.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    ).then((confirmed) async {
      if (confirmed != true || !mounted) return;
      await _delete(m.id);
      if (!mounted) return;
      _snack('Meter "${m.name}" deleted.');
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
        duration: const Duration(seconds: 3),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // ── Build — uses StreamBuilder for real-time updates ─────────

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ──
        StreamBuilder<QuerySnapshot>(
          stream: _col.orderBy('createdAt', descending: false).snapshots(),
          builder: (ctx, snap) {
            final count = snap.data?.docs.length ?? 0;
            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: _C.accentBg,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.grid_view_rounded,
                      color: _C.accent, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sub Meters',
                          style: TextStyle(
                              color: _C.textPri,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                      Text(
                        '$count meter${count == 1 ? '' : 's'} connected',
                        style: const TextStyle(
                            color: _C.textSub, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _saving ? null : _openAdd,
                  icon: _saving
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.add_rounded, size: 16),
                  label: Text(_saving ? 'Saving...' : 'Add Meter',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _C.accent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 14),

        // ── Real-time grid via StreamBuilder ──
        StreamBuilder<QuerySnapshot>(
          stream: _col.orderBy('createdAt', descending: false).snapshots(),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: CircularProgressIndicator(
                      color: _C.accent, strokeWidth: 2),
                ),
              );
            }

            if (snap.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('Error: ${snap.error}',
                      style: const TextStyle(color: _C.red)),
                ),
              );
            }

            final docs   = snap.data?.docs ?? [];
            final meters = docs
                .map((d) => SubMeter.fromDoc(d))
                .toList();

            if (meters.isEmpty) return _EmptyState(onAdd: _openAdd);

            return LayoutBuilder(
              builder: (ctx, constraints) {
                final cols = constraints.maxWidth > 700 ? 3 : 2;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:   cols,
                    crossAxisSpacing: 12,
                    mainAxisSpacing:  12,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: meters.length,
                  itemBuilder: (_, i) => _SubMeterTile(
                    meter:    meters[i],
                    onEdit:   () => _openEdit(meters[i]),
                    onDelete: () => _confirmDelete(meters[i]),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

// ─── Tile ─────────────────────────────────────────────────────

class _SubMeterTile extends StatelessWidget {
  final SubMeter     meter;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SubMeterTile({
    required this.meter,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final active = meter.isActive;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: active ? _C.border : _C.redBdr),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: active ? _C.accentBg : _C.redBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.water_rounded,
                    color: active ? _C.accent : _C.red, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(meter.name,
                    style: const TextStyle(
                        color: _C.textPri,
                        fontSize: 13,
                        fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: active ? _C.greenBg : _C.redBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: active ? _C.greenBdr : _C.redBdr),
                ),
                child: Text(
                  active ? 'Active' : 'Inactive',
                  style: TextStyle(
                      color: active ? _C.green : _C.red,
                      fontSize: 9,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(meter.location,
              style: const TextStyle(
                  color: _C.textSub, fontSize: 10),
              overflow: TextOverflow.ellipsis),
          Text('ID: ${meter.meterId}',
              style: const TextStyle(
                  color: _C.textMuted, fontSize: 9)),

          const Spacer(),

          Row(
            children: [
              _Stat(
                  label: 'Flow',
                  value: '${meter.flowRate.toStringAsFixed(1)} L/m'),
              const SizedBox(width: 12),
              _Stat(label: 'Usage', value: '${meter.usage} L'),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _ActionBtn(
                icon: Icons.edit_outlined,
                color: _C.accent,
                bg: _C.accentBg,
                tooltip: 'Edit',
                onTap: onEdit,
              ),
              const SizedBox(width: 6),
              _ActionBtn(
                icon: Icons.delete_outline_rounded,
                color: _C.red,
                bg: _C.redBg,
                tooltip: 'Delete',
                onTap: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: _C.textMuted, fontSize: 9)),
        Text(value,
            style: const TextStyle(
                color: _C.textPri,
                fontSize: 12,
                fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData     icon;
  final Color        color;
  final Color        bg;
  final String       tooltip;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.bg,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: bg, borderRadius: BorderRadius.circular(6)),
          child: Icon(icon, color: color, size: 14),
        ),
      ),
    );
  }
}

// ─── Empty state ─────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
                color: _C.accentBg, shape: BoxShape.circle),
            child: const Icon(Icons.water_drop_outlined,
                color: _C.accent, size: 32),
          ),
          const SizedBox(height: 12),
          const Text('No sub meters yet',
              style: TextStyle(
                  color: _C.textPri,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text('Add your first sub meter to start monitoring',
              style: TextStyle(color: _C.textSub, fontSize: 12)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded, size: 16),
            label: const Text('Add Sub Meter'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _C.accent,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Add / Edit dialog ────────────────────────────────────────

class _SubMeterDialog extends StatefulWidget {
  final String    title;
  final SubMeter? initial;

  const _SubMeterDialog({required this.title, this.initial});

  @override
  State<_SubMeterDialog> createState() => _SubMeterDialogState();
}

class _SubMeterDialogState extends State<_SubMeterDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _meterIdCtrl;
  late final TextEditingController _flowCtrl;
  late final TextEditingController _usageCtrl;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    final m       = widget.initial;
    _nameCtrl     = TextEditingController(text: m?.name     ?? '');
    _locationCtrl = TextEditingController(text: m?.location ?? '');
    _meterIdCtrl  = TextEditingController(text: m?.meterId  ?? '');
    _flowCtrl     = TextEditingController(
        text: m != null ? m.flowRate.toString() : '');
    _usageCtrl    = TextEditingController(
        text: m != null ? m.usage.toString() : '');
    _isActive     = m?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _locationCtrl.dispose();
    _meterIdCtrl.dispose();
    _flowCtrl.dispose();
    _usageCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Meter name is required.'),
          backgroundColor: _C.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    Navigator.pop(context, {
      'name':     name,
      'location': _locationCtrl.text.trim(),
      'meterId':  _meterIdCtrl.text.trim(),
      'flowRate': double.tryParse(_flowCtrl.text) ?? 0.0,
      'usage':    int.tryParse(_usageCtrl.text)   ?? 0,
      'isActive': _isActive,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _C.surface,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      color: _C.accentBg,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.water_rounded,
                      color: _C.accent, size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(widget.title,
                      style: const TextStyle(
                          color: _C.textPri,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded,
                      color: _C.textSub, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Meter is saved to Firestore and appears instantly.',
              style: TextStyle(color: _C.textMuted, fontSize: 11),
            ),
            const SizedBox(height: 14),
            const Divider(color: _C.border, height: 1),
            const SizedBox(height: 14),

            _DField(label: 'Meter Name *', ctrl: _nameCtrl,
                hint: 'e.g. Block A Meter'),
            const SizedBox(height: 10),
            _DField(label: 'Location', ctrl: _locationCtrl,
                hint: 'e.g. Block A, Ground Floor'),
            const SizedBox(height: 10),
            _DField(label: 'Meter ID', ctrl: _meterIdCtrl,
                hint: 'e.g. SM-001'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _DField(
                    label: 'Flow Rate (L/min)',
                    ctrl: _flowCtrl,
                    hint: '0.0',
                    keyboard: const TextInputType.numberWithOptions(
                        decimal: true),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _DField(
                    label: 'Usage (Litres)',
                    ctrl: _usageCtrl,
                    hint: '0',
                    keyboard: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _C.bg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _C.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.toggle_on_rounded,
                      color: _C.accent, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Meter Active',
                            style: TextStyle(
                                color: _C.textPri,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                        Text('Toggle off if meter is offline or unused',
                            style: TextStyle(
                                color: _C.textMuted, fontSize: 10)),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isActive,
                    onChanged: (v) => setState(() => _isActive = v),
                    activeColor: _C.accent,
                  ),
                ],
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
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _C.accent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding:
                          const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      widget.initial == null
                          ? 'Add Meter'
                          : 'Save Changes',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700),
                    ),
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

class _DField extends StatelessWidget {
  final String                label;
  final TextEditingController ctrl;
  final String                hint;
  final TextInputType         keyboard;

  const _DField({
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
                fontWeight: FontWeight.w500)),
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
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _C.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _C.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: _C.accent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}