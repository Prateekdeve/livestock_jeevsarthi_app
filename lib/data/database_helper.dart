import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../core/app_config.dart';
import '../models/animal_model.dart';
import '../models/sync_queue_item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  static bool _factoryInitialized = false;

  /// Ensures correct SQLite database factory is configured across all Flutter target platforms:
  /// - Mobile (Android/iOS): native sqflite
  /// - Desktop (Windows/macOS/Linux): sqflite_common_ffi
  /// - Web: sqflite_common_ffi_web
  static void ensureFactoryInitialized() {
    if (_factoryInitialized) return;

    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else {
      try {
        if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
          sqfliteFfiInit();
          databaseFactory = databaseFactoryFfi;
        }
      } catch (e) {
        debugPrint('Platform check in ensureFactoryInitialized: $e');
      }
    }
    _factoryInitialized = true;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(AppConfig.dbName);
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    ensureFactoryInitialized();

    String path;
    if (kIsWeb) {
      path = fileName;
    } else {
      final dbPath = await getDatabasesPath();
      path = p.join(dbPath, fileName);
    }

    return await openDatabase(
      path,
      version: AppConfig.dbVersion,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. Animals Table (Matches Postgres schema)
    await db.execute('''
      CREATE TABLE animals (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        tag TEXT NOT NULL UNIQUE,
        species TEXT NOT NULL,
        location TEXT NOT NULL,
        is_lactating INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        is_synced INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // 2. Triage Reports Table (Matches Postgres schema)
    await db.execute('''
      CREATE TABLE reports (
        id TEXT PRIMARY KEY,
        animal_id TEXT,
        animal_name TEXT NOT NULL,
        species TEXT NOT NULL,
        urgency TEXT NOT NULL,
        suspected_disease TEXT NOT NULL,
        key_signs TEXT NOT NULL,
        next_steps TEXT NOT NULL,
        is_emergency_triggered INTEGER NOT NULL DEFAULT 0,
        status TEXT NOT NULL DEFAULT 'Under review',
        location TEXT NOT NULL DEFAULT 'Maharashtra',
        created_at TEXT NOT NULL,
        is_synced INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // 3. Vaccinations Table (Matches Postgres schema)
    await db.execute('''
      CREATE TABLE vaccinations (
        id TEXT PRIMARY KEY,
        animal_id TEXT NOT NULL,
        animal_name TEXT NOT NULL,
        vaccine_name TEXT NOT NULL,
        due_date TEXT NOT NULL,
        is_completed INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        is_synced INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // 4. Sync Queue Table (Local outbox for offline sync to Node.js / Postgres)
    await db.execute('''
      CREATE TABLE sync_queue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        action TEXT NOT NULL,
        entity_type TEXT NOT NULL,
        entity_id TEXT NOT NULL,
        payload TEXT NOT NULL,
        created_at TEXT NOT NULL,
        attempts INTEGER NOT NULL DEFAULT 0,
        last_error TEXT
      )
    ''');

    // Seed default mock records so the app opens with rich, consistent data
    await _seedInitialData(db);
  }

  Future<void> _seedInitialData(Database db) async {
    final now = DateTime.now().toIso8601String();

    // Initial Animals
    final initialAnimals = [
      Animal(
        id: '1',
        name: 'Gauri',
        tag: 'MH-1001',
        species: 'Cow',
        location: 'Malegaon, Baramati, Pune',
        isLactating: true,
        createdAt: now,
        isSynced: true,
      ),
      Animal(
        id: '2',
        name: 'Kalu',
        tag: 'MH-1002',
        species: 'Buffalo',
        location: 'Ghulewadi, Sangamner, Ahmednagar',
        isLactating: true,
        createdAt: now,
        isSynced: true,
      ),
      Animal(
        id: '3',
        name: 'Chhoti',
        tag: 'MH-1003',
        species: 'Goat',
        location: 'Taradgaon, Phaltan, Satara',
        isLactating: false,
        createdAt: now,
        isSynced: true,
      ),
      Animal(
        id: '4',
        name: 'Moti',
        tag: 'MH-1004',
        species: 'Sheep',
        location: 'Wavi, Sinnar, Nashik',
        isLactating: false,
        createdAt: now,
        isSynced: true,
      ),
      Animal(
        id: '5',
        name: 'Shyama',
        tag: 'MH-1005',
        species: 'Cow',
        location: 'Murgud, Kagal, Kolhapur',
        isLactating: false,
        createdAt: now,
        isSynced: true,
      ),
    ];

    for (final a in initialAnimals) {
      await db.insert('animals', a.toMap(forDatabase: true),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // Initial Reports
    final initialReports = [
      TriageResult(
        id: 'rep-1',
        animalId: '1',
        animalName: 'Gauri',
        species: 'Cow',
        urgency: 'MODERATE',
        suspectedDisease: 'Foot-and-Mouth Disease (FMD)',
        keySigns: ['Mouth blisters/sores', 'Excessive stringy salivation', 'Hoof lesions'],
        nextSteps: ['Isolate the animal from the herd immediately.', 'A veterinarian will review this report.'],
        status: 'Under review',
        location: 'Malegaon, Baramati, Pune',
        createdAt: '2026-10-19T10:00:00Z',
        isSynced: true,
      ),
      TriageResult(
        id: 'rep-2',
        animalId: '2',
        animalName: 'Kalu',
        species: 'Buffalo',
        urgency: 'MODERATE',
        suspectedDisease: 'Lumpy Skin Disease (LSD)',
        keySigns: ['Round skin nodules (1-5 cm)', 'Swollen lymph nodes'],
        nextSteps: ['Keep isolated', 'Disinfect shed', 'Veterinarian treated'],
        status: 'Treated',
        location: 'Ghulewadi, Sangamner, Ahmednagar',
        createdAt: '2026-10-16T14:30:00Z',
        isSynced: true,
      ),
      TriageResult(
        id: 'rep-3',
        animalId: '3',
        animalName: 'Chhoti',
        species: 'Goat',
        urgency: 'MODERATE',
        suspectedDisease: 'Peste des Petits Ruminants (PPR)',
        keySigns: ['Loss of appetite', 'High fever', 'Dullness'],
        nextSteps: ['Isolate immediately', 'A veterinarian will review this report.'],
        status: 'New',
        location: 'Taradgaon, Phaltan, Satara',
        createdAt: '2026-10-20T09:15:00Z',
        isSynced: true,
      ),
      TriageResult(
        id: 'rep-4',
        animalId: '5',
        animalName: 'Shyama',
        species: 'Cow',
        urgency: 'EMERGENCY',
        suspectedDisease: 'Haemorrhagic Septicaemia (HS)',
        keySigns: ['Fast-worsening throat/neck swelling', 'Severe breathing difficulty'],
        nextSteps: ['Requires immediate emergency injectable treatment within hours.', 'Call 1962 / local dispensary immediately.'],
        status: 'Escalated',
        isEmergencyTriggered: true,
        location: 'Murgud, Kagal, Kolhapur',
        createdAt: '2026-10-21T08:00:00Z',
        isSynced: true,
      ),
      TriageResult(
        id: 'rep-5',
        animalId: '4',
        animalName: 'Moti',
        species: 'Sheep',
        urgency: 'HIGH',
        suspectedDisease: 'Enterotoxaemia (ET)',
        keySigns: ['Sudden onset depression', 'Incoordination'],
        nextSteps: ['Dispose carcass safely', 'Vaccinate flock'],
        status: 'Died',
        location: 'Wavi, Sinnar, Nashik',
        createdAt: '2026-10-18T16:45:00Z',
        isSynced: true,
      ),
    ];

    for (final r in initialReports) {
      await db.insert('reports', r.toMap(forDatabase: true),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // Initial Vaccinations
    final initialVaccinations = [
      VaccineRecord(
        id: 'v1',
        animalId: '3',
        animalName: 'Chhoti',
        vaccineName: 'Enterotoxaemia (ET)',
        dueDate: '2026-10-25',
        isCompleted: false,
        isSynced: true,
      ),
      VaccineRecord(
        id: 'v2',
        animalId: '4',
        animalName: 'Moti',
        vaccineName: 'Enterotoxaemia (ET)',
        dueDate: '2026-10-25',
        isCompleted: false,
        isSynced: true,
      ),
      VaccineRecord(
        id: 'v3',
        animalId: '1',
        animalName: 'Gauri',
        vaccineName: 'Foot & Mouth (FMD)',
        dueDate: '2026-10-28',
        isCompleted: false,
        isSynced: true,
      ),
      VaccineRecord(
        id: 'v4',
        animalId: '1',
        animalName: 'Gauri',
        vaccineName: 'HS & BQ',
        dueDate: '2026-12-01',
        isCompleted: true,
        isSynced: true,
      ),
      VaccineRecord(
        id: 'v5',
        animalId: '2',
        animalName: 'Kalu',
        vaccineName: 'LSD',
        dueDate: '2027-01-10',
        isCompleted: false,
        isSynced: true,
      ),
      VaccineRecord(
        id: 'v6',
        animalId: '3',
        animalName: 'Chhoti',
        vaccineName: 'PPR',
        dueDate: '2026-11-05',
        isCompleted: false,
        isSynced: true,
      ),
    ];

    for (final v in initialVaccinations) {
      await db.insert('vaccinations', v.toMap(forDatabase: true),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // ==========================================
  // ANIMALS CRUD
  // ==========================================

  Future<List<Animal>> getAllAnimals() async {
    final db = await database;
    final maps = await db.query('animals', orderBy: 'created_at DESC');
    return maps.map((m) => Animal.fromMap(m)).toList();
  }

  Future<Animal?> getAnimalById(String id) async {
    final db = await database;
    final maps = await db.query(
      'animals',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return Animal.fromMap(maps.first);
    }
    return null;
  }

  Future<int> insertAnimal(Animal animal, {bool queueSync = true}) async {
    final db = await database;
    final res = await db.insert(
      'animals',
      animal.toMap(forDatabase: true),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (queueSync && !animal.isSynced) {
      await addToSyncQueue(
        action: 'INSERT',
        entityType: 'animal',
        entityId: animal.id,
        payload: jsonEncode(animal.toJson()),
      );
    }
    return res;
  }

  Future<int> updateAnimal(Animal animal, {bool queueSync = true}) async {
    final db = await database;
    final res = await db.update(
      'animals',
      animal.toMap(forDatabase: true),
      where: 'id = ?',
      whereArgs: [animal.id],
    );

    if (queueSync) {
      await addToSyncQueue(
        action: 'UPDATE',
        entityType: 'animal',
        entityId: animal.id,
        payload: jsonEncode(animal.toJson()),
      );
    }
    return res;
  }

  Future<int> deleteAnimal(String id, {bool queueSync = true}) async {
    final db = await database;
    final res = await db.delete('animals', where: 'id = ?', whereArgs: [id]);
    if (queueSync) {
      await addToSyncQueue(
        action: 'DELETE',
        entityType: 'animal',
        entityId: id,
        payload: jsonEncode({'id': id}),
      );
    }
    return res;
  }

  Future<void> upsertServerAnimals(List<Animal> animals) async {
    final db = await database;
    final batch = db.batch();
    for (final a in animals) {
      final updatedAnimal = a.copyWith(isSynced: true);
      batch.insert(
        'animals',
        updatedAnimal.toMap(forDatabase: true),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  // ==========================================
  // REPORTS CRUD
  // ==========================================

  Future<List<TriageResult>> getAllReports() async {
    final db = await database;
    final maps = await db.query('reports', orderBy: 'created_at DESC');
    return maps.map((m) => TriageResult.fromMap(m)).toList();
  }

  Future<TriageResult?> getReportById(String id) async {
    final db = await database;
    final maps = await db.query(
      'reports',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return TriageResult.fromMap(maps.first);
    }
    return null;
  }

  Future<int> insertReport(TriageResult report, {bool queueSync = true}) async {
    final db = await database;
    final res = await db.insert(
      'reports',
      report.toMap(forDatabase: true),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (queueSync && !report.isSynced) {
      await addToSyncQueue(
        action: 'INSERT',
        entityType: 'report',
        entityId: report.id,
        payload: jsonEncode(report.toJson()),
      );
    }
    return res;
  }

  Future<int> updateReport(TriageResult report, {bool queueSync = true}) async {
    final db = await database;
    final res = await db.update(
      'reports',
      report.toMap(forDatabase: true),
      where: 'id = ?',
      whereArgs: [report.id],
    );

    if (queueSync) {
      await addToSyncQueue(
        action: 'UPDATE',
        entityType: 'report',
        entityId: report.id,
        payload: jsonEncode(report.toJson()),
      );
    }
    return res;
  }

  Future<void> upsertServerReports(List<TriageResult> reports) async {
    final db = await database;
    final batch = db.batch();
    for (final r in reports) {
      final updatedReport = r.copyWith(isSynced: true);
      batch.insert(
        'reports',
        updatedReport.toMap(forDatabase: true),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  // ==========================================
  // VACCINATIONS CRUD
  // ==========================================

  Future<List<VaccineRecord>> getAllVaccinations() async {
    final db = await database;
    final maps = await db.query('vaccinations', orderBy: 'due_date ASC');
    return maps.map((m) => VaccineRecord.fromMap(m)).toList();
  }

  Future<List<VaccineRecord>> getVaccinationsForAnimal(String animalId) async {
    final db = await database;
    final maps = await db.query(
      'vaccinations',
      where: 'animal_id = ?',
      whereArgs: [animalId],
      orderBy: 'due_date ASC',
    );
    return maps.map((m) => VaccineRecord.fromMap(m)).toList();
  }

  Future<int> insertVaccination(VaccineRecord record, {bool queueSync = true}) async {
    final db = await database;
    final res = await db.insert(
      'vaccinations',
      record.toMap(forDatabase: true),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (queueSync && !record.isSynced) {
      await addToSyncQueue(
        action: 'INSERT',
        entityType: 'vaccination',
        entityId: record.id,
        payload: jsonEncode(record.toJson()),
      );
    }
    return res;
  }

  Future<int> updateVaccination(VaccineRecord record, {bool queueSync = true}) async {
    final db = await database;
    final res = await db.update(
      'vaccinations',
      record.toMap(forDatabase: true),
      where: 'id = ?',
      whereArgs: [record.id],
    );

    if (queueSync) {
      await addToSyncQueue(
        action: 'UPDATE',
        entityType: 'vaccination',
        entityId: record.id,
        payload: jsonEncode(record.toJson()),
      );
    }
    return res;
  }

  // ==========================================
  // SYNC QUEUE OPERATIONS
  // ==========================================

  Future<int> addToSyncQueue({
    required String action,
    required String entityType,
    required String entityId,
    required String payload,
  }) async {
    final db = await database;
    return await db.insert('sync_queue', {
      'action': action,
      'entity_type': entityType,
      'entity_id': entityId,
      'payload': payload,
      'created_at': DateTime.now().toIso8601String(),
      'attempts': 0,
      'last_error': null,
    });
  }

  Future<List<SyncQueueItem>> getPendingSyncQueue() async {
    final db = await database;
    final maps = await db.query('sync_queue', orderBy: 'id ASC');
    return maps.map((m) => SyncQueueItem.fromMap(m)).toList();
  }

  Future<int> getPendingSyncCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM sync_queue');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> removeSyncQueueItem(int id) async {
    final db = await database;
    return await db.delete('sync_queue', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateSyncQueueItemError(int id, String error) async {
    final db = await database;
    return await db.rawUpdate('''
      UPDATE sync_queue 
      SET attempts = attempts + 1, last_error = ? 
      WHERE id = ?
    ''', [error, id]);
  }

  Future<void> markEntitySynced(String entityType, String entityId) async {
    final db = await database;
    final tableName = switch (entityType) {
      'animal' => 'animals',
      'report' => 'reports',
      'vaccination' => 'vaccinations',
      _ => null,
    };
    if (tableName != null) {
      await db.update(
        tableName,
        {'is_synced': 1},
        where: 'id = ?',
        whereArgs: [entityId],
      );
    }
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('sync_queue');
    await db.delete('vaccinations');
    await db.delete('reports');
    await db.delete('animals');
    await _seedInitialData(db);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}

