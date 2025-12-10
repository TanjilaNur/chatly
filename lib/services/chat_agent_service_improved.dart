import 'dart:async';
import '../models/agent_response_model.dart';
import '../models/suggestion_card_model.dart';
import '../models/response_option_model.dart';
import '../exceptions/chat_exceptions.dart';
import '../utils/chat_utils.dart';
import '../constants/demo_constants.dart';
import 'suggestion_repository.dart';

/// Service for handling chat agent interactions with improved error handling
class ChatAgentService {
  ChatAgentService._(); // Private constructor

  static const Duration _defaultDelay = Duration(milliseconds: 1800);
  static const Duration _quickDelay = Duration(milliseconds: 1000);

  /// Process user message and return appropriate response
  static Future<AgentResponseModel> processMessage(String userMessage) async {
    try {
      if (!ChatUtils.isValidString(userMessage)) {
        throw const ValidationException('Message cannot be empty');
      }

      // Simulate network delay
      await Future.delayed(_defaultDelay);

      final normalizedMessage = userMessage.toLowerCase().trim();

      // Check for demo commands first
      final demoResponse = _handleDemoCommands(normalizedMessage);
      if (demoResponse != null) {
        return demoResponse;
      }

      // Check for suggestion triggers
      final suggestionResponse = _handleSuggestionRequests(normalizedMessage);
      if (suggestionResponse != null) {
        return suggestionResponse;
      }

      // Check for response option triggers (replaces yes/no questions)
      final responseOptionResponse = _handleResponseOptionQuestions(normalizedMessage);
      if (responseOptionResponse != null) {
        return responseOptionResponse;
      }

      // Check for standard responses
      final standardResponse = _handleStandardResponses(normalizedMessage);
      if (standardResponse != null) {
        return standardResponse;
      }

      // Default response
      return _generateDefaultResponse(userMessage);

    } catch (e) {
      if (e is ChatException) {
        rethrow;
      }
      throw MessageProcessingException('Failed to process message: ${e.toString()}');
    }
  }

  /// Process response option selection
  static Future<AgentResponseModel> processResponseSelection(ResponseOptionModel selectedOption) async {
    await Future.delayed(_quickDelay);

    // Generate follow-up response based on selected option
    final followUpContent = _generateResponseFollowUp(selectedOption);
    return AgentResponseModel.text(followUpContent);
  }

  /// Process suggestion card selection
  static Future<AgentResponseModel> processSuggestionSelection(SuggestionCardModel selectedCard) async {
    await Future.delayed(_quickDelay);

    final followUpContent = _generateSuggestionFollowUp(selectedCard);
    return AgentResponseModel.text(followUpContent);
  }

  // Private helper methods

  static AgentResponseModel? _handleDemoCommands(String message) {
    // Check for demo command matches
    for (final command in DemoConstants.quickDemoResponses.keys) {
      if (message.contains(command)) {
        return AgentResponseModel.text(DemoConstants.quickDemoResponses[command]!);
      }
    }
    return null;
  }

  static AgentResponseModel? _handleSuggestionRequests(String message) {
    final suggestionTriggers = {
      'cafe': 'coffee places',
      'cafes': 'coffee places',
      'nearest cafe': 'coffee places',
      'coffee': 'coffee places',
      'restaurant': 'dining options',
      'restaurants': 'dining options',
      'food': 'dining options',
    };

    for (final trigger in suggestionTriggers.keys) {
      if (message.contains(trigger)) {
        final suggestions = SuggestionRepository.getSuggestionsByType(trigger);
        if (suggestions.isNotEmpty) {
          return AgentResponseModel.withSuggestions(
            content: 'Here are some great ${suggestionTriggers[trigger]} near you:',
            suggestions: suggestions,
          );
        }
      }
    }
    return null;
  }

  static AgentResponseModel? _handleResponseOptionQuestions(String message) {
    // Survey question with rating scale
    if (message.contains('survey') || message.contains('rating')) {
      final ratingOptions = [
        ResponseOptionModel.create(label: 'Excellent', value: '5'),
        ResponseOptionModel.create(label: 'Good', value: '4'),
        ResponseOptionModel.create(label: 'Average', value: '3'),
        ResponseOptionModel.create(label: 'Poor', value: '2'),
        ResponseOptionModel.create(label: 'Terrible', value: '1'),
      ];

      return AgentResponseModel.withResponseOptions(
        content: 'How would you rate your experience with our service?',
        responseOptions: ratingOptions,
      );
    }

    // Preference selection
    if (message.contains('preference') || message.contains('choose')) {
      final preferenceOptions = [
        ResponseOptionModel.create(label: 'Coffee Shops', value: 'coffee'),
        ResponseOptionModel.create(label: 'Restaurants', value: 'restaurant'),
        ResponseOptionModel.create(label: 'Shopping', value: 'shopping'),
        ResponseOptionModel.create(label: 'Entertainment', value: 'entertainment'),
      ];

      return AgentResponseModel.withResponseOptions(
        content: 'What type of places are you most interested in?',
        responseOptions: preferenceOptions,
      );
    }

    // Satisfaction survey
    if (message.contains('feedback') || message.contains('satisfaction')) {
      final satisfactionOptions = [
        ResponseOptionModel.create(label: 'Very Satisfied', value: 'very_satisfied'),
        ResponseOptionModel.create(label: 'Satisfied', value: 'satisfied'),
        ResponseOptionModel.create(label: 'Neutral', value: 'neutral'),
        ResponseOptionModel.create(label: 'Dissatisfied', value: 'dissatisfied'),
        ResponseOptionModel.create(label: 'Very Dissatisfied', value: 'very_dissatisfied'),
      ];

      return AgentResponseModel.withResponseOptions(
        content: 'How satisfied are you with our chat service?',
        responseOptions: satisfactionOptions,
      );
    }

    // Contact preference
    if (message.contains('contact') || message.contains('communication')) {
      final contactOptions = [
        ResponseOptionModel.create(label: 'Email', value: 'email'),
        ResponseOptionModel.create(label: 'Phone Call', value: 'phone'),
        ResponseOptionModel.create(label: 'Text Message', value: 'sms'),
        ResponseOptionModel.create(label: 'Push Notification', value: 'push'),
        ResponseOptionModel.create(label: 'No Contact', value: 'none'),
      ];

      return AgentResponseModel.withResponseOptions(
        content: 'How would you prefer us to contact you for updates?',
        responseOptions: contactOptions,
      );
    }

    return null;
  }

  static AgentResponseModel? _handleStandardResponses(String message) {
    const standardResponses = {
      'hi': 'Hello! How can I help you today?',
      'hello': 'Hi there! Welcome to our chat support.',
      'how are you': 'I\'m doing great, thank you for asking! How are you?',
      'what is your name': 'I\'m your virtual assistant. You can call me Bot.',
      'help': 'I\'m here to help! You can ask me anything.',
      'thanks': 'You\'re welcome! Is there anything else I can help you with?',
      'thank you': 'My pleasure! Feel free to ask if you need anything else.',
      'bye': 'Goodbye! Have a great day!',
      'good morning': 'Good morning! Hope you\'re having a wonderful day.',
      'good evening': 'Good evening! How has your day been?',
      'weather': 'I wish I could check the weather for you, but I don\'t have access to that information right now.',
      'time': 'I don\'t have access to real-time information, but you can check your device clock.',
      'joke': 'Why don\'t scientists trust atoms? Because they make up everything! 😄',
      'ok': 'Great! Anything else I can help you with?',
      'yes': 'Perfect! What would you like to know?',
      'no': 'No problem! Let me know if you need anything.',
    };

    // Check for exact matches first
    if (standardResponses.containsKey(message)) {
      return AgentResponseModel.text(standardResponses[message]!);
    }

    // Check for partial matches
    for (final key in standardResponses.keys) {
      if (message.contains(key)) {
        return AgentResponseModel.text(standardResponses[key]!);
      }
    }

    return null;
  }

  static String _generateResponseFollowUp(ResponseOptionModel selectedOption) {
    // Generate contextual follow-up based on the selected option
    switch (selectedOption.value) {
      case '5':
      case 'very_satisfied':
      case 'excellent':
        return 'Thank you for the excellent rating! We\'re thrilled that you\'re happy with our service. 🌟';

      case '4':
      case 'satisfied':
      case 'good':
        return 'Thank you for the positive feedback! We appreciate your business and will continue to improve. 👍';

      case '3':
      case 'neutral':
      case 'average':
        return 'Thanks for your feedback. We\'d love to know how we can better serve you in the future.';

      case '2':
      case '1':
      case 'dissatisfied':
      case 'very_dissatisfied':
      case 'poor':
      case 'terrible':
        return 'We\'re sorry to hear about your experience. We\'ll work hard to improve our service. Your feedback is valuable to us.';

      case 'coffee':
        return 'Great choice! Coffee shops are perfect for working or relaxing. Let me know if you\'d like specific recommendations.';

      case 'restaurant':
        return 'Excellent! I can help you find great dining options. Any particular cuisine you\'re in the mood for?';

      case 'email':
        return 'Perfect! We\'ll send you updates via email. You can manage your preferences anytime in settings.';

      case 'phone':
        return 'Got it! We\'ll call you for important updates. Make sure your phone number is up to date in your profile.';

      default:
        return 'Thank you for your selection! Is there anything else I can help you with?';
    }
  }

  static String _generateSuggestionFollowUp(SuggestionCardModel selectedCard) {
    return 'Great choice! You selected "${selectedCard.title}". Would you like more information about this place or see similar options?';
  }

  static AgentResponseModel _generateDefaultResponse(String userMessage) {
    final defaultResponses = [
      'I understand you said "$userMessage". Could you tell me more about that?',
      'That\'s interesting! Can you elaborate on "$userMessage"?',
      'I received your message about "$userMessage". How can I help you with that?',
      'Thanks for sharing "$userMessage" with me. What would you like to know?',
      'I see you mentioned "$userMessage". Is there something specific I can help you with?',
    ];

    final randomResponse = ChatUtils.getRandomElement(defaultResponses);
    return AgentResponseModel.text(randomResponse);
  }
}
