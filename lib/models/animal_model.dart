import 'dart:convert';

/// Helper to parse booleans from various formats (SQLite int 0/1, Postgres bool, or String)
bool _parseBool(dynamic val, {bool defaultValue = false}) {
  if (val == null) return defaultValue;
  if (val is bool) return val;
  if (val is int) return val == 1;
  if (val is String) {
    final lower = val.toLowerCase().trim();
    return lower == 'true' || lower == '1' || lower == 't';
  }
  return defaultValue;
}

/// Helper to parse string lists from JSON string, List, or comma-separated string
List<String> _parseStringList(dynamic val) {
  if (val == null) return [];
  if (val is List) {
    return val.map((e) => e.toString()).toList();
  }
  if (val is String) {
    final trimmed = val.trim();
    if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is List) {
          return decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {}
    }
    return trimmed
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
  return [];
}

class Animal {
  final String id;
  final String name;
  final String tag;
  final String species; // Cow, Buffalo, Goat, Sheep
  final String location;
  final bool isLactating;
  final String createdAt;
  final String updatedAt;
  final bool isSynced;

  Animal({
    required this.id,
    required this.name,
    required this.tag,
    required this.species,
    required this.location,
    this.isLactating = false,
    String? createdAt,
    String? updatedAt,
    this.isSynced = false,
  })  : createdAt = createdAt ?? DateTime.now().toIso8601String(),
        updatedAt = updatedAt ?? DateTime.now().toIso8601String();

  Animal copyWith({
    String? id,
    String? name,
    String? tag,
    String? species,
    String? location,
    bool? isLactating,
    String? createdAt,
    String? updatedAt,
    bool? isSynced,
  }) {
    return Animal(
      id: id ?? this.id,
      name: name ?? this.name,
      tag: tag ?? this.tag,
      species: species ?? this.species,
      location: location ?? this.location,
      isLactating: isLactating ?? this.isLactating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap({bool forDatabase = true}) {
    return {
      'id': id,
      'name': name,
      'tag': tag,
      'species': species,
      'location': location,
      'is_lactating': forDatabase ? (isLactating ? 1 : 0) : isLactating,
      'created_at': createdAt,
      'updated_at': updatedAt,
      if (forDatabase) 'is_synced': isSynced ? 1 : 0,
    };
  }

  factory Animal.fromMap(Map<String, dynamic> map) {
    return Animal(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      tag: map['tag']?.toString() ?? '',
      species: map['species']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      isLactating: _parseBool(map['is_lactating'] ?? map['isLactating']),
      createdAt: map['created_at']?.toString() ?? map['createdAt'],
      updatedAt: map['updated_at']?.toString() ?? map['updatedAt'],
      isSynced: _parseBool(map['is_synced'] ?? map['isSynced'], defaultValue: false),
    );
  }

  Map<String, dynamic> toJson() => toMap(forDatabase: false);

  factory Animal.fromJson(Map<String, dynamic> json) => Animal.fromMap(json);
}

class TriageResult {
  final String id;
  final String? animalId;
  final String animalName;
  final String species;
  final String urgency; // EMERGENCY, HIGH, MODERATE, LOW
  final String suspectedDisease;
  final List<String> keySigns;
  final List<String> nextSteps;
  final bool isEmergencyTriggered;
  final String status; // 'New', 'Under review', 'Treated', 'Escalated', 'Died'
  final String location;
  final String createdAt;
  final bool isSynced;

  TriageResult({
    String? id,
    this.animalId,
    required this.animalName,
    required this.species,
    required this.urgency,
    required this.suspectedDisease,
    required this.keySigns,
    required this.nextSteps,
    this.isEmergencyTriggered = false,
    this.status = 'Under review',
    this.location = 'Maharashtra',
    String? createdAt,
    this.isSynced = false,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now().toIso8601String();

  TriageResult copyWith({
    String? id,
    String? animalId,
    String? animalName,
    String? species,
    String? urgency,
    String? suspectedDisease,
    List<String>? keySigns,
    List<String>? nextSteps,
    bool? isEmergencyTriggered,
    String? status,
    String? location,
    String? createdAt,
    bool? isSynced,
  }) {
    return TriageResult(
      id: id ?? this.id,
      animalId: animalId ?? this.animalId,
      animalName: animalName ?? this.animalName,
      species: species ?? this.species,
      urgency: urgency ?? this.urgency,
      suspectedDisease: suspectedDisease ?? this.suspectedDisease,
      keySigns: keySigns ?? this.keySigns,
      nextSteps: nextSteps ?? this.nextSteps,
      isEmergencyTriggered: isEmergencyTriggered ?? this.isEmergencyTriggered,
      status: status ?? this.status,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap({bool forDatabase = true}) {
    return {
      'id': id,
      'animal_id': animalId,
      'animal_name': animalName,
      'species': species,
      'urgency': urgency,
      'suspected_disease': suspectedDisease,
      'key_signs': forDatabase ? jsonEncode(keySigns) : keySigns,
      'next_steps': forDatabase ? jsonEncode(nextSteps) : nextSteps,
      'is_emergency_triggered': forDatabase
          ? (isEmergencyTriggered ? 1 : 0)
          : isEmergencyTriggered,
      'status': status,
      'location': location,
      'created_at': createdAt,
      if (forDatabase) 'is_synced': isSynced ? 1 : 0,
    };
  }

  factory TriageResult.fromMap(Map<String, dynamic> map) {
    return TriageResult(
      id: map['id']?.toString(),
      animalId: map['animal_id']?.toString() ?? map['animalId']?.toString(),
      animalName: (map['animal_name'] ?? map['animalName'] ?? '').toString(),
      species: (map['species'] ?? '').toString(),
      urgency: (map['urgency'] ?? 'MODERATE').toString(),
      suspectedDisease: (map['suspected_disease'] ?? map['suspectedDisease'] ?? map['disease'] ?? '').toString(),
      keySigns: _parseStringList(map['key_signs'] ?? map['keySigns']),
      nextSteps: _parseStringList(map['next_steps'] ?? map['nextSteps']),
      isEmergencyTriggered: _parseBool(map['is_emergency_triggered'] ?? map['isEmergencyTriggered']),
      status: (map['status'] ?? 'Under review').toString(),
      location: (map['location'] ?? 'Maharashtra').toString(),
      createdAt: map['created_at']?.toString() ?? map['createdAt']?.toString(),
      isSynced: _parseBool(map['is_synced'] ?? map['isSynced'], defaultValue: false),
    );
  }

  Map<String, dynamic> toJson() => toMap(forDatabase: false);

  factory TriageResult.fromJson(Map<String, dynamic> json) => TriageResult.fromMap(json);
}

class VaccineRecord {
  final String id;
  final String animalId;
  final String animalName;
  final String vaccineName;
  final String dueDate;
  final bool isCompleted;
  final String createdAt;
  final bool isSynced;

  VaccineRecord({
    required this.id,
    required this.animalId,
    required this.animalName,
    required this.vaccineName,
    required this.dueDate,
    this.isCompleted = false,
    String? createdAt,
    this.isSynced = false,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  VaccineRecord copyWith({
    String? id,
    String? animalId,
    String? animalName,
    String? vaccineName,
    String? dueDate,
    bool? isCompleted,
    String? createdAt,
    bool? isSynced,
  }) {
    return VaccineRecord(
      id: id ?? this.id,
      animalId: animalId ?? this.animalId,
      animalName: animalName ?? this.animalName,
      vaccineName: vaccineName ?? this.vaccineName,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap({bool forDatabase = true}) {
    return {
      'id': id,
      'animal_id': animalId,
      'animal_name': animalName,
      'vaccine_name': vaccineName,
      'due_date': dueDate,
      'is_completed': forDatabase ? (isCompleted ? 1 : 0) : isCompleted,
      'created_at': createdAt,
      if (forDatabase) 'is_synced': isSynced ? 1 : 0,
    };
  }

  factory VaccineRecord.fromMap(Map<String, dynamic> map) {
    return VaccineRecord(
      id: map['id']?.toString() ?? '',
      animalId: (map['animal_id'] ?? map['animalId'] ?? '').toString(),
      animalName: (map['animal_name'] ?? map['animalName'] ?? '').toString(),
      vaccineName: (map['vaccine_name'] ?? map['vaccineName'] ?? '').toString(),
      dueDate: (map['due_date'] ?? map['dueDate'] ?? '').toString(),
      isCompleted: _parseBool(map['is_completed'] ?? map['isCompleted']),
      createdAt: map['created_at']?.toString() ?? map['createdAt']?.toString(),
      isSynced: _parseBool(map['is_synced'] ?? map['isSynced'], defaultValue: false),
    );
  }

  Map<String, dynamic> toJson() => toMap(forDatabase: false);

  factory VaccineRecord.fromJson(Map<String, dynamic> json) => VaccineRecord.fromMap(json);
}
