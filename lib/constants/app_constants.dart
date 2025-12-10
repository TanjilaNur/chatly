/// Constants for the resizable bottom sheet
class BottomSheetConstants {
  // Height configurations
  static const double minHeight = 0.18; // 18%
  static const double mediumHeight = 0.50; // 50%
  static const double maxHeight = 0.85; // 85%

  // Animation settings
  static const Duration animationDuration = Duration(milliseconds: 150);
  static const double dragSensitivity = 1.2;

  // UI dimensions
  static const double borderRadius = 20.0;
  static const double dragHandleWidth = 40.0;
  static const double dragHandleHeight = 4.0;
  static const double dragHandlePadding = 12.0;

  // Send box dimensions
  static const double sendBoxHeight = 60.0;
  static const double inputFieldHeight = 36.0;
  static const double sendButtonSize = 36.0;
  static const double sendBoxPadding = 12.0;

  // Header dimensions
  static const double headerPadding = 12.0;
  static const double bottomSpacing = 12.0;
}

/// Constants for chat messages
class ChatConstants {
  static const String agentName = 'Agent';
  static const String defaultTitle = 'Chat Support';
  static const double messageBubblePadding = 8.0;
  static const double messageFontSize = 14.0;
  static const double messageBubbleRadius = 16.0;
}
