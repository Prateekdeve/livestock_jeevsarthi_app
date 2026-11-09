import 'dart:convert';

class SyncQueueItem {
  final int? id;
  final String action; // 'INSERT', 'UPDATE', 'DELETE'
  final String entityType; // 'animal', 'report', 'vaccination'
  final String entityId;
  final String payload; // JSON encoded map
  final String createdAt;
  final int attempts;
  final String? lastError;

  SyncQueueItem({
    this.id,
    required this.action,
    required this.entityType,
    required this.entityId,
    required this.payload,
    String? createdAt,
    this.attempts = 0,
    this.lastError,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'action': action,
      'entity_type': entityType,
      'entity_id': entityId,
      'payload': payload,
      'created_at': createdAt,
      'attempts': attempts,
      'last_error': lastError,
    };
  }

  factory SyncQueueItem.fromMap(Map<String, dynamic> map) {
    return SyncQueueItem(
      id: map['id'] as int?,
      action: map['action']?.toString() ?? 'INSERT',
      entityType: map['entity_type']?.toString() ?? '',
      entityId: map['entity_id']?.toString() ?? '',
      payload: map['payload']?.toString() ?? '{}',
      createdAt: map['created_at']?.toString() ?? DateTime.now().toIso8601String(),
      attempts: (map['attempts'] as num?)?.toInt() ?? 0,
      lastError: map['last_error']?.toString(),
    );
  }

  Map<String, dynamic> get parsedPayload {
    try {
      return jsonDecode(payload) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  SyncQueueItem copyWith({
    int? id,
    String? action,
    String? entityType,
    String? entityId,
    String? payload,
    String? createdAt,
    int? attempts,
    String? lastError,
  }) {
    return SyncQueueItem(
      id: id ?? this.id,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
    );
  }
}

