import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import 'animals_screen.dart';
import 'check_animal_screen.dart';
import 'reports_screen.dart';
import 'sync_screen.dart';

class FarmerHomeScreen extends StatefulWidget {
  const FarmerHomeScreen({super.key});

  @override
  State<FarmerHomeScreen> createState() => _FarmerHomeScreenState();
}

class _FarmerHomeScreenState extends State<FarmerHomeScreen> {
  int currentIndex = 0;

  void _openTab(int index) {
    if (index == 0) {
      setState(() => currentIndex = 0);
      return;
    }

    final screen = switch (index) {
      1 => const AnimalsScreen(),
      2 => const CheckAnimalScreen(),
      3 => const ReportsScreen(),
      4 => const SyncScreen(),
      _ => null,
    };

    if (screen != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'JeevSarthi • Farmer',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
            ),
            Text(
              'Namaskar 🙏',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.wifi, color: AppTheme.primaryGreen, size: 14),
                SizedBox(width: 4),
                Text(
                  'Online',
                  style: TextStyle(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
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
            onPressed: () => _openTab(2),
            icon: const Icon(Icons.health_and_safety_outlined, size: 26),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Check a sick animal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Answer a few simple questions',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _openTab(1),
                  child: _buildMetricCard(Icons.pets, '5', 'Animals'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _openTab(3),
                  child: _buildMetricCard(
                    Icons.notifications_none,
                    '5',
                    'Open cases',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Recent alerts',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildAlertCard(
            context,
            'Gauri • Cow',
            'Under review • 10/19/2026',
            'MODERATE',
            const Color(0xFFFFF3E0),
          ),
          _buildAlertCard(
            context,
            'Kalu • Buffalo',
            'Treated • 10/16/2026',
            'MODERATE',
            const Color(0xFFFFF3E0),
          ),
          _buildAlertCard(
            context,
            'Chhoti • Goat',
            'New • 10/20/2026',
            'MODERATE',
            const Color(0xFFFFF3E0),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(
                Icons.vaccines_outlined,
                color: AppTheme.primaryGreen,
                size: 18,
              ),
              SizedBox(width: 6),
              Text(
                'Vaccination reminders',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildVaccinationReminders(),
          const SizedBox(height: 14),
          const Text(
            'Pashusanket Quick Tools',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildQuickTools(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _askPashusanket,
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.auto_awesome, size: 18),
        label: const Text(
          'Ask Pashusanket',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryGreen,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        onTap: _openTab,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Animals'),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_outlined),
            label: 'Check animal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Reports',
          ),
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
            Text(
              count,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(
    BuildContext context,
    String title,
    String subtitle,
    String badgeText,
    Color badgeColor,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () => _openTab(3),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            badgeText,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVaccinationReminders() {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildReminderRow(
            'Enterotoxaemia (ET) — Chhoti',
            '2026-10-25',
            isDueSoon: false,
          ),
          _buildReminderRow(
            'Enterotoxaemia (ET) — Moti',
            '2026-10-25',
            isDueSoon: false,
          ),
          _buildReminderRow(
            'Foot & Mouth (FMD) — Gauri',
            'Due in 2 days (Oct 28)',
            isDueSoon: true,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildReminderRow(
    String title,
    String date, {
    required bool isDueSoon,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppTheme.cardBorder)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 12))),
          const SizedBox(width: 8),
          Text(
            date,
            style: TextStyle(
              color: isDueSoon ? AppTheme.warningOrange : AppTheme.primaryGreen,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTools() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickTool(
            Icons.medication_outlined,
            'Medicine &\nWithdrawal',
            _showToolMessage,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildQuickTool(
            Icons.phone_in_talk_outlined,
            'Consult Nearby\nVet',
            _showToolMessage,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildQuickTool(
            Icons.qr_code_2,
            'Pashu Swasthya\nCard',
            _showToolMessage,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickTool(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9FAF2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppTheme.primaryGreen, size: 22),
              ),
              const SizedBox(height: 7),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showToolMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('This Pashusanket tool is coming soon.')),
    );
  }

  void _askPashusanket() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pashusanket assistant is coming soon.')),
    );
  }
}
