import 'package:flutter/foundation.dart';

import '../database_helper.dart';
import '../../models/animal_model.dart';
import '../remote/api_client.dart';

abstract class AnimalRepository {
  Future<List<Animal>> getAnimals();
  Future<Animal?> getAnimalById(String id);
  Future<void> saveAnimal(Animal animal);
  Future<void> deleteAnimal(String id);
  Future<void> syncWithRemote();
}

class OfflineFirstAnimalRepository implements AnimalRepository {
  final DatabaseHelper _dbHelper;
  final ApiClient _apiClient;

  OfflineFirstAnimalRepository({
    DatabaseHelper? dbHelper,
    ApiClient? apiClient,
  })  : _dbHelper = dbHelper ?? DatabaseHelper.instance,
        _apiClient = apiClient ?? ApiClient();

  @override
  Future<List<Animal>> getAnimals() async {
    return await _dbHelper.getAllAnimals();
  }

  @override
  Future<Animal?> getAnimalById(String id) async {
    return await _dbHelper.getAnimalById(id);
  }

  @override
  Future<void> saveAnimal(Animal animal) async {
    final existing = await _dbHelper.getAnimalById(animal.id);
    if (existing == null) {
      await _dbHelper.insertAnimal(animal, queueSync: true);
    } else {
      await _dbHelper.updateAnimal(animal, queueSync: true);
    }
  }

  @override
  Future<void> deleteAnimal(String id) async {
    await _dbHelper.deleteAnimal(id, queueSync: true);
  }

  @override
  Future<void> syncWithRemote() async {
    try {
      final isOnline = await _apiClient.checkHealth();
      if (!isOnline) {
        debugPrint('Backend is offline. Skipping remote animals sync.');
        return;
      }
      final serverAnimals = await _apiClient.fetchAnimals();
      if (serverAnimals.isNotEmpty) {
        await _dbHelper.upsertServerAnimals(serverAnimals);
      }
    } catch (e) {
      debugPrint('Error syncing animals with remote: $e');
    }
  }
}
