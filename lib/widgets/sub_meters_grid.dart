import 'package:flutter/material.dart';

class SubMetersGrid extends StatelessWidget {
  const SubMetersGrid({super.key});

  static const List<Map<String, dynamic>> _units = [
    {
      'name': 'Unit A1',
      'person': 'Mary Wanjiru',
      'flow': '2.3 L/min',
      'today': '286 L',
      'month': '8500 L',
      'monthCost': 'KES 450.00',
      'hasAlert': false,
    },
    {
      'name': 'Unit A2',
      'person': 'Peter Onyango',
      'flow': '0.0 L/min',
      'today': '413 L',
      'month': '12000 L',
      'monthCost': 'KES 650.00',
      'hasAlert': true,
      'alertText': 'Possible leak detected',
    },
    {
      'name': 'Unit B1',
      'person': 'Grace Muthoni',
      'flow': '1.8 L/min',
      'today': '298 L',
      'month': '9200 L',
      'monthCost': 'KES 497.60',
      'hasAlert': false,
    },
    {
      'name': 'Unit B2',
      'person': 'James Githogho',
      'flow': '3.2 L/min',
      'today': '341 L',
      'month': '10100 L',
      'monthCost': 'KES 546.00',
      'hasAlert': false,
    },
    {
      'name': 'Shop 1',
      'person': 'Nairobi Village Store',
      'flow': '4.5 L/min',
      'today': '512 L',
      'month': '14200 L',
      'monthCost': 'KES 768.00',
      'hasAlert': false,
    },
    {
      'name': 'Shop 2',
      'person': 'Barber Shop',
      'flow': '0.7 L/min',
      'today': '98 L',
      'month': '3100 L',
      'monthCost': 'KES 167.40',
      'hasAlert': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Sub-Meters Overview',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1A1A2E))),
            GestureDetector(
              onTap: () {},
              child: const Text('View Analytics →',
                  style: TextStyle(color: Color(0xFF1565C0), fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.3,
          ),
          itemCount: _units.length,
          itemBuilder: (context, index) => _UnitCard(unit: _units[index]),
        ),
      ],
    );
  }
}

class _UnitCard extends StatelessWidget {
  final Map<String, dynamic> unit;

  const _UnitCard({required this.unit});

  @override
  Widget build(BuildContext context) {
    final bool hasAlert = unit['hasAlert'] as bool;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.person, color: Color(0xFF1565C0), size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(unit['name']!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1A1A2E))),
                    Text(unit['person']!,
                        style: const TextStyle(color: Colors.grey, fontSize: 10),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.water_drop, color: Color(0xFF1565C0), size: 12),
              const SizedBox(width: 4),
              Text(unit['flow']!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1565C0))),
            ],
          ),
          const SizedBox(height: 4),
          Text('Today: ${unit['today']}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
          Text('This Month: ${unit['month']}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
          if (hasAlert) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFFFCC02)),
              ),
              child: Text(
                unit['alertText'] ?? '',
                style: const TextStyle(color: Color(0xFFF57C00), fontSize: 9, fontWeight: FontWeight.w600),
              ),
            ),
          ],
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: const Text('View Details →',
                style: TextStyle(color: Color(0xFF1565C0), fontSize: 10, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}