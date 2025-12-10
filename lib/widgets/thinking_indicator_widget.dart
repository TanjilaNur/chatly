import 'package:flutter/material.dart';
import '../constants/chat_dimensions.dart';

/// Thinking indicator widget for when agent is processing
class ThinkingIndicatorWidget extends StatelessWidget {
  const ThinkingIndicatorWidget({
    super.key,
    this.message = 'Agent is thinking...',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ChatDimensions.largeSpacing,
        vertical: ChatDimensions.mediumSpacing,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ChatDimensions.largeSpacing,
              vertical: ChatDimensions.mediumSpacing,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(ChatDimensions.messageBubbleRadius),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: ChatDimensions.mediumIconSize,
                  height: ChatDimensions.mediumIconSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
                  ),
                ),
                const SizedBox(width: ChatDimensions.mediumSpacing),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
