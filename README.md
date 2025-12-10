# Chatly - Code Structure

## Project Structure Following Flutter Best Practices

### 📁 Core Folders
C
#### `/constants/`
- `app_constants.dart` - Application-wide constants
- `chat_dimensions.dart` - UI dimension constants
- `chat_theme.dart` - Theme and styling constants

#### `/controllers/`
- `chat_controller_improved.dart` - Improved chat state management with proper error handling
- `chat_controller.dart` - Legacy controller (to be deprecated)

#### `/enums/`
- `message_type.dart` - Enum for different message types (text, yes/no, suggestions)
- `price_range.dart` - Enum for price ranges with color coding

#### `/exceptions/`
- `chat_exceptions.dart` - Custom exception classes for error handling

#### `/models/`
- `chat_message_model.dart` - Improved message model with Equatable
- `suggestion_card_model.dart` - Card model with validation and Equatable
- `agent_response_model.dart` - Agent response model with factory methods

#### `/services/`
- `chat_agent_service_improved.dart` - Modular agent service with proper error handling
- `suggestion_repository.dart` - Data repository for suggestions
- `chat_agent_service.dart` - Legacy service (to be deprecated)

#### `/utils/`
- `chat_utils.dart` - Utility functions for common operations
- `chat_validators.dart` - Validation utilities
- `extensions.dart` - Dart extensions for common operations

#### `/widgets/`
- `message_screen_widget.dart` - Main chat screen with improved structure
- `message_bubble_widget.dart` - Individual message bubble
- `suggestion_cards_list_widget.dart` - Horizontal scrollable cards
- `suggestion_card_item.dart` - Individual card component
- `chat_header_widget.dart` - Reusable header component
- `chat_input_widget.dart` - Input field with send button
- `thinking_indicator_widget.dart` - Loading indicator
- `yes_no_buttons_widget.dart` - Reusable button component

## 🎯 Features

### Yes/No Questions
- Agent can ask questions requiring yes/no responses
- Responses appear as user messages
- Neutral button styling

### Suggestion Cards
- Horizontal scrollable cards for multiple options
- Rich visual design with gradients and badges
- Rating, price range, and popularity indicators
- Selections appear as user messages

### Interactive Elements
- Touch feedback and animations
- Auto-scroll to new messages
- Proper error handling and validation

## 📝 Coding Conventions Applied

1. **Naming Conventions**
   - Classes: PascalCase (e.g., `ChatMessageModel`)
   - Variables/Methods: camelCase (e.g., `isFromUser`)
   - Constants: camelCase (e.g., `defaultDelay`)
   - Private members: leading underscore (e.g., `_handleError`)

2. **File Organization**
   - Feature-based grouping
   - Single responsibility principle
   - Proper imports and exports

3. **Error Handling**
   - Custom exception classes
   - Proper try-catch blocks
   - User-friendly error messages

4. **Code Quality**
   - Equatable for object comparison
   - Immutable models
   - Factory constructors with validation
   - Extension methods for common operations

5. **Widget Best Practices**
   - Stateless widgets where possible
   - Proper key usage
   - Separated build methods
   - Reusable components
