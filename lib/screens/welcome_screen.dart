import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import 'admin_dashboard_screen.dart';
import 'farmer_home_screen.dart';
import 'vet_queue_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryGreen,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 36),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.pets, size: 40, color: Colors.black87),
            ),
            const SizedBox(height: 14),
            const Text(
              'JeevSarthi',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Text(
              'Livestock health early warning',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Choose language',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildLangPill('मराठी')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildLangPill('हिन्दी')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildLangPill('English')),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Continue as (demo access)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildRoleCard(
                      context,
                      Icons.agriculture,
                      'Farmer',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FarmerHomeScreen(),
                        ),
                      ),
                    ),
                    _buildRoleCard(
                      context,
                      Icons.medical_services_outlined,
                      'Veterinarian',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VetQueueScreen(),
                        ),
                      ),
                    ),
                    _buildRoleCard(
                      context,
                      Icons.account_balance,
                      'Government admin',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminDashboardScreen(),
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Center(
                      child: Text(
                        'Copyright @c 2026',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLangPill(String text) {
    final isSelected = selectedLanguage == text;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => setState(() => selectedLanguage = text),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? AppTheme.primaryGreen : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback? onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryGreen,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
