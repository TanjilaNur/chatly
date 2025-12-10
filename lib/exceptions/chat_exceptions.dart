/// Base exception class for chat-related errors
abstract class ChatException implements Exception {
  const ChatException(this.message);
  final String message;

  @override
  String toString() => 'ChatException: $message';
}

/// Exception thrown when message processing fails
class MessageProcessingException extends ChatException {
  const MessageProcessingException(super.message);
}

/// Exception thrown when agent service is unavailable
class AgentServiceException extends ChatException {
  const AgentServiceException(super.message);
}

/// Exception thrown when network request fails
class NetworkException extends ChatException {
  const NetworkException(super.message);
}

/// Exception thrown when invalid data is encountered
class ValidationException extends ChatException {
  const ValidationException(super.message);
}
