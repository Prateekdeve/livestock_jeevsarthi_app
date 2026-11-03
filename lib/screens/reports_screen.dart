import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/animal_model.dart';
import 'farmer_home_screen.dart';

class ScreeningResultScreen extends StatelessWidget {
  final TriageResult result;

  const ScreeningResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    Color badgeColor = Colors.orange.shade100;
    Color textColor = Colors.orange.shade900;
    if (result.urgency == 'EMERGENCY') {
      badgeColor = Colors.red.shade100;
      textColor = Colors.red.shade900;
    } else if (result.urgency == 'HIGH') {
      badgeColor = Colors.pink.shade100;
      textColor = Colors.pink.shade900;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('JeevSarthi • Farmer', style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal)),
            Text('Screening result', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Animal Header Card
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${result.animalName} • ${result.species}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(4)),
                              child: Text(
                                result.urgency,
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('Status: Under review', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Text('Mock data', style: TextStyle(fontSize: 11, color: Colors.green)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Possible Concerns Card
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Possible concerns', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.suspectedDisease,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Signs: ${result.keySigns.join(", ")}',
                          style: const TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Next steps', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ...result.nextSteps.map((step) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                            Expanded(child: Text(step, style: const TextStyle(fontSize: 13, height: 1.3))),
                          ],
                        ),
                      )),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Screening result, not a diagnosis. Model: demo-rules-0.1 — demo inference mode using transparent rules; no confidence scores are claimed.',
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const FarmerHomeScreen()),
                  (route) => false,
                );
              },
              child: const Text('All reports →', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
            ),
          ),
        ],
      ),
    );
  }
}