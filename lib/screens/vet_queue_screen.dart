import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import 'sync_screen.dart';

class VetQueueScreen extends StatelessWidget {
  const VetQueueScreen({super.key});

  static const List<Map<String, String>> cases = [
    {
      'title': 'Shyama • Cow',
      'loc': 'Murgud, Kagal, Kolhapur • Escalated',
      'disease': 'HS',
      'urgency': 'EMERGENCY',
    },
    {
      'title': 'Moti • Sheep',
      'loc': 'Wavi, Sinnar, Nashik • Died',
      'disease': 'ET',
      'urgency': 'HIGH',
    },
    {
      'title': 'Chhoti • Goat',
      'loc': 'Taradgaon, Phaltan, Satara • New',
      'disease': 'PPR',
      'urgency': 'MODERATE',
    },
    {
      'title': 'Gauri • Cow',
      'loc': 'Malegaon, Baramati, Pune • Under review',
      'disease': 'FMD',
      'urgency': 'MODERATE',
    },
    {
      'title': 'Kalu • Buffalo',
      'loc': 'Ghulewadi, Sangamner, Ahmednagar • Treated',
      'disease': 'LSD',
      'urgency': 'MODERATE',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'JeevSarthi • Veterinarian',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
            ),
            Text(
              'Case queue',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...cases.map((c) {
            final isEmergency = c['urgency'] == 'EMERGENCY';
            final isHigh = c['urgency'] == 'HIGH';
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                title: Text(
                  c['title']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c['loc']!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      c['disease']!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isEmergency
                        ? Colors.red
                        : (isHigh
                              ? Colors.pink.shade100
                              : Colors.orange.shade100),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    c['urgency']!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isEmergency
                          ? Colors.white
                          : (isHigh
                                ? Colors.pink.shade900
                                : Colors.orange.shade900),
                    ),
                  ),
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening case details for ${c['title']}'),
                    ),
                  );
                },
              ),
            );
          }),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'Only server-confirmed (synced) reports appear here.',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: AppTheme.primaryGreen,
        onTap: (idx) {
          if (idx == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => const SyncScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Cases'),
          BottomNavigationBarItem(icon: Icon(Icons.sync), label: 'Sync'),
        ],
      ),
    );
  }
}
