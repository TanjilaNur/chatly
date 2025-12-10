/// Demo-specific constants and sample data for showcasing features
class DemoConstants {
  DemoConstants._(); // Private constructor

  /// Sample conversation starters for demo
  static const List<String> sampleQuestions = [
    'hi',
    'nearest cafe',
    'survey',
    'restaurants',
    'feedback',
    'help',
  ];

  /// Demo instructions
  static const String demoInstructions = '''
🎯 Try these demo commands:

💬 Basic Chat:
• "hi" - Simple greeting
• "help" - Get assistance
• "joke" - Get a funny joke

❓ Yes/No Questions:
• "survey" - Participation question
• "feedback" - Satisfaction question
• "newsletter" - Subscription question

🏪 Suggestion Cards:
• "cafe" or "nearest cafe" - Coffee shops
• "restaurant" or "food" - Dining options

The agent will respond with interactive elements you can tap!
  ''';

  /// Quick demo responses
  static const Map<String, String> quickDemoResponses = {
    'demo': demoInstructions,
    'help demo': demoInstructions,
    'what can you do': demoInstructions,
    'examples': demoInstructions,
  };
}
