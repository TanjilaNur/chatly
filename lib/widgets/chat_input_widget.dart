import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../constants/chat_dimensions.dart';

/// Reusable chat input widget following Flutter conventions
class ChatInputWidget extends StatefulWidget {
  const ChatInputWidget({
    super.key,
    required this.onMessageSent,
    this.isProcessing = false,
    this.onStopProcessing,
  });

  final ValueChanged<String> onMessageSent;
  final bool isProcessing;
  final VoidCallback? onStopProcessing;

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSendMessage() {
    final messageText = _textController.text.trim();
    if (messageText.isEmpty) return;

    widget.onMessageSent(messageText);
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: BottomSheetConstants.sendBoxHeight,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        children: [
          Expanded(child: _buildInputField()),
          const SizedBox(width: ChatDimensions.mediumSpacing),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      height: BottomSheetConstants.inputFieldHeight,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        controller: _textController,
        enabled: !widget.isProcessing,
        decoration: const InputDecoration(
          hintText: 'Type a message...',
          hintStyle: TextStyle(fontSize: ChatDimensions.messageFontSize),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(12.0),
          isDense: true,
        ),
        style: const TextStyle(fontSize: ChatDimensions.messageFontSize),
        maxLines: 1,
        textInputAction: TextInputAction.send,
        onSubmitted: (_) => _handleSendMessage(),
      ),
    );
  }

  Widget _buildSendButton() {
    return Container(
      width: BottomSheetConstants.sendButtonSize,
      height: BottomSheetConstants.sendButtonSize,
      decoration: BoxDecoration(
        color: widget.isProcessing ? Colors.red[100] : Colors.blue[600],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: widget.isProcessing ? widget.onStopProcessing : _handleSendMessage,
        icon: Icon(
          widget.isProcessing ? Icons.stop : Icons.send,
          size: ChatDimensions.mediumIconSize,
          color: widget.isProcessing ? Colors.red[600] : Colors.white,
        ),
        padding: EdgeInsets.zero,
        tooltip: widget.isProcessing ? 'Stop thinking' : 'Send message',
      ),
    );
  }
}
