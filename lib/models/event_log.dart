class EventLog {
  final int id;
  final int? userId;
  final String? userName;
  final String actionType;
  final String entityType;
  final int? entityId;
  final String description;
  final Map<String, dynamic>? metadata;
  final String? ipAddress;
  final DateTime timestamp;

  EventLog({
    required this.id,
    this.userId,
    this.userName,
    required this.actionType,
    required this.entityType,
    this.entityId,
    required this.description,
    this.metadata,
    this.ipAddress,
    required this.timestamp,
  });

  factory EventLog.fromJson(Map<String, dynamic> json) {
    return EventLog(
      id: json['id'],
      userId: json['user_id'],
      userName: json['user_name'],
      actionType: json['action_type'],
      entityType: json['entity_type'],
      entityId: json['entity_id'],
      description: json['description'],
      metadata: json['metadata'] as Map<String, dynamic>?,
      ipAddress: json['ip_address'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'action_type': actionType,
      'entity_type': entityType,
      'entity_id': entityId,
      'description': description,
      'metadata': metadata,
      'ip_address': ipAddress,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

