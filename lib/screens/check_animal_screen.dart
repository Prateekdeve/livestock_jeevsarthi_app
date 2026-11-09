import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/animal_model.dart';
import '../data/repositories/animal_repository.dart';
import '../data/repositories/report_repository.dart';
import 'reports_screen.dart';

class CheckAnimalScreen extends StatefulWidget {
  const CheckAnimalScreen({super.key});

  @override
  State<CheckAnimalScreen> createState() => _CheckAnimalScreenState();
}

class _CheckAnimalScreenState extends State<CheckAnimalScreen> {
  final AnimalRepository _animalRepository = OfflineFirstAnimalRepository();
  final ReportRepository _reportRepository = OfflineFirstReportRepository();

  int currentStep = 1; // Step 1 to 15
  final int totalSteps = 15;

  List<Animal> animals = [];
  Animal? selectedAnimal;

  // Answers State
  bool? e1Answer; // Collapsed
  bool? e2Answer; // Bleeding orifices (Anthrax)
  bool? e3Answer; // Throat swelling (HS)
  int? appetiteIndex;
  int? feverIndex;
  int? blistersIndex;
  int? skinNodulesIndex;
  int? breathingIndex;
  int? salivationIndex;
  int? udderIndex;
  int? lamenessIndex;

  @override
  void initState() {
    super.initState();
    _loadAnimals();
  }

  Future<void> _loadAnimals() async {
    final list = await _animalRepository.getAnimals();
    if (mounted) {
      setState(() {
        animals = list;
        if (animals.isNotEmpty && selectedAnimal == null) {
          selectedAnimal = animals.first;
        }
      });
    }
  }

  void _nextStep() {
    if (currentStep < totalSteps) {
      setState(() => currentStep++);
    } else {
      _evaluateAndFinish();
    }
  }

  void _prevStep() {
    if (currentStep > 1) {
      setState(() => currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _evaluateAndFinish() async {
    // Decision rule evaluation
    String urgency = 'MODERATE';
    String disease = 'General Observation';
    List<String> signs = [];
    List<String> nextSteps = [
      'Isolate the animal from the herd immediately.',
      'A veterinarian will review this report.',
      'Do not sell or move animals until advised.',
    ];

    if (e2Answer == true) {
      urgency = 'EMERGENCY';
      disease = 'Suspected Anthrax';
      signs = ['Bleeding from orifices', 'Sudden collapse'];
      nextSteps = [
        'BIOHAZARD: Do NOT touch, cut, skin, or open the carcass.',
        'Keep all humans and scavengers away.',
        'Call 1962 / local veterinary office immediately for deep burial with lime.',
      ];
    } else if (e3Answer == true) {
      urgency = 'EMERGENCY';
      disease = 'Haemorrhagic Septicaemia (HS)';
      signs = ['Fast-worsening throat/neck swelling', 'Severe breathing difficulty'];
      nextSteps = [
        'Requires immediate emergency injectable treatment within hours.',
        'Call 1962 / local dispensary immediately.',
        'Keep animal calm and avoid physical exertion.',
      ];
    } else if (e1Answer == true) {
      urgency = 'EMERGENCY';
      disease = 'Acute Recumbency / Shock';
      signs = ['Unable to stand / Collapsed'];
      nextSteps = ['Immediate veterinary assistance required.', 'Provide soft bedding and shelter.'];
    } else if (blistersIndex == 1 || salivationIndex == 1) {
      urgency = 'MODERATE';
      disease = 'Foot-and-Mouth Disease (FMD)';
      signs = ['Mouth blisters/sores', 'Excessive stringy salivation', 'Hoof lesions'];
    } else if (skinNodulesIndex == 1) {
      urgency = 'HIGH';
      disease = 'Lumpy Skin Disease (LSD)';
      signs = ['Round skin nodules (1-5 cm)', 'Fever', 'Swollen lymph nodes'];
    } else if (udderIndex == 1) {
      urgency = 'MODERATE';
      disease = 'Mastitis';
      signs = ['Swollen/painful udder', 'Abnormal or clotted milk'];
      nextSteps.add('Do NOT supply milk from this animal to dairy collection.');
    }

    final result = TriageResult(
      id: 'rep-${DateTime.now().millisecondsSinceEpoch}',
      animalId: selectedAnimal?.id,
      animalName: selectedAnimal?.name ?? 'Animal',
      species: selectedAnimal?.species ?? 'Bovine',
      urgency: urgency,
      suspectedDisease: disease,
      keySigns: signs.isEmpty ? ['Loss of appetite', 'Dullness'] : signs,
      nextSteps: nextSteps,
      isEmergencyTriggered: urgency == 'EMERGENCY',
      status: 'New',
      location: selectedAnimal?.location ?? 'Maharashtra',
      isSynced: false,
    );

    // Save to offline SQLite database & enqueue for sync
    await _reportRepository.saveReport(result);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ScreeningResultScreen(result: result)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('JeevSarthi • Farmer', style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal)),
            Text('Check animal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Linear Progress Bar
            LinearProgressIndicator(
              value: currentStep / totalSteps,
              backgroundColor: Colors.grey.shade300,
              color: AppTheme.primaryGreen,
              minHeight: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 12, bottom: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Step $currentStep of $totalSteps${currentStep >= 2 && currentStep <= 4 ? " • Emergency check" : ""}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildCurrentStepContent(),
              ),
            ),
            // Bottom Action Navigation Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _prevStep,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Back'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (currentStep == 1 && selectedAnimal == null) ? null : _nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(currentStep == totalSteps ? 'Submit' : 'Next', style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (currentStep) {
      case 1:
        return _buildStep1AnimalSelection();
      case 2:
        return _buildEmergencyCard(
          'E1',
          'Is the animal unable to stand, or has it collapsed?',
          e1Answer,
          (val) => setState(() => e1Answer = val),
        );
      case 3:
        return _buildEmergencyCard(
          'E2',
          'Is there dark/black blood from the nose, mouth, or anus — especially if the animal died suddenly?',
          e2Answer,
          (val) => setState(() => e2Answer = val),
        );
      case 4:
        return _buildEmergencyCard(
          'E3',
          'Is there fast-worsening swelling of the throat/neck along with difficulty breathing?',
          e3Answer,
          (val) => setState(() => e3Answer = val),
        );
      case 5:
        return _buildOptionQuestion(
          questionNum: 1,
          title: 'Appetite & Energy',
          options: ['Normal', 'Eating less, dull or weak', 'Not eating at all'],
          selectedIndex: appetiteIndex,
          onSelect: (idx) => setState(() => appetiteIndex = idx),
        );
      case 6:
        return _buildOptionQuestion(
          questionNum: 2,
          title: 'Body Temperature & Fever',
          options: ['Normal body temperature', 'Mild fever (warm ears/body)', 'High fever (very hot, shivering)'],
          selectedIndex: feverIndex,
          onSelect: (idx) => setState(() => feverIndex = idx),
        );
      case 7:
        return _buildOptionQuestion(
          questionNum: 3,
          title: 'Mouth & Saliva',
          options: ['Normal mouth', 'Excessive drooling / stringy saliva', 'Blisters, ulcers, or smacking lips'],
          selectedIndex: blistersIndex,
          onSelect: (idx) => setState(() => blistersIndex = idx),
        );
      case 8:
        return _buildOptionQuestion(
          questionNum: 4,
          title: 'Skin & Coat Appearance',
          options: ['Smooth, normal skin', 'Visible ticks or flies', 'Firm round nodules/lumps (1-5 cm) on body'],
          selectedIndex: skinNodulesIndex,
          onSelect: (idx) => setState(() => skinNodulesIndex = idx),
        );
      case 9:
        return _buildOptionQuestion(
          questionNum: 5,
          title: 'Breathing Pattern',
          options: ['Normal easy breathing', 'Rapid breathing / slight coughing', 'Severe gasping / mouth open breathing'],
          selectedIndex: breathingIndex,
          onSelect: (idx) => setState(() => breathingIndex = idx),
        );
      case 10:
        return _buildOptionQuestion(
          questionNum: 6,
          title: 'Movement & Leg Swelling',
          options: ['Walks normally', 'Limping or stiffness in legs', 'Hot, painful muscle swelling that crackles'],
          selectedIndex: lamenessIndex,
          onSelect: (idx) => setState(() => lamenessIndex = idx),
        );
      case 11:
        return _buildOptionQuestion(
          questionNum: 7,
          title: 'Udder & Milk (if lactating)',
          options: ['Normal milk & soft udder', 'Mild drop in milk yield', 'Swollen, hard, hot udder / clotted milk'],
          selectedIndex: udderIndex,
          onSelect: (idx) => setState(() => udderIndex = idx),
        );
      default:
        return _buildOptionQuestion(
          questionNum: currentStep - 4,
          title: 'Digestive & Dung Condition',
          options: ['Normal dung', 'Mild soft dung', 'Foul watery diarrhoea with blood'],
          selectedIndex: salivationIndex,
          onSelect: (idx) => setState(() => salivationIndex = idx),
        );
    }
  }

  // Screen 6: Animal Selector
  Widget _buildStep1AnimalSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Text('Which animal is sick?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: animals.length,
            itemBuilder: (context, index) {
              final a = animals[index];
              final isSelected = selectedAnimal?.id == a.id;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? AppTheme.primaryGreen : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  title: Text('${a.name} • ${a.species}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${a.tag} • ${a.location}'),
                  trailing: isSelected ? const Icon(Icons.check_circle, color: AppTheme.primaryGreen) : null,
                  onTap: () => setState(() => selectedAnimal = a),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Screen 7: Emergency Yes/No Card
  Widget _buildEmergencyCard(String code, String question, bool? answer, ValueChanged<bool> onChange) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.red.shade200, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                  const SizedBox(width: 6),
                  Text(code, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                question,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, height: 1.3),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        onChange(true);
                        _nextStep();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: answer == true ? Colors.red.shade700 : Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: const Text('Yes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        onChange(false);
                        _nextStep();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: answer == false ? Colors.green.shade800 : AppTheme.primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: const Text('No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Screen 8: Symptom Multiple-Choice Question Card
  Widget _buildOptionQuestion({
    required int questionNum,
    required String title,
    required List<String> options,
    required int? selectedIndex,
    required ValueChanged<int> onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text('Question $questionNum of 11', style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...List.generate(options.length, (idx) {
          final isSelected = selectedIndex == idx;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? AppTheme.primaryGreen : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: ListTile(
              title: Text(options[idx], style: TextStyle(fontSize: 15, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
              trailing: isSelected ? const Icon(Icons.check_circle, color: AppTheme.primaryGreen) : null,
              onTap: () => onSelect(idx),
            ),
          );
        }),
      ],
    );
  }
}
