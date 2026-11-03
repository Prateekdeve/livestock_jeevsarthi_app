import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class FarmerHomeScreen extends StatelessWidget {
  const FarmerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('JeevSarthi • Farmer', style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal)),
            Text('Namaskar 🙏', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: const Row(
              children: [
                Icon(Icons.wifi, color: AppTheme.primaryGreen, size: 14),
                SizedBox(width: 4),
                Text('Online', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.health_and_safety_outlined, size: 26),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Check a sick animal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Answer a few simple questions', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
                ],
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              alignment: Alignment.centerLeft,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildMetricCard(Icons.pets, '5', 'Animals')),
              const SizedBox(width: 12),
              Expanded(child: _buildMetricCard(Icons.notifications_none, '5', 'Open cases')),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Recent alerts', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildAlertCard('Gauri • Cow', 'Under review • 10/19/2026', 'MODERATE', const Color(0xFFFFF3E0)),
          _buildAlertCard('Kalu • Buffalo', 'Treated • 10/16/2026', 'MODERATE', const Color(0xFFFFF3E0)),
          _buildAlertCard('Chhoti • Goat', 'New • 10/20/2026', 'MODERATE', const Color(0xFFFFF3E0)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryGreen,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Animals'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services_outlined), label: 'Check animal'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.sync), label: 'Sync'),
        ],
      ),
    );
  }

  Widget _buildMetricCard(IconData icon, String count, String label) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppTheme.primaryGreen, size: 22),
            const SizedBox(height: 6),
            Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(String title, String subtitle, String badgeText, Color badgeColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(6)),
          child: Text(
            badgeText,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange),
          ),
        ),
      ),
    );
  }
}