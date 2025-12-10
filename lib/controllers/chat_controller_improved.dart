import 'package:flutter/foundation.dart';
import '../models/chat_message_model.dart';
import '../models/suggestion_card_model.dart';
import '../models/response_option_model.dart';
import '../services/chat_agent_service_improved.dart';
import '../exceptions/chat_exceptions.dart';

/// Improved chat controller following Flutter best practices
class ChatControllerImproved extends ChangeNotifier {
  final List<ChatMessageModel> _messages = [];
  bool _isProcessing = false;
  bool _isCancelled = false;
  String? _error;

  // Getters following naming conventions
  List<ChatMessageModel> get messages => List.unmodifiable(_messages);
  bool get isProcessing => _isProcessing;
  bool get hasError => _error != null;
  String? get error => _error;
  bool get hasMessages => _messages.isNotEmpty;
  int get messageCount => _messages.length;
  ChatMessageModel? get lastMessage => _messages.isNotEmpty ? _messages.last : null;

  /// Send a welcome message for demo purposes
  void sendWelcomeMessage() {
    final welcomeMessage = ChatMessageModel.agentMessage(
      content: 'Welcome to the Chat Demo! 👋\n\nTry typing "demo" to see what I can do!',
    );
    _addMessage(welcomeMessage);
  }

  /// Send a text message
  Future<void> sendMessage(String messageText) async {
    try {
      _clearError();

      if (messageText.trim().isEmpty) {
        throw const ValidationException('Message cannot be empty');
      }

      // Add user message
      final userMessage = ChatMessageModel.userMessage(messageText.trim());
      _addMessage(userMessage);

      // Process agent response
      await _processAgentResponse(messageText);

    } catch (e) {
      _handleError(e);
    }
  }

  /// Handle generic response option selection
  Future<void> handleResponseSelection(String messageId, ResponseOptionModel selectedOption) async {
    try {
      _clearError();

      if (!_updateMessageResponseSelection(messageId, selectedOption.id)) {
        throw const ValidationException('Message not found');
      }

      // Add user response as message
      final userResponseMessage = ChatMessageModel.userMessage(selectedOption.label);
      _addMessage(userResponseMessage);

      // Process follow-up response
      await _processResponseFollowUp(selectedOption);

    } catch (e) {
      _handleError(e);
    }
  }

  /// Handle suggestion card selection
  Future<void> handleSuggestionSelection(String messageId, SuggestionCardModel selectedCard) async {
    try {
      _clearError();

      if (!_updateMessageSuggestionSelection(messageId, selectedCard.id)) {
        throw const ValidationException('Message not found');
      }

      // Add user selection as message
      final userSelectionMessage = ChatMessageModel.userMessage(selectedCard.title);
      _addMessage(userSelectionMessage);

      // Process follow-up response
      await _processSuggestionFollowUp(selectedCard);

    } catch (e) {
      _handleError(e);
    }
  }

  /// Stop current processing
  void stopProcessing() {
    _isCancelled = true;
    _setProcessingState(false);
  }

  /// Clear all messages
  void clearMessages() {
    _messages.clear();
    _clearError();
    notifyListeners();
  }

  // Private helper methods
  void _addMessage(ChatMessageModel message) {
    _messages.add(message);
    notifyListeners();
  }

  void _setProcessingState(bool processing) {
    _isProcessing = processing;
    if (!processing) {
      _isCancelled = false;
    }
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void _handleError(Object error) {
    if (error is ChatException) {
      _error = error.message;
    } else {
      _error = 'An unexpected error occurred';
    }
    _setProcessingState(false);

    // Add error message to chat
    final errorMessage = ChatMessageModel.agentMessage(
      content: _error!,
    );
    _addMessage(errorMessage);
  }

  bool _updateMessageResponseSelection(String messageId, String responseId) {
    final messageIndex = _messages.indexWhere((msg) => msg.id == messageId);
    if (messageIndex != -1) {
      _messages[messageIndex] = _messages[messageIndex].copyWith(
        selectedResponseId: responseId,
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  bool _updateMessageSuggestionSelection(String messageId, String suggestionId) {
    final messageIndex = _messages.indexWhere((msg) => msg.id == messageId);
    if (messageIndex != -1) {
      _messages[messageIndex] = _messages[messageIndex].copyWith(
        selectedSuggestionId: suggestionId,
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> _processAgentResponse(String messageText) async {
    _setProcessingState(true);

    try {
      final agentResponse = await ChatAgentService.processMessage(messageText);

      if (!_isCancelled) {
        final agentMessage = ChatMessageModel.agentMessage(
          content: agentResponse.content,
          type: agentResponse.type,
          suggestions: agentResponse.suggestions,
          responseOptions: agentResponse.responseOptions,
        );
        _addMessage(agentMessage);
      }
    } catch (e) {
      if (!_isCancelled) {
        rethrow;
      }
    } finally {
      _setProcessingState(false);
    }
  }

  Future<void> _processResponseFollowUp(ResponseOptionModel selectedOption) async {
    _setProcessingState(true);

    try {
      final followUpResponse = await ChatAgentService.processResponseSelection(selectedOption);

      if (!_isCancelled) {
        final followUpMessage = ChatMessageModel.agentMessage(
          content: followUpResponse.content,
          type: followUpResponse.type,
          suggestions: followUpResponse.suggestions,
          responseOptions: followUpResponse.responseOptions,
        );
        _addMessage(followUpMessage);
      }
    } catch (e) {
      if (!_isCancelled) {
        rethrow;
      }
    } finally {
      _setProcessingState(false);
    }
  }

  Future<void> _processSuggestionFollowUp(SuggestionCardModel selectedCard) async {
    _setProcessingState(true);

    try {
      final followUpResponse = await ChatAgentService.processSuggestionSelection(selectedCard);

      if (!_isCancelled) {
        final followUpMessage = ChatMessageModel.agentMessage(
          content: followUpResponse.content,
          type: followUpResponse.type,
          suggestions: followUpResponse.suggestions,
          responseOptions: followUpResponse.responseOptions,
        );
        _addMessage(followUpMessage);
      }
    } catch (e) {
      if (!_isCancelled) {
        rethrow;
      }
    } finally {
      _setProcessingState(false);
    }
  }
}
