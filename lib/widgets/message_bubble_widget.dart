import 'package:flutter/material.dart';
import '../models/chat_message_model.dart';
import '../models/suggestion_card_model.dart';
import '../models/response_option_model.dart';
import '../constants/chat_dimensions.dart';
import '../constants/chat_theme.dart';
import '../widgets/suggestion_cards_list_widget.dart';

/// Improved message bubble widget following Flutter conventions
class MessageBubbleWidget extends StatelessWidget {
  const MessageBubbleWidget({
    super.key,
    required this.message,
    this.onResponseSelected,
    this.onSuggestionSelected,
  });

  final ChatMessageModel message;
  final ValueChanged<ResponseOptionModel>? onResponseSelected;
  final ValueChanged<SuggestionCardModel>? onSuggestionSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: ChatDimensions.messageBubblePadding),
      child: Row(
        mainAxisAlignment: message.isFromUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: message.isFromUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                _buildMessageBubble(context),
                _buildInteractiveElements(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ChatDimensions.cardPadding + 2,
        vertical: ChatDimensions.mediumSpacing,
      ),
      decoration: BoxDecoration(
        color: _getMessageBubbleColor(context),
        borderRadius: BorderRadius.circular(ChatDimensions.messageBubbleRadius),
        boxShadow: ChatTheme.messageShadow,
      ),
      child: Text(
        message.content,
        style: TextStyle(
          color: _getTextColor(context),
          fontSize: ChatDimensions.messageFontSize,
        ),
      ),
    );
  }

  Widget _buildInteractiveElements() {
    return Column(
      crossAxisAlignment: message.isFromUser
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        if (message.hasResponseOptions && message.selectedResponseId == null)
          _buildResponseOptions(),
        if (message.isSuggestionPending)
          SuggestionCardsListWidget(
            cards: message.suggestions!,
            onCardSelected: onSuggestionSelected,
          ),
      ],
    );
  }

  Widget _buildResponseOptions() {
    return Padding(
      padding: const EdgeInsets.only(top: ChatDimensions.mediumSpacing),
      child: Wrap(
        spacing: ChatDimensions.smallSpacing,
        runSpacing: ChatDimensions.smallSpacing,
        children: message.responseOptions!.map((option) =>
          _buildResponseButton(option)
        ).toList(),
      ),
    );
  }

  Widget _buildResponseButton(ResponseOptionModel option) {
    return OutlinedButton(
      onPressed: () => onResponseSelected?.call(option),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: ChatDimensions.buttonPadding,
          vertical: ChatDimensions.mediumSpacing,
        ),
        minimumSize: const Size(
          ChatDimensions.buttonMinWidth,
          ChatDimensions.buttonHeight,
        ),
        side: BorderSide(color: Colors.grey[400]!),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ChatDimensions.borderRadius),
        ),
      ),
      child: Text(
        option.label,
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getMessageBubbleColor(BuildContext context) {
    if (message.isFromUser) {
      return ChatTheme.userMessageColor;
    }
    return Theme.of(context).colorScheme.surface;
  }

  Color _getTextColor(BuildContext context) {
    if (message.isFromUser) {
      return Colors.white;
    }
    return Theme.of(context).colorScheme.onSurface;
  }
}
