import 'package:flutter/material.dart';

/// Extensions for commonly used operations in the chat interface
extension ColorExtensions on Color {
  /// Create a color with alpha value using the new Flutter API
  Color withAlpha(double alpha) => withValues(alpha: alpha);
}

/// Extensions for DateTime formatting
extension DateTimeExtensions on DateTime {
  /// Check if the date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if the date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  /// Get formatted time string
  String get chatTimeFormat {
    if (isToday) {
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } else if (isYesterday) {
      return 'Yesterday';
    } else {
      return '${day}/${month}/${year}';
    }
  }
}

/// Extensions for String validation and formatting
extension StringExtensions on String {
  /// Check if string is not empty after trimming
  bool get isNotEmptyTrimmed => trim().isNotEmpty;

  /// Capitalize first letter
  String get capitalized {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Truncate string with ellipsis
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }
}

/// Extensions for List operations
extension ListExtensions<T> on List<T> {
  /// Get random element safely
  T? get randomElement {
    if (isEmpty) return null;
    final random = DateTime.now().millisecond % length;
    return this[random];
  }

  /// Check if list is not null and not empty
  bool get isNotNullOrEmpty => isNotEmpty;
}
