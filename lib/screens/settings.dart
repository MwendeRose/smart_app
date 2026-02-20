// lib/screens/settings.dart
// ignore_for_file: deprecated_member_use, unnecessary_underscores

import 'package:flutter/material.dart';
import '../services/auth_service.dart';

// ─────────────────────────────────────────────────────────────
class SettingsRoute extends StatelessWidget {
  const SettingsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: const Text('Settings',
            style: TextStyle(
                color: Color(0xFF1A1A2E),
                fontWeight: FontWeight.w800,
                fontSize: 17,
                letterSpacing: -0.3)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFEEEEF5), height: 1),
        ),
      ),
      body: const SettingsPage(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool   _pushNotifications = true;
  bool   _emailAlerts       = false;
  bool   _smsAlerts         = true;
  bool   _darkMode          = false;
  bool   _autoRefresh       = true;
  String _refreshInterval   = '5 min';
  String _language          = 'English';
  String _units             = 'Litres';

  final _auth = AuthService.instance;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _auth,
      builder: (context, _) {
        final user = _auth.user;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Profile Card ─────────────────────────────
              _ProfileCard(
                name:     user?.name     ?? 'Loading...',
                role:     user?.role     ?? '',
                email:    user?.email    ?? '',
                initials: user?.initials ?? '?',
                onEditTap: () => _showEditProfileSheet(context),
              ),

              const SizedBox(height: 24),

              _SectionHeader(title: 'Notifications', icon: Icons.notifications_outlined, color: const Color(0xFF6C63FF)),
              const SizedBox(height: 10),
              _SettingsCard(children: [
                _ToggleTile(
                  title: 'Push Notifications',
                  subtitle: 'Receive alerts on your device',
                  value: _pushNotifications,
                  onChanged: (v) => setState(() => _pushNotifications = v),
                ),
                _Divider(),
                _ToggleTile(
                  title: 'Email Alerts',
                  subtitle: 'Critical alerts via email',
                  value: _emailAlerts,
                  onChanged: (v) => setState(() => _emailAlerts = v),
                ),
                _Divider(),
                _ToggleTile(
                  title: 'SMS Alerts',
                  subtitle: 'Text messages for emergencies',
                  value: _smsAlerts,
                  onChanged: (v) => setState(() => _smsAlerts = v),
                ),
              ]),

              const SizedBox(height: 20),

              _SectionHeader(title: 'Display & Preferences', icon: Icons.palette_outlined, color: const Color(0xFFFF6B00)),
              const SizedBox(height: 10),
              _SettingsCard(children: [
                _ToggleTile(
                  title: 'Dark Mode',
                  subtitle: 'Use dark theme throughout the app',
                  value: _darkMode,
                  onChanged: (v) => setState(() => _darkMode = v),
                ),
                _Divider(),
                _DropdownTile(
                  title: 'Language',
                  value: _language,
                  options: const ['English', 'Kiswahili', 'French'],
                  onChanged: (v) => setState(() => _language = v!),
                ),
                _Divider(),
                _DropdownTile(
                  title: 'Measurement Units',
                  value: _units,
                  options: const ['Litres', 'Gallons', 'Cubic Metres'],
                  onChanged: (v) => setState(() => _units = v!),
                ),
              ]),

              const SizedBox(height: 20),

              _SectionHeader(title: 'Data & Sync', icon: Icons.sync_outlined, color: const Color(0xFF00BCD4)),
              const SizedBox(height: 10),
              _SettingsCard(children: [
                _ToggleTile(
                  title: 'Auto Refresh',
                  subtitle: 'Automatically update readings',
                  value: _autoRefresh,
                  onChanged: (v) => setState(() => _autoRefresh = v),
                ),
                _Divider(),
                _DropdownTile(
                  title: 'Refresh Interval',
                  value: _refreshInterval,
                  options: const ['1 min', '5 min', '10 min', '30 min'],
                  onChanged: (v) => setState(() => _refreshInterval = v!),
                ),
                _Divider(),
                _ActionTile(
                  title: 'Export Data',
                  subtitle: 'Download usage reports as CSV',
                  icon: Icons.download_outlined,
                  iconColor: const Color(0xFF00BCD4),
                  accentColor: const Color(0xFF00BCD4),
                  onTap: () => _snack(context, '📥 Exporting data...', const Color(0xFF00BCD4)),
                ),
                _Divider(),
                _ActionTile(
                  title: 'Clear Cache',
                  subtitle: 'Remove locally stored data',
                  icon: Icons.delete_outline,
                  iconColor: const Color(0xFFFF3B3B),
                  accentColor: const Color(0xFFFF3B3B),
                  onTap: () => _confirm(
                    context,
                    'Clear Cache',
                    'Are you sure you want to clear all cached data?',
                  ),
                ),
              ]),

              const SizedBox(height: 20),

              _SectionHeader(title: 'System', icon: Icons.settings_outlined, color: const Color(0xFF4CAF50)),
              const SizedBox(height: 10),
              _SettingsCard(children: [
                _ActionTile(
                  title: 'Borehole Configuration',
                  subtitle: 'Manage borehole and pump settings',
                  icon: Icons.settings_input_component_outlined,
                  iconColor: const Color(0xFF4CAF50),
                  accentColor: const Color(0xFF4CAF50),
                  onTap: () => _snack(context, '⚙️ Opening borehole config...', const Color(0xFF4CAF50)),
                ),
                _Divider(),
                _ActionTile(
                  title: 'Sub-Meter Management',
                  subtitle: 'Add, remove or rename sub-meters',
                  icon: Icons.grid_view_outlined,
                  iconColor: const Color(0xFF4CAF50),
                  accentColor: const Color(0xFF4CAF50),
                  onTap: () => _snack(context, '📊 Opening sub-meter management...', const Color(0xFF4CAF50)),
                ),
                _Divider(),
                _ActionTile(
                  title: 'Alert Thresholds',
                  subtitle: 'Set critical water level limits',
                  icon: Icons.tune_outlined,
                  iconColor: const Color(0xFF4CAF50),
                  accentColor: const Color(0xFF4CAF50),
                  onTap: () => _snack(context, '🎚️ Opening threshold settings...', const Color(0xFF4CAF50)),
                ),
              ]),

              const SizedBox(height: 20),

              _SectionHeader(title: 'Account', icon: Icons.person_outline, color: const Color(0xFF6C63FF)),
              const SizedBox(height: 10),
              _SettingsCard(children: [
                _ActionTile(
                  title: 'Edit Profile',
                  subtitle: 'Update your name and contact info',
                  icon: Icons.edit_outlined,
                  iconColor: const Color(0xFF6C63FF),
                  accentColor: const Color(0xFF6C63FF),
                  onTap: () => _showEditProfileSheet(context),
                ),
                _Divider(),
                _ActionTile(
                  title: 'Change Password',
                  subtitle: 'Update your account password',
                  icon: Icons.lock_outline,
                  iconColor: const Color(0xFFFF6B00),
                  accentColor: const Color(0xFFFF6B00),
                  onTap: () => _showChangePasswordSheet(context),
                ),
                _Divider(),
                _ActionTile(
                  title: 'Sign Out',
                  subtitle: 'Log out of your account',
                  icon: Icons.logout_rounded,
                  iconColor: const Color(0xFFFF3B3B),
                  accentColor: const Color(0xFFFF3B3B),
                  titleColor: const Color(0xFFFF3B3B),
                  onTap: () => _confirm(
                    context,
                    'Sign Out',
                    'Are you sure you want to sign out?',
                    confirmLabel: 'Sign Out',
                    confirmColor: const Color(0xFFFF3B3B),
                    onConfirm: () async {
                      await _auth.signOut();
                    },
                  ),
                ),
              ]),

              const SizedBox(height: 24),

              Center(
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFEEEEF5)),
                    ),
                    child: const Text('Maji Smart v1.0.0',
                        style: TextStyle(
                            color: Color(0xFF9090A0), fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 6),
                  const Text('© 2025 Snapp Africa',
                      style: TextStyle(color: Color(0xFFBBBBCC), fontSize: 11)),
                ]),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // ── Edit Profile Sheet ────────────────────────────────────

  void _showEditProfileSheet(BuildContext context) {
    final user      = _auth.user;
    final nameCtrl  = TextEditingController(text: user?.name);
    final phoneCtrl = TextEditingController(text: user?.phone);
    final roleCtrl  = TextEditingController(text: user?.role);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.edit_outlined, color: Color(0xFF6C63FF), size: 16),
                ),
                const SizedBox(width: 10),
                const Text('Edit Profile',
                    style: TextStyle(
                        color: Color(0xFF1A1A2E),
                        fontSize: 16,
                        fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 18),
            _SheetField(controller: nameCtrl,  label: 'Full Name',    icon: Icons.person_outline),
            const SizedBox(height: 12),
            _SheetField(controller: phoneCtrl, label: 'Phone',        icon: Icons.phone_outlined),
            const SizedBox(height: 12),
            _SheetField(controller: roleCtrl,  label: 'Role / Title', icon: Icons.badge_outlined),
            const SizedBox(height: 20),
            ListenableBuilder(
              listenable: _auth,
              builder: (_, __) => _ImpactButton(
                label: 'Save Changes',
                icon: Icons.check_rounded,
                color: const Color(0xFF6C63FF),
                loading: _auth.loading,
                onTap: () async {
                  final err = await _auth.updateProfile(
                    name:  nameCtrl.text.trim(),
                    phone: phoneCtrl.text.trim(),
                    role:  roleCtrl.text.trim(),
                  );
                  if (context.mounted) {
                    Navigator.pop(context);
                    _snack(context,
                        err == null ? '✅ Profile updated!' : '❌ $err',
                        err == null ? const Color(0xFF4CAF50) : const Color(0xFFFF3B3B));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Change Password Sheet ─────────────────────────────────

  void _showChangePasswordSheet(BuildContext context) {
    final currentCtrl = TextEditingController();
    final newCtrl     = TextEditingController();
    final confirmCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B00).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.lock_outline, color: Color(0xFFFF6B00), size: 16),
                ),
                const SizedBox(width: 10),
                const Text('Change Password',
                    style: TextStyle(
                        color: Color(0xFF1A1A2E),
                        fontSize: 16,
                        fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 18),
            _SheetField(controller: currentCtrl, label: 'Current Password',      icon: Icons.lock_outline,  obscure: true),
            const SizedBox(height: 12),
            _SheetField(controller: newCtrl,     label: 'New Password',          icon: Icons.lock_reset_outlined, obscure: true),
            const SizedBox(height: 12),
            _SheetField(controller: confirmCtrl, label: 'Confirm New Password',  icon: Icons.lock_outline,  obscure: true),
            const SizedBox(height: 20),
            ListenableBuilder(
              listenable: _auth,
              builder: (_, __) => _ImpactButton(
                label: 'Update Password',
                icon: Icons.lock_reset_rounded,
                color: const Color(0xFFFF6B00),
                loading: _auth.loading,
                onTap: () async {
                  if (newCtrl.text != confirmCtrl.text) {
                    _snack(context, '❌ Passwords do not match', const Color(0xFFFF3B3B));
                    return;
                  }
                  final err = await _auth.updateProfile(password: newCtrl.text);
                  if (context.mounted) {
                    Navigator.pop(context);
                    _snack(context,
                        err == null ? '✅ Password changed!' : '❌ $err',
                        err == null ? const Color(0xFF4CAF50) : const Color(0xFFFF3B3B));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────

  void _snack(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          Container(
            width: 4, height: 32,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(msg,
              style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 13))),
        ],
      ),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      elevation: 6,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color.withOpacity(0.3))),
      duration: const Duration(seconds: 2),
    ));
  }

  void _confirm(
    BuildContext context,
    String title,
    String message, {
    String confirmLabel = 'Confirm',
    Color confirmColor = const Color(0xFF6C63FF),
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title,
            style: const TextStyle(
                color: Color(0xFF1A1A2E),
                fontWeight: FontWeight.w800,
                fontSize: 16)),
        content: Text(message,
            style: const TextStyle(color: Color(0xFF6A6A8A), fontSize: 13, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF9090A0),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm?.call();
            },
            style: FilledButton.styleFrom(
              backgroundColor: confirmColor,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(confirmLabel,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

// ── Impact Button (animated press) ───────────────────────────

class _ImpactButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool loading;
  final VoidCallback onTap;

  const _ImpactButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.loading,
    required this.onTap,
  });

  @override
  State<_ImpactButton> createState() => _ImpactButtonState();
}

class _ImpactButtonState extends State<_ImpactButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween(begin: 1.0, end: 0.95).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _ctrl.forward();
  void _onTapUp(_)   { _ctrl.reverse(); widget.onTap(); }
  void _onTapCancel() => _ctrl.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: widget.loading
                ? widget.color.withOpacity(0.5)
                : widget.color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: widget.color.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 5))
            ],
          ),
          alignment: Alignment.center,
          child: widget.loading
              ? const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.icon, color: Colors.white, size: 17),
                    const SizedBox(width: 8),
                    Text(widget.label,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14)),
                  ],
                ),
        ),
      ),
    );
  }
}

// ── Profile Card ──────────────────────────────────────────────

class _ProfileCard extends StatefulWidget {
  final String name, role, email, initials;
  final VoidCallback onEditTap;

  const _ProfileCard({
    required this.name,
    required this.role,
    required this.email,
    required this.initials,
    required this.onEditTap,
  });

  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween(begin: 1.0, end: 0.97).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); widget.onEditTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF9C95FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFF6C63FF).withOpacity(0.30),
                  blurRadius: 16,
                  offset: const Offset(0, 6))
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 58, height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                ),
                child: Center(
                  child: Text(widget.initials,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 20)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(widget.role.isEmpty ? 'System Administrator' : widget.role,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 2),
                    Text(widget.email,
                        style: const TextStyle(
                            color: Colors.white60, fontSize: 11)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit_outlined,
                    color: Colors.white, size: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reusable helpers ──────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  const _SectionHeader({required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: color, size: 14),
      ),
      const SizedBox(width: 8),
      Text(title,
          style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3)),
    ]);
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEF5)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final String title, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Color(0xFF1A1A2E),
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: const TextStyle(
                      color: Color(0xFF9090A0), fontSize: 11)),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: const Color(0xFF6C63FF),
          inactiveThumbColor: const Color(0xFFBBBBCC),
          inactiveTrackColor: const Color(0xFFEEEEF5),
        ),
      ]),
    );
  }
}

class _DropdownTile extends StatelessWidget {
  final String title, value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const _DropdownTile({
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Color(0xFF1A1A2E),
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              dropdownColor: Colors.white,
              style: const TextStyle(
                  color: Color(0xFF6C63FF),
                  fontSize: 13,
                  fontWeight: FontWeight.w700),
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF6C63FF), size: 18),
              items: options
                  .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatefulWidget {
  final String title, subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;
  final Color? accentColor;

  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.titleColor,
    this.accentColor,
  });

  @override
  State<_ActionTile> createState() => _ActionTileState();
}

class _ActionTileState extends State<_ActionTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 80));
    _scale = Tween(begin: 1.0, end: 0.97).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accentColor ?? const Color(0xFF6C63FF);
    return GestureDetector(
      onTapDown: (_) { _ctrl.forward(); setState(() => _pressed = true); },
      onTapUp: (_) { _ctrl.reverse(); setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: () { _ctrl.reverse(); setState(() => _pressed = false); },
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          decoration: BoxDecoration(
            color: _pressed ? accent.withOpacity(0.05) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(widget.icon, color: widget.iconColor ?? accent, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title,
                        style: TextStyle(
                            color: widget.titleColor ?? const Color(0xFF1A1A2E),
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(widget.subtitle,
                        style: const TextStyle(
                            color: Color(0xFF9090A0), fontSize: 11)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: accent.withOpacity(0.5), size: 18),
            ]),
          ),
        ),
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscure;

  const _SheetField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF9090A0), fontSize: 12),
        prefixIcon: Icon(icon, color: const Color(0xFF9090A0), size: 18),
        filled: true,
        fillColor: const Color(0xFFF7F8FC),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFEEEEF5))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFEEEEF5))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color(0xFF6C63FF), width: 1.5)),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
        color: Color(0xFFEEEEF5), height: 1, indent: 16, endIndent: 16);
  }
}