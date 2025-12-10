/// Enum for different types of chat messages
enum MessageType {
  text,
  responseOptions,
  suggestionCards,
}

/// Extension to get display name for message types
extension MessageTypeExtension on MessageType {
  String get displayName {
    switch (this) {
      case MessageType.text:
        return 'Text';
      case MessageType.responseOptions:
        return 'Response Options';
      case MessageType.suggestionCards:
        return 'Suggestion Cards';
    }
  }
}
