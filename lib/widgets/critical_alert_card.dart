// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

// onViewDetails is called when "View Details →" is tapped.
// HomeScreen passes () => setState(() => _currentIndex = 2)
// so the Alerts tab opens beside the sidebar (no full-screen push).
class CriticalAlertCard extends StatelessWidget {
  final VoidCallback? onViewDetails;
  const CriticalAlertCard({super.key, this.onViewDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1208),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF57C00).withOpacity(0.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF57C00).withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.warning_amber_rounded,
                color: Color(0xFFF57C00), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF57C00).withOpacity(0.18),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('CRITICAL',
                          style: TextStyle(
                            color: Color(0xFFF57C00),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          )),
                    ),
                    const SizedBox(width: 8),
                    const Text('Today, 2:14 AM',
                        style: TextStyle(
                            color: Color(0xFF484F58), fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 6),
                const Text('Continuous Night Flow Detected',
                    style: TextStyle(
                      color: Color(0xFFE6EDF3),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 4),
                const Text(
                  'Continuous water flow detected during night hours. '
                  'Estimated loss: 128 L/day. '
                  'This increases pump runtime and costs by ~KES 45/day.',
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8B949E),
                      height: 1.4),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: onViewDetails,
                  child: const Text(
                    'View Details →',
                    style: TextStyle(
                      color: Color(0xFFF57C00),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}