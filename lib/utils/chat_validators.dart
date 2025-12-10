/// Validation utilities for chat functionality
class ChatValidators {
  ChatValidators._(); // Private constructor

  /// Validate message content
  static String? validateMessageContent(String? content) {
    if (content == null || content.trim().isEmpty) {
      return 'Message cannot be empty';
    }
    if (content.trim().length > 1000) {
      return 'Message is too long (max 1000 characters)';
    }
    return null;
  }

  /// Validate rating value
  static String? validateRating(double? rating) {
    if (rating == null) return null;
    if (rating < 0 || rating > 5) {
      return 'Rating must be between 0 and 5';
    }
    return null;
  }

  /// Validate suggestion card data
  static List<String> validateSuggestionCard({
    required String id,
    required String title,
    double? rating,
  }) {
    final errors = <String>[];

    if (id.trim().isEmpty) {
      errors.add('ID cannot be empty');
    }

    if (title.trim().isEmpty) {
      errors.add('Title cannot be empty');
    }

    final ratingError = validateRating(rating);
    if (ratingError != null) {
      errors.add(ratingError);
    }

    return errors;
  }

  /// Check if email is valid format
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Check if URL is valid format
  static bool isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    return Uri.tryParse(url) != null;
  }
}
