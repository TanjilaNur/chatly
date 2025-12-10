import 'package:equatable/equatable.dart';
import '../enums/message_type.dart';
import '../utils/chat_utils.dart';
import 'suggestion_card_model.dart';
import 'response_option_model.dart';

/// Improved chat message model following Flutter conventions
class ChatMessageModel extends Equatable {
  final String id;
  final String content;
  final bool isFromUser;
  final DateTime timestamp;
  final String? senderName;
  final MessageType type;
  final List<SuggestionCardModel>? suggestions;
  final List<ResponseOptionModel>? responseOptions;
  final String? selectedResponseId;
  final String? selectedSuggestionId;

  const ChatMessageModel({
    required this.id,
    required this.content,
    required this.isFromUser,
    required this.timestamp,
    this.senderName,
    this.type = MessageType.text,
    this.suggestions,
    this.responseOptions,
    this.selectedResponseId,
    this.selectedSuggestionId,
  });

  /// Factory constructor with validation and auto-generated ID
  factory ChatMessageModel.create({
    required String content,
    required bool isFromUser,
    String? senderName,
    MessageType type = MessageType.text,
    List<SuggestionCardModel>? suggestions,
    List<ResponseOptionModel>? responseOptions,
    String? selectedResponseId,
    String? selectedSuggestionId,
  }) {
    if (!ChatUtils.isValidString(content)) {
      throw ArgumentError('Message content cannot be empty');
    }

    return ChatMessageModel(
      id: ChatUtils.generateUniqueId(),
      content: content.trim(),
      isFromUser: isFromUser,
      timestamp: DateTime.now(),
      senderName: senderName?.trim(),
      type: type,
      suggestions: suggestions,
      responseOptions: responseOptions,
      selectedResponseId: selectedResponseId,
      selectedSuggestionId: selectedSuggestionId,
    );
  }

  /// Create user message
  factory ChatMessageModel.userMessage(String content) {
    return ChatMessageModel.create(
      content: content,
      isFromUser: true,
    );
  }

  /// Create agent message
  factory ChatMessageModel.agentMessage({
    required String content,
    MessageType type = MessageType.text,
    List<SuggestionCardModel>? suggestions,
    List<ResponseOptionModel>? responseOptions,
  }) {
    return ChatMessageModel.create(
      content: content,
      isFromUser: false,
      senderName: 'Agent',
      type: type,
      suggestions: suggestions,
      responseOptions: responseOptions,
    );
  }

  ChatMessageModel copyWith({
    String? id,
    String? content,
    bool? isFromUser,
    DateTime? timestamp,
    String? senderName,
    MessageType? type,
    List<SuggestionCardModel>? suggestions,
    List<ResponseOptionModel>? responseOptions,
    String? selectedResponseId,
    String? selectedSuggestionId,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      content: content ?? this.content,
      isFromUser: isFromUser ?? this.isFromUser,
      timestamp: timestamp ?? this.timestamp,
      senderName: senderName ?? this.senderName,
      type: type ?? this.type,
      suggestions: suggestions ?? this.suggestions,
      responseOptions: responseOptions ?? this.responseOptions,
      selectedResponseId: selectedResponseId ?? this.selectedResponseId,
      selectedSuggestionId: selectedSuggestionId ?? this.selectedSuggestionId,
    );
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      content: json['content'] as String,
      isFromUser: json['isFromUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      senderName: json['senderName'] as String?,
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
      selectedResponseId: json['selectedResponseId'] as String?,
      selectedSuggestionId: json['selectedSuggestionId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isFromUser': isFromUser,
      'timestamp': timestamp.toIso8601String(),
      'senderName': senderName,
      'type': type.name,
      'suggestions': suggestions?.map((card) => card.toJson()).toList(),
      'responseOptions': responseOptions?.map((option) => option.toJson()).toList(),
      'selectedResponseId': selectedResponseId,
      'selectedSuggestionId': selectedSuggestionId,
    };
  }

  /// Helper getters
  bool get hasResponseOptions => responseOptions != null && responseOptions!.isNotEmpty;
  bool get hasSuggestions => suggestions != null && suggestions!.isNotEmpty;
  bool get isResponsePending => hasResponseOptions && selectedResponseId == null;
  bool get isSuggestionPending => hasSuggestions && selectedSuggestionId == null;
  String get formattedTime => ChatUtils.formatTimestamp(timestamp);

  @override
  List<Object?> get props => [
        id,
        content,
        isFromUser,
        timestamp,
        senderName,
        type,
        suggestions,
        responseOptions,
        selectedResponseId,
        selectedSuggestionId,
      ];
}
