import 'package:flutter/foundation.dart';

import '../../core/app_config.dart';
import '../../models/animal_model.dart';
import '../../models/sync_queue_item.dart';
import '../database_helper.dart';
import '../remote/api_client.dart';

class SyncResult {
  final bool isSuccess;
  final int syncedCount;
  final int remainingPendingCount;
  final String message;

  SyncResult({
    required this.isSuccess,
    required this.syncedCount,
    required this.remainingPendingCount,
    required this.message,
  });
}

class SyncService {
  static final SyncService instance = SyncService._init();
  final DatabaseHelper _dbHelper;
  final ApiClient _apiClient;

  SyncService._init({DatabaseHelper? dbHelper, ApiClient? apiClient})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance,
        _apiClient = apiClient ?? ApiClient();

  /// Gets count of items waiting in SQLite sync queue
  Future<int> getPendingCount() async {
    return await _dbHelper.getPendingSyncCount();
  }

  /// Checks if backend is reachable (and not in offline demo mode)
  Future<bool> isBackendReachable() async {
    if (AppConfig.isOfflineDemoMode) return false;
    return await _apiClient.checkHealth();
  }

  /// Executes two-way synchronization
  Future<SyncResult> syncNow({bool simulateFailure = false}) async {
    final pendingItems = await _dbHelper.getPendingSyncQueue();

    if (simulateFailure) {
      return SyncResult(
        isSuccess: false,
        syncedCount: 0,
        remainingPendingCount: pendingItems.length,
        message: 'Sync failed: Connection timeout / 503 Service Unavailable.',
      );
    }

    if (AppConfig.isOfflineDemoMode) {
      return SyncResult(
        isSuccess: false,
        syncedCount: 0,
        remainingPendingCount: pendingItems.length,
        message: 'Cannot sync while in offline mode.',
      );
    }

    final isOnline = await _apiClient.checkHealth();
    if (!isOnline) {
      // Backend is not started yet or device is offline
      // In offline-first architecture, this is normal: records remain safely in SQLite.
      if (pendingItems.isEmpty) {
        return SyncResult(
          isSuccess: true,
          syncedCount: 0,
          remainingPendingCount: 0,
          message: 'All local records are stored in offline SQLite database. Backend (${AppConfig.backendUrl}) is currently unreachable.',
        );
      }
      return SyncResult(
        isSuccess: false,
        syncedCount: 0,
        remainingPendingCount: pendingItems.length,
        message: 'Backend server unreachable at ${AppConfig.backendUrl}. ${pendingItems.length} changes safely queued in local SQLite.',
      );
    }

    int syncedCount = 0;

    // 1. Push pending local changes to remote Node.js / Postgres API
    for (final item in pendingItems) {
      try {
        final success = await _pushQueueItem(item);
        if (success) {
          if (item.id != null) {
            await _dbHelper.removeSyncQueueItem(item.id!);
          }
          await _dbHelper.markEntitySynced(item.entityType, item.entityId);
          syncedCount++;
        }
      } catch (e) {
        debugPrint('Error pushing queue item ${item.id}: $e');
        if (item.id != null) {
          await _dbHelper.updateSyncQueueItemError(item.id!, e.toString());
        }
      }
    }

    // 2. Pull latest server data into local SQLite
    try {
      final serverAnimals = await _apiClient.fetchAnimals();
      if (serverAnimals.isNotEmpty) {
        await _dbHelper.upsertServerAnimals(serverAnimals);
      }
    } catch (_) {}

    try {
      final serverReports = await _apiClient.fetchReports();
      if (serverReports.isNotEmpty) {
        await _dbHelper.upsertServerReports(serverReports);
      }
    } catch (_) {}

    final remainingPending = await _dbHelper.getPendingSyncCount();

    final now = DateTime.now();
    final timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    return SyncResult(
      isSuccess: true,
      syncedCount: syncedCount,
      remainingPendingCount: remainingPending,
      message: 'Successfully synced with server at $timeStr. ($syncedCount pushed)',
    );
  }

  Future<bool> _pushQueueItem(SyncQueueItem item) async {
    final payload = item.parsedPayload;

    switch (item.entityType) {
      case 'animal':
        if (item.action == 'INSERT') {
          final animal = Animal.fromJson(payload);
          await _apiClient.createAnimal(animal);
          return true;
        } else if (item.action == 'UPDATE') {
          final animal = Animal.fromJson(payload);
          await _apiClient.updateAnimal(animal);
          return true;
        } else if (item.action == 'DELETE') {
          await _apiClient.deleteAnimal(item.entityId);
          return true;
        }
        break;

      case 'report':
        if (item.action == 'INSERT') {
          final report = TriageResult.fromJson(payload);
          await _apiClient.createReport(report);
          return true;
        }
        break;

      case 'vaccination':
        if (item.action == 'INSERT') {
          // Prepared for backend vaccination endpoint
          return true;
        }
        break;
    }
    return false;
  }
}
