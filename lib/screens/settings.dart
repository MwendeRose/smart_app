// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
// SettingsRoute — full Scaffold wrapper used when navigating
// to Settings from the AppBar icon (gives its own back button).
// ─────────────────────────────────────────────────────────────
class SettingsRoute extends StatelessWidget {
  const SettingsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF0D1117),
        foregroundColor: const Color(0xFF2DD4BF),
      ),
      body: const SettingsPage(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SettingsPage — pure content widget, NO Scaffold inside.
// Embedded directly into HomeScreen's body via _pages list.
// ─────────────────────────────────────────────────────────────
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotifications = true;
  bool _emailAlerts = false;
  bool _smsAlerts = true;
  bool _darkMode = true;
  bool _autoRefresh = true;
  String _refreshInterval = '5 min';
  String _language = 'English';
  String _units = 'Litres';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileCard(),

          const SizedBox(height: 24),

          _SectionHeader(title: 'Notifications', icon: Icons.notifications_outlined),
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

          _SectionHeader(title: 'Display & Preferences', icon: Icons.palette_outlined),
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

          _SectionHeader(title: 'Data & Sync', icon: Icons.sync_outlined),
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
              onTap: () => _snack(context, 'Exporting data...'),
            ),
            _Divider(),
            _ActionTile(
              title: 'Clear Cache',
              subtitle: 'Remove locally stored data',
              icon: Icons.delete_outline,
              onTap: () => _confirm(context, 'Clear Cache',
                  'Are you sure you want to clear all cached data?'),
            ),
          ]),

          const SizedBox(height: 20),

          _SectionHeader(title: 'System', icon: Icons.info_outline),
          const SizedBox(height: 10),
          _SettingsCard(children: [
            _ActionTile(
              title: 'Borehole Configuration',
              subtitle: 'Manage borehole and pump settings',
              icon: Icons.settings_input_component_outlined,
              onTap: () => _snack(context, 'Opening borehole config...'),
            ),
            _Divider(),
            _ActionTile(
              title: 'Sub-Meter Management',
              subtitle: 'Add, remove or rename sub-meters',
              icon: Icons.grid_view_outlined,
              onTap: () => _snack(context, 'Opening sub-meter management...'),
            ),
            _Divider(),
            _ActionTile(
              title: 'Alert Thresholds',
              subtitle: 'Set critical water level limits',
              icon: Icons.tune_outlined,
              onTap: () => _snack(context, 'Opening threshold settings...'),
            ),
          ]),

          const SizedBox(height: 20),

          _SectionHeader(title: 'Account', icon: Icons.person_outline),
          const SizedBox(height: 10),
          _SettingsCard(children: [
            _ActionTile(
              title: 'Edit Profile',
              subtitle: 'Update your name and contact info',
              icon: Icons.edit_outlined,
              onTap: () => _snack(context, 'Opening profile editor...'),
            ),
            _Divider(),
            _ActionTile(
              title: 'Change Password',
              subtitle: 'Update your account password',
              icon: Icons.lock_outline,
              onTap: () => _snack(context, 'Opening password change...'),
            ),
            _Divider(),
            _ActionTile(
              title: 'Sign Out',
              subtitle: 'Log out of your account',
              icon: Icons.logout,
              iconColor: Colors.redAccent,
              titleColor: Colors.redAccent,
              onTap: () => _confirm(
                  context, 'Sign Out', 'Are you sure you want to sign out?'),
            ),
          ]),

          const SizedBox(height: 20),

          const Center(
            child: Column(children: [
              Text('Maji Smart v1.0.0',
                  style: TextStyle(color: Color(0xFF484F58), fontSize: 12)),
              SizedBox(height: 2),
              Text('© 2025 Snapp Africa',
                  style: TextStyle(color: Color(0xFF484F58), fontSize: 11)),
            ]),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: const Color(0xFF1C2333),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ));
  }

  void _confirm(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Color(0xFF8B949E))),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel',
                  style: TextStyle(color: Color(0xFF8B949E)))),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Confirm',
                  style: TextStyle(color: Color(0xFF2DD4BF)))),
        ],
      ),
    );
  }
}

/* ── Profile Card ── */

class _ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF2DD4BF).withOpacity(0.15), Colors.transparent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2DD4BF).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF2DD4BF).withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF2DD4BF), width: 2),
            ),
            child: const Icon(Icons.person, color: Color(0xFF2DD4BF), size: 30),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('John Kamau',
                    style: TextStyle(
                        color: Color(0xFFE6EDF3),
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 2),
                Text('System Administrator',
                    style:
                        TextStyle(color: Color(0xFF8B949E), fontSize: 12)),
                SizedBox(height: 2),
                Text('john.kamau@ngaraestate.co.ke',
                    style:
                        TextStyle(color: Color(0xFF2DD4BF), fontSize: 11)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF484F58)),
        ],
      ),
    );
  }
}

/* ── Reusable helpers ── */

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, color: const Color(0xFF2DD4BF), size: 16),
      const SizedBox(width: 6),
      Text(title,
          style: const TextStyle(
              color: Color(0xFF2DD4BF),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5)),
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
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: Column(children: children),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final String title;
  final String subtitle;
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
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style:
                    const TextStyle(color: Color(0xFFE6EDF3), fontSize: 14)),
            const SizedBox(height: 2),
            Text(subtitle,
                style: const TextStyle(
                    color: Color(0xFF8B949E), fontSize: 11)),
          ]),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF2DD4BF),
          activeTrackColor: const Color(0xFF2DD4BF).withOpacity(0.3),
          inactiveThumbColor: const Color(0xFF484F58),
          inactiveTrackColor: const Color(0xFF30363D),
        ),
      ]),
    );
  }
}

class _DropdownTile extends StatelessWidget {
  final String title;
  final String value;
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
              style:
                  const TextStyle(color: Color(0xFFE6EDF3), fontSize: 14)),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              dropdownColor: const Color(0xFF1C2333),
              style:
                  const TextStyle(color: Color(0xFF2DD4BF), fontSize: 13),
              icon: const Icon(Icons.keyboard_arrow_down,
                  color: Color(0xFF2DD4BF), size: 16),
              items: options
                  .map((o) =>
                      DropdownMenuItem(value: o, child: Text(o)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;

  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Icon(icon, color: iconColor ?? const Color(0xFF8B949E), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: titleColor ?? const Color(0xFFE6EDF3),
                          fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          color: Color(0xFF8B949E), fontSize: 11)),
                ]),
          ),
          const Icon(Icons.chevron_right,
              color: Color(0xFF484F58), size: 18),
        ]),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
        color: Color(0xFF30363D), height: 1, indent: 16, endIndent: 16);
  }
}