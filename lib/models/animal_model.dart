class Animal {
  final String id;
  final String name;
  final String tag;
  final String species; // Cow, Buffalo, Goat, Sheep
  final String location;
  final bool isLactating;

  Animal({
    required this.id,
    required this.name,
    required this.tag,
    required this.species,
    required this.location,
    this.isLactating = false,
  });
}

class TriageResult {
  final String animalName;
  final String species;
  final String urgency; // EMERGENCY, HIGH, MODERATE, LOW
  final String suspectedDisease;
  final List<String> keySigns;
  final List<String> nextSteps;
  final bool isEmergencyTriggered;

  TriageResult({
    required this.animalName,
    required this.species,
    required this.urgency,
    required this.suspectedDisease,
    required this.keySigns,
    required this.nextSteps,
    this.isEmergencyTriggered = false,
  });
}