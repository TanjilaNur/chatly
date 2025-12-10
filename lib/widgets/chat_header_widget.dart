import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../constants/chat_theme.dart';

/// Reusable chat header widget following Flutter conventions
class ChatHeaderWidget extends StatelessWidget {
  const ChatHeaderWidget({
    super.key,
    this.title,
  });

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Text(
        title ?? ChatConstants.defaultTitle,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
