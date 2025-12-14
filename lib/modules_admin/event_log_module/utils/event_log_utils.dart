import 'package:flutter/material.dart';
import 'package:library_kursach/core/theme/theme.dart';

class EventLogUtils {
  static String getActionTypeLabel(String actionType) {
    switch (actionType.toLowerCase()) {
      case 'create':
        return 'POST';
      case 'update':
        return 'PUT';
      case 'delete':
        return 'DELETE';
      case 'login':
        return 'AUTH';
      default:
        return actionType.toUpperCase();
    }
  }

  static String getEntityTypeLabel(String entityType) {
    if (entityType.isEmpty) return entityType;
    return entityType[0].toUpperCase() + entityType.substring(1);
  }

  static Color getActionTypeColor(String actionType) {
    switch (actionType.toLowerCase()) {
      case 'create':
        return Colors.green;
      case 'update':
        return Colors.blue;
      case 'delete':
        return Colors.red;
      case 'login':
        return Colors.orange;
      default:
        return AppColors.textSecondary;
    }
  }

  static IconData getActionTypeIcon(String actionType) {
    switch (actionType.toLowerCase()) {
      case 'create':
        return Icons.add_circle_outline;
      case 'update':
        return Icons.edit_outlined;
      case 'delete':
        return Icons.delete_outline;
      case 'login':
        return Icons.login;
      default:
        return Icons.info_outline;
    }
  }

  static String formatMetadata(Map<String, dynamic> metadata) {
    final List<String> parts = [];
    
    final hasOldValues = metadata.containsKey('old_values') && 
                        metadata['old_values'] != null &&
                        (metadata['old_values'] as Map<String, dynamic>?)?.isNotEmpty == true;
    
    if (hasOldValues) {
      final oldValues = metadata['old_values'] as Map<String, dynamic>;
      final oldParts = oldValues.entries.map((e) => '${e.key}: ${e.value}').join(', ');
      parts.add('Було: $oldParts');
    }
    
    if (metadata.containsKey('new_values') && metadata['new_values'] != null) {
      final newValues = metadata['new_values'] as Map<String, dynamic>?;
      if (newValues != null && newValues.isNotEmpty) {
        final newParts = newValues.entries.map((e) => '${e.key}: ${e.value}').join(', ');
        if (hasOldValues) {
          parts.add('Стало: $newParts');
        } else {
          parts.add(newParts);
        }
      }
    }
    
    metadata.forEach((key, value) {
      if (key != 'old_values' && key != 'new_values' && value != null) {
        if (value is Map) {
          final mapParts = value.entries.map((e) => '${e.key}: ${e.value}').join(', ');
          parts.add('$key: $mapParts');
        } else {
          parts.add('$key: $value');
        }
      }
    });
    
    return parts.join('\n');
  }
}

