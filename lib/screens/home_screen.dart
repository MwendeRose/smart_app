import 'package:flutter/material.dart';
import '../widgets/borehole_system_card.dart';
import '../widgets/water_meter_card.dart';
import '../widgets/stats_row.dart';
import '../widgets/critical_alert_card.dart';
import '../widgets/sub_meters_grid.dart';
import 'analytics.dart';
import 'settings.dart';
import 'alerts_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _DashboardPage(),
    const AnalyticsPage(),
    const _AlertsPlaceholder(),
    const SettingsPage(),
  ];

  void _navigateToAlerts() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AlertsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 1,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.water_drop, color: Colors.black, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Maji Smart',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
                Text(
                  'Borehole Management System',
                  style: TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.yellow),
            onPressed: _navigateToAlerts,
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.yellow),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsRoute()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _pages[_currentIndex]),
          const _Footer(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          if (i == 2) {
            _navigateToAlerts();
          } else {
            setState(() => _currentIndex = i);
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.white54,
        backgroundColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Analytics'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

/* ── Dashboard ── */

class _DashboardPage extends StatelessWidget {
  const _DashboardPage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _GreetingSection(),
          const SizedBox(height: 16),
          const BoreholeSystemCard(),
          const SizedBox(height: 16),
          const WaterMeterCard(),
          const SizedBox(height: 16),
          const StatsRow(),
          const SizedBox(height: 16),
          const CriticalAlertCard(), // tapping "View Details →" navigates to AlertsPage
          const SizedBox(height: 16),
          const SubMetersGrid(),
        ],
      ),
    );
  }
}

/* ── Alerts placeholder (tab always pushes route; list needs 4 entries) ── */

class _AlertsPlaceholder extends StatelessWidget {
  const _AlertsPlaceholder();
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/* ── Greeting ── */

class _GreetingSection extends StatelessWidget {
  const _GreetingSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good Afternoon, John Kamau',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.yellow),
        ),
        Text(
          'Borehole system overview for Ngara Estate',
          style: TextStyle(fontSize: 13, color: Colors.white70),
        ),
      ],
    );
  }
}

/* ── Footer ── */

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      color: Colors.black,
      child: const Center(
        child: Text(
          'Powered by Snapp Africa',
          style: TextStyle(color: Colors.yellow, fontSize: 12),
        ),
      ),
    );
  }
}