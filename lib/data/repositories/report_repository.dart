import 'package:flutter/foundation.dart';

import '../database_helper.dart';
import '../../models/animal_model.dart';
import '../remote/api_client.dart';

abstract class ReportRepository {
  Future<List<TriageResult>> getReports();
  Future<TriageResult?> getReportById(String id);
  Future<void> saveReport(TriageResult report);
  Future<void> syncWithRemote();
}

class OfflineFirstReportRepository implements ReportRepository {
  final DatabaseHelper _dbHelper;
  final ApiClient _apiClient;

  OfflineFirstReportRepository({
    DatabaseHelper? dbHelper,
    ApiClient? apiClient,
  })  : _dbHelper = dbHelper ?? DatabaseHelper.instance,
        _apiClient = apiClient ?? ApiClient();

  @override
  Future<List<TriageResult>> getReports() async {
    return await _dbHelper.getAllReports();
  }

  @override
  Future<TriageResult?> getReportById(String id) async {
    return await _dbHelper.getReportById(id);
  }

  @override
  Future<void> saveReport(TriageResult report) async {
    final existing = await _dbHelper.getReportById(report.id);
    if (existing == null) {
      await _dbHelper.insertReport(report, queueSync: true);
    } else {
      await _dbHelper.updateReport(report, queueSync: true);
    }
  }

  @override
  Future<void> syncWithRemote() async {
    try {
      final isOnline = await _apiClient.checkHealth();
      if (!isOnline) {
        debugPrint('Backend is offline. Skipping remote reports sync.');
        return;
      }
      final serverReports = await _apiClient.fetchReports();
      if (serverReports.isNotEmpty) {
        await _dbHelper.upsertServerReports(serverReports);
      }
    } catch (e) {
      debugPrint('Error syncing reports with remote: $e');
    }
  }
}
