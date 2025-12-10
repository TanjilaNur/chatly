import 'dart:math';

/// Utility class for generating unique IDs and common operations
class ChatUtils {
  ChatUtils._(); // Private constructor to prevent instantiation

  /// Generate a unique ID based on current timestamp
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Generate a unique ID with random suffix to avoid collisions
  static String generateUniqueId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(1000);
    return '${timestamp}_$random';
  }

  /// Validate if a string is not null or empty
  static bool isValidString(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Format timestamp for display
  static String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  /// Get random element from list
  static T getRandomElement<T>(List<T> list) {
    if (list.isEmpty) {
      throw ArgumentError('List cannot be empty');
    }
    final randomIndex = Random().nextInt(list.length);
    return list[randomIndex];
  }
}
