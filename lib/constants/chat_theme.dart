import 'package:flutter/material.dart';

/// Theme-related constants for the chat interface
class ChatTheme {
  ChatTheme._(); // Private constructor

  // Colors
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color userMessageColor = Color(0xFF1976D2);
  static const Color agentMessageColor = Color(0xFFF5F5F5);
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color borderColor = Color(0xFFE0E0E0);

  // Gradients
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.white, Color(0xFFF8F9FA)],
  );

  // Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get messageShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 1,
      offset: const Offset(0, 1),
    ),
  ];
}
