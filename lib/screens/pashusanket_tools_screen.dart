import 'package:flutter/material.dart';

import '../core/app_theme.dart';

class MedicineMonitoringScreen extends StatelessWidget {
  const MedicineMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _ToolScaffold(
      title: 'Medicine Monitoring',
      subtitle: 'Pashusanket • Safety',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _SafetyNotice(
            text: 'Do not supply milk or meat from an animal until its antibiotic withdrawal period is cleared.',
          ),
          SizedBox(height: 18),
          Text(
            'Active treatments',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _TreatmentCard(
            animal: 'MH-1001 (Gauri) • Oxytetracycline LA',
            details: '10 ml • 2 times/day • 5 days • Withdrawal: 7 days',
            clearance: '5 days remaining before clearance (Clears 2026-10-31)',
          ),
          _TreatmentCard(
            animal: 'MH-1002 (Kalu) • Enrofloxacin 10%',
            details: '8 ml • 1 time/day • 3 days • Withdrawal: 5 days',
            clearance: '1 day remaining before clearance (Clears 2026-10-27)',
          ),
          _TreatmentCard(
            animal: 'MH-1003 (Chhoti) • Meloxicam Injection',
            details: '2 ml • 1 time/day • 2 days • Withdrawal: 4 days',
            clearance: '2 days remaining before clearance (Clears 2026-10-28)',
          ),
          SizedBox(height: 14),
          Text(
            'Common Veterinary Medicines Reference',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _ReferenceCard(
                  'Oxytetracycline LA',
                  '10 ml • 7 day withdrawal',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _ReferenceCard(
                  'Enrofloxacin 10%',
                  '8 ml • 5 day withdrawal',
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _ReferenceCard(
                  'Meloxicam Injection',
                  '5 ml • 4 day withdrawal',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _ReferenceCard(
                  'Sulphadimidine Bolus',
                  '1 bolus • 10 day withdrawal',
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}

class ConsultVetScreen extends StatelessWidget {
  const ConsultVetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _ToolScaffold(
      title: 'Consult a Veterinarian',
      subtitle: 'Pashusanket • Help',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Nearby veterinarians',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const _VetCard(
            name: 'Dr. A. Sharma',
            role: 'Veterinary Officer • 3.2 km',
            location: 'Nandgaon Peth / Baramati Dispensary',
            status: 'AVAILABLE',
          ),
          const _VetCard(
            name: 'Dr. S. Kulkarni',
            role: 'Livestock Development Officer • 6.8 km',
            location: 'Bhatkuli Veterinary Hospital',
            status: 'AVAILABLE',
          ),
          const _VetCard(
            name: 'Dr. P. Deshmukh',
            role: 'Senior Veterinarian • 11.4 km',
            location: 'District Veterinary Polyclinic',
            status: 'ON VISIT',
          ),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Request a farm visit',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  const Text('Preferred date', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 5),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: '27 Oct 2026',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.calendar_today_outlined, size: 16),
                      label: const Text('REQUEST VISIT'),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.phone_in_talk_outlined, size: 18),
                      label: const Text('CALL 1962 HELPLINE'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class PashuSwasthyaCardScreen extends StatelessWidget {
  const PashuSwasthyaCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _ToolScaffold(
      title: 'Pashu Swasthya Card',
      subtitle: 'Pashusanket • Animal health record',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            margin: EdgeInsets.zero,
            color: AppTheme.primaryGreen,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.pets, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'PASHU SWASTHYA CARD',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 22),
                  Text(
                    'Gauri',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Cow • Tag MH-1001',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _InfoSection(
            title: 'Animal details',
            rows: [
              'Species: Cow',
              'Age: 5 years',
              'Owner: Farmer account',
              'Status: Under review',
            ],
          ),
          const _InfoSection(
            title: 'Latest health records',
            rows: [
              'Vaccination: Foot & Mouth (FMD)',
              'Last check-up: 19 Oct 2026',
              'Next reminder: 28 Oct 2026',
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: null,
            icon: Icon(Icons.download_outlined),
            label: Text('DOWNLOAD HEALTH CARD'),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _ToolScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _ToolScaffold({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle, style: const TextStyle(fontSize: 11)),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}

class _SafetyNotice extends StatelessWidget {
  final String text;

  const _SafetyNotice({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        border: Border.all(color: Colors.orange.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_outlined, color: Colors.deepOrange),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}

class _TreatmentCard extends StatelessWidget {
  final String animal;
  final String details;
  final String clearance;

  const _TreatmentCard({
    required this.animal,
    required this.details,
    required this.clearance,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.medication_outlined,
                  color: AppTheme.primaryGreen,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    animal,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                _statusBadge(
                  'ACTIVE\nWITHDRAWAL',
                  Colors.pink.shade50,
                  Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              details,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                clearance,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReferenceCard extends StatelessWidget {
  final String name;
  final String details;

  const _ReferenceCard(this.name, this.details);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              details,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _VetCard extends StatelessWidget {
  final String name;
  final String role;
  final String location;
  final String status;

  const _VetCard({
    required this.name,
    required this.role,
    required this.location,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE9FAF2),
          child: Icon(
            Icons.medical_services_outlined,
            color: AppTheme.primaryGreen,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          '$role\n📍 $location',
          style: const TextStyle(fontSize: 11),
        ),
        trailing: _statusBadge(
          status,
          status == 'AVAILABLE' ? Colors.green.shade50 : Colors.grey.shade200,
          status == 'AVAILABLE' ? AppTheme.primaryGreen : Colors.grey.shade700,
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<String> rows;

  const _InfoSection({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...rows.map(
              (row) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text(row, style: const TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _statusBadge(String text, Color background, Color foreground) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 9,
        color: foreground,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
