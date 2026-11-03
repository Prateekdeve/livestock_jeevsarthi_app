import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/animal_model.dart';

class AnimalsScreen extends StatefulWidget {
  const AnimalsScreen({super.key});

  @override
  State<AnimalsScreen> createState() => _AnimalsScreenState();
}

class _AnimalsScreenState extends State<AnimalsScreen> {
  final List<Animal> animalsList = [
    Animal(id: '1', name: 'Gauri', tag: 'MH-1001', species: 'Cow', location: 'Malegaon, Baramati, Pune', isLactating: true),
    Animal(id: '2', name: 'Kalu', tag: 'MH-1002', species: 'Buffalo', location: 'Ghulewadi, Sangamner, Ahmednagar', isLactating: true),
    Animal(id: '3', name: 'Chhoti', tag: 'MH-1003', species: 'Goat', location: 'Taradgaon, Phaltan, Satara', isLactating: false),
    Animal(id: '4', name: 'Moti', tag: 'MH-1004', species: 'Sheep', location: 'Wavi, Sinnar, Nashik', isLactating: false),
  ];

  void _showAddAnimalDialog() {
    final nameCtrl = TextEditingController();
    final tagCtrl = TextEditingController();
    final locCtrl = TextEditingController();
    String selectedSpecies = 'Cow';
    bool isLactating = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Register Animal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Animal Name (e.g. Shyama)', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(controller: tagCtrl, decoration: const InputDecoration(labelText: 'Tag / ID (e.g. MH-1005)', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedSpecies,
                decoration: const InputDecoration(labelText: 'Species', border: OutlineInputBorder()),
                items: ['Cow', 'Buffalo', 'Goat', 'Sheep'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (val) => setModalState(() => selectedSpecies = val!),
              ),
              const SizedBox(height: 10),
              TextField(controller: locCtrl, decoration: const InputDecoration(labelText: 'Village, Taluka, District', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Is Lactating (Milking)?'),
                value: isLactating,
                onChanged: (val) => setModalState(() => isLactating = val ?? false),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.isNotEmpty && tagCtrl.text.isNotEmpty) {
                    setState(() {
                      animalsList.add(Animal(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: nameCtrl.text.trim(),
                        tag: tagCtrl.text.trim(),
                        species: selectedSpecies,
                        location: locCtrl.text.trim().isEmpty ? 'Maharashtra' : locCtrl.text.trim(),
                        isLactating: isLactating,
                      ));
                    });
                    Navigator.pop(ctx);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryGreen, padding: const EdgeInsets.symmetric(vertical: 14)),
                child: const Text('Save Animal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('JeevSarthi • Farmer', style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal)),
            Text('My animals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: const Row(
              children: [
                Icon(Icons.wifi, color: AppTheme.primaryGreen, size: 14),
                SizedBox(width: 4),
                Text('Online', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton.icon(
            onPressed: _showAddAnimalDialog,
            icon: const Icon(Icons.add, size: 20),
            label: const Text('Register animal', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 16),
          ...animalsList.map((a) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${a.name} ${a.tag}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const Text('Mock data', style: TextStyle(fontSize: 11, color: Colors.green)),
                        ],
                      ),
                      Text('${a.species}${a.isLactating ? " • lactating" : ""} • ${a.location}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _buildVaccineChip('FMD • 2026-10-28', false),
                          _buildVaccineChip('HS & BQ • 2026-12-01', true),
                          if (a.species == 'Cow' || a.species == 'Buffalo') _buildVaccineChip('LSD • 2027-01-10', false),
                          if (a.species == 'Goat' || a.species == 'Sheep') _buildVaccineChip('PPR • 2026-11-05', false),
                        ],
                      )
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildVaccineChip(String label, bool isCompleted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isCompleted ? const Color(0xFFE8F5E9) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isCompleted ? AppTheme.primaryGreen : Colors.grey.shade300),
      ),
      child: Text(
        '${isCompleted ? "✔ " : "○ "}$label',
        style: TextStyle(fontSize: 11, color: isCompleted ? AppTheme.primaryGreen : Colors.black87),
      ),
    );
  }
}