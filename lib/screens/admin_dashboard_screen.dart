import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../data/database_helper.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int totalCases = 5;
  int emergencies = 1;
  int deaths = 1;

  List<Map<String, Object>> diseaseStats = [
    {'name': 'Foot-and-Mouth Disease (FMD)', 'count': 1},
    {'name': 'Lumpy Skin Disease (LSD)', 'count': 1},
    {'name': 'Black Quarter (BQ)', 'count': 0},
    {'name': 'Anthrax', 'count': 0},
    {'name': 'Haemorrhagic Septicaemia (HS)', 'count': 1},
    {'name': 'Mastitis', 'count': 0},
    {'name': 'Peste des Petits Ruminants (PPR)', 'count': 1},
    {'name': 'Enterotoxaemia (ET)', 'count': 1},
  ];

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final reports = await DatabaseHelper.instance.getAllReports();
      if (reports.isNotEmpty && mounted) {
        setState(() {
          totalCases = reports.length;
          emergencies = reports.where((r) => r.urgency == 'EMERGENCY').length;
          deaths = reports.where((r) => r.status == 'Died').length;

          final counts = <String, int>{};
          for (final r in reports) {
            for (final stat in diseaseStats) {
              final name = stat['name'] as String;
              final shortCode = name.split('(').last.replaceAll(')', '').trim();
              if (r.suspectedDisease.contains(shortCode) ||
                  name.toLowerCase().contains(r.suspectedDisease.toLowerCase())) {
                counts[name] = (counts[name] ?? 0) + 1;
              }
            }
          }

          diseaseStats = diseaseStats.map((d) {
            final name = d['name'] as String;
            return {'name': name, 'count': counts[name] ?? 0};
          }).toList();
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'JeevSarthi • Government admin',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
            ),
            Text(
              'Maharashtra surveillance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Includes surveillance records (Pune, Ahmednagar, Satara, Nashik, Kolhapur) plus newly synced reports.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _buildMetricTile('$totalCases', 'Suspected cases')),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricTile('$emergencies', 'Emergencies', isAlert: true),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildMetricTile('$deaths', 'Deaths reported')),
              const SizedBox(width: 10),
              Expanded(child: _buildMetricTile('23%', 'Vaccination coverage')),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Suspected cases by disease',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: diseaseStats.map((d) {
                  final int count = d['count'] as int;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              d['name'] as String,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '$count',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: count > 0 ? (count / 5.0).clamp(0.0, 1.0) : 0.0,
                            minHeight: 6,
                            backgroundColor: Colors.grey.shade200,
                            color: count > 0
                                ? AppTheme.primaryGreen
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String value, String label, {bool isAlert = false}) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isAlert ? Colors.red : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
