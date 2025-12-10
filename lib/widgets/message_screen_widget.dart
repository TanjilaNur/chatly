import 'package:flutter/material.dart';
import '../controllers/chat_controller_improved.dart';
import '../widgets/message_bubble_widget.dart';
import '../widgets/chat_input_widget.dart';
import '../widgets/chat_header_widget.dart';
import '../widgets/thinking_indicator_widget.dart';
import '../constants/app_constants.dart';
import '../constants/chat_dimensions.dart';

/// Improved message screen following Flutter conventions
class MessageScreenWidget extends StatefulWidget {
  const MessageScreenWidget({
    super.key,
    this.onHeightChangeRequest,
    this.currentHeightFactor,
  });

  final ValueChanged<double>? onHeightChangeRequest;
  final double? currentHeightFactor;

  @override
  State<MessageScreenWidget> createState() => _MessageScreenWidgetState();
}

class _MessageScreenWidgetState extends State<MessageScreenWidget> {
  late final ChatControllerImproved _chatController;
  late final ScrollController _scrollController;
  bool _isExpandingFromMinHeight = false;

  @override
  void initState() {
    super.initState();
    _chatController = ChatControllerImproved();
    _scrollController = ScrollController();
    _chatController.addListener(_onChatStateChanged);

    // Add welcome message for demo
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _chatController.sendWelcomeMessage();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _chatController.removeListener(_onChatStateChanged);
    _chatController.dispose();
    super.dispose();
  }

  void _onChatStateChanged() {
    if (mounted) {
      setState(() {});
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleMessageSend(String messageText) async {
    await _expandIfNeeded();
    await _chatController.sendMessage(messageText);
  }

  Future<void> _expandIfNeeded() async {
    final currentHeight = widget.currentHeightFactor ?? BottomSheetConstants.minHeight;

    if (currentHeight <= BottomSheetConstants.minHeight + 0.01) {
      setState(() {
        _isExpandingFromMinHeight = true;
      });

      widget.onHeightChangeRequest?.call(BottomSheetConstants.mediumHeight);
      await Future.delayed(const Duration(milliseconds: 250));

      setState(() {
        _isExpandingFromMinHeight = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    final currentHeight = widget.currentHeightFactor ?? BottomSheetConstants.minHeight;
    final isAtMinHeight = currentHeight <= BottomSheetConstants.minHeight + 0.01;
    final shouldShowMessages = !isAtMinHeight && !_isExpandingFromMinHeight;

    return Column(
      children: [
        const ChatHeaderWidget(),
        if (shouldShowMessages) Expanded(child: _buildMessagesList()),
        ChatInputWidget(
          onMessageSent: _handleMessageSend,
          isProcessing: _chatController.isProcessing,
          onStopProcessing: _chatController.stopProcessing,
        ),
        if (shouldShowMessages)
          SizedBox(height: BottomSheetConstants.bottomSpacing),
      ],
    );
  }

  Widget _buildMessagesList() {
    if (!_chatController.hasMessages) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.zero,
      itemCount: _chatController.messageCount + (_chatController.isProcessing ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _chatController.messageCount) {
          return _buildMessageItem(index);
        }
        return const ThinkingIndicatorWidget();
      },
    );
  }

  Widget _buildMessageItem(int index) {
    final message = _chatController.messages[index];
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ChatDimensions.cardPadding + 2,
        vertical: ChatDimensions.smallSpacing,
      ),
      child: MessageBubbleWidget(
        message: message,
        onResponseSelected: (option) {
          _chatController.handleResponseSelection(message.id, option);
        },
        onSuggestionSelected: (card) {
          _chatController.handleSuggestionSelection(message.id, card);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'Start a conversation',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 16,
        ),
      ),
    );
  }
}
