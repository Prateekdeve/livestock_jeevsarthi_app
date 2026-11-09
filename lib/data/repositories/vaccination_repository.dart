import 'package:flutter/foundation.dart';

import '../database_helper.dart';
import '../../models/animal_model.dart';
import '../remote/api_client.dart';

abstract class VaccinationRepository {
  Future<List<VaccineRecord>> getVaccinations();
  Future<List<VaccineRecord>> getVaccinationsForAnimal(String animalId);
  Future<void> saveVaccination(VaccineRecord record);
  Future<void> syncWithRemote();
}

class OfflineFirstVaccinationRepository implements VaccinationRepository {
  final DatabaseHelper _dbHelper;
  final ApiClient _apiClient;

  OfflineFirstVaccinationRepository({
    DatabaseHelper? dbHelper,
    ApiClient? apiClient,
  })  : _dbHelper = dbHelper ?? DatabaseHelper.instance,
        _apiClient = apiClient ?? ApiClient();

  @override
  Future<List<VaccineRecord>> getVaccinations() async {
    return await _dbHelper.getAllVaccinations();
  }

  @override
  Future<List<VaccineRecord>> getVaccinationsForAnimal(String animalId) async {
    return await _dbHelper.getVaccinationsForAnimal(animalId);
  }

  @override
  Future<void> saveVaccination(VaccineRecord record) async {
    final list = await _dbHelper.getAllVaccinations();
    final existing = list.any((v) => v.id == record.id);
    if (!existing) {
      await _dbHelper.insertVaccination(record, queueSync: true);
    } else {
      await _dbHelper.updateVaccination(record, queueSync: true);
    }
  }

  @override
  Future<void> syncWithRemote() async {
    try {
      final isOnline = await _apiClient.checkHealth();
      if (!isOnline) return;
      final serverVaccines = await _apiClient.fetchVaccinations();
      for (final v in serverVaccines) {
        await _dbHelper.insertVaccination(v.copyWith(isSynced: true), queueSync: false);
      }
    } catch (e) {
      debugPrint('Error syncing vaccinations with remote: $e');
    }
  }
}
