import 'package:equatable/equatable.dart';
import '../enums/message_type.dart';
import '../models/suggestion_card_model.dart';
import '../models/response_option_model.dart';

/// Model for agent responses following Flutter conventions
class AgentResponseModel extends Equatable {
  final String content;
  final MessageType type;
  final List<SuggestionCardModel>? suggestions;
  final List<ResponseOptionModel>? responseOptions;

  const AgentResponseModel({
    required this.content,
    this.type = MessageType.text,
    this.suggestions,
    this.responseOptions,
  });

  /// Factory for text response
  factory AgentResponseModel.text(String content) {
    return AgentResponseModel(content: content);
  }

  /// Factory for response options (replaces yesNoQuestion)
  factory AgentResponseModel.withResponseOptions({
    required String content,
    required List<ResponseOptionModel> responseOptions,
  }) {
    return AgentResponseModel(
      content: content,
      type: MessageType.responseOptions,
      responseOptions: responseOptions,
    );
  }

  /// Factory for suggestion cards response
  factory AgentResponseModel.withSuggestions({
    required String content,
    required List<SuggestionCardModel> suggestions,
  }) {
    return AgentResponseModel(
      content: content,
      type: MessageType.suggestionCards,
      suggestions: suggestions,
    );
  }

  factory AgentResponseModel.fromJson(Map<String, dynamic> json) {
    return AgentResponseModel(
      content: json['content'] as String,
      type: MessageType.values.firstWhere(
        (type) => type.name == json['type'],
        orElse: () => MessageType.text,
      ),
      suggestions: json['suggestions'] != null
          ? (json['suggestions'] as List)
              .map((card) => SuggestionCardModel.fromJson(card))
              .toList()
          : null,
      responseOptions: json['responseOptions'] != null
          ? (json['responseOptions'] as List)
              .map((option) => ResponseOptionModel.fromJson(option))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'type': type.name,
      'suggestions': suggestions?.map((card) => card.toJson()).toList(),
      'responseOptions': responseOptions?.map((option) => option.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [content, type, suggestions, responseOptions];
}
