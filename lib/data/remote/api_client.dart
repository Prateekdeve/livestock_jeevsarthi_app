import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/app_config.dart';
import '../../models/animal_model.dart';
import '../../models/sync_queue_item.dart';

class ApiClient {
  final http.Client _client;
  static const Duration defaultTimeout = Duration(seconds: 4);

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  String get _baseUrl => AppConfig.backendUrl.replaceAll(RegExp(r'/+$'), '');

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Health check to see if friend's Node.js / PostgreSQL backend is running
  Future<bool> checkHealth() async {
    try {
      final response = await _client
          .get(Uri.parse('$_baseUrl/api/health'))
          .timeout(defaultTimeout);
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  // ==========================================
  // ANIMALS ENDPOINTS
  // ==========================================

  Future<List<Animal>> fetchAnimals() async {
    final response = await _client
        .get(Uri.parse('$_baseUrl/api/animals'), headers: _headers)
        .timeout(defaultTimeout);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final list = (decoded is List)
          ? decoded
          : (decoded['data'] as List? ?? []);
      return list.map((item) => Animal.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to fetch animals: ${response.statusCode}');
    }
  }

  Future<Animal> createAnimal(Animal animal) async {
    final response = await _client
        .post(
          Uri.parse('$_baseUrl/api/animals'),
          headers: _headers,
          body: jsonEncode(animal.toJson()),
        )
        .timeout(defaultTimeout);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      final data = (decoded is Map<String, dynamic> && decoded.containsKey('data'))
          ? decoded['data']
          : decoded;
      return Animal.fromJson(data as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create animal: ${response.statusCode}');
    }
  }

  Future<Animal> updateAnimal(Animal animal) async {
    final response = await _client
        .put(
          Uri.parse('$_baseUrl/api/animals/${animal.id}'),
          headers: _headers,
          body: jsonEncode(animal.toJson()),
        )
        .timeout(defaultTimeout);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final data = (decoded is Map<String, dynamic> && decoded.containsKey('data'))
          ? decoded['data']
          : decoded;
      return Animal.fromJson(data as Map<String, dynamic>);
    } else {
      throw Exception('Failed to update animal: ${response.statusCode}');
    }
  }

  Future<bool> deleteAnimal(String id) async {
    final response = await _client
        .delete(Uri.parse('$_baseUrl/api/animals/$id'), headers: _headers)
        .timeout(defaultTimeout);
    return response.statusCode == 200 || response.statusCode == 204;
  }

  // ==========================================
  // REPORTS ENDPOINTS
  // ==========================================

  Future<List<TriageResult>> fetchReports() async {
    final response = await _client
        .get(Uri.parse('$_baseUrl/api/reports'), headers: _headers)
        .timeout(defaultTimeout);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final list = (decoded is List)
          ? decoded
          : (decoded['data'] as List? ?? []);
      return list
          .map((item) => TriageResult.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch reports: ${response.statusCode}');
    }
  }

  Future<TriageResult> createReport(TriageResult report) async {
    final response = await _client
        .post(
          Uri.parse('$_baseUrl/api/reports'),
          headers: _headers,
          body: jsonEncode(report.toJson()),
        )
        .timeout(defaultTimeout);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decoded = jsonDecode(response.body);
      final data = (decoded is Map<String, dynamic> && decoded.containsKey('data'))
          ? decoded['data']
          : decoded;
      return TriageResult.fromJson(data as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create report: ${response.statusCode}');
    }
  }

  // ==========================================
  // VACCINATIONS ENDPOINTS
  // ==========================================

  Future<List<VaccineRecord>> fetchVaccinations() async {
    final response = await _client
        .get(Uri.parse('$_baseUrl/api/vaccinations'), headers: _headers)
        .timeout(defaultTimeout);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final list = (decoded is List)
          ? decoded
          : (decoded['data'] as List? ?? []);
      return list
          .map((item) => VaccineRecord.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch vaccinations: ${response.statusCode}');
    }
  }

  // ==========================================
  // BATCH SYNC ENDPOINT
  // ==========================================

  Future<Map<String, dynamic>> postBatchSync(List<SyncQueueItem> items) async {
    final payload = {
      'sync_items': items.map((i) => i.toMap()).toList(),
    };

    final response = await _client
        .post(
          Uri.parse('$_baseUrl/api/sync'),
          headers: _headers,
          body: jsonEncode(payload),
        )
        .timeout(defaultTimeout);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Batch sync failed with status ${response.statusCode}');
    }
  }
}
