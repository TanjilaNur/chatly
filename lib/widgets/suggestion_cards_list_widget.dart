import 'package:flutter/material.dart';
import '../models/suggestion_card_model.dart';
import '../constants/chat_dimensions.dart';
import '../constants/chat_theme.dart';
import '../enums/price_range.dart';
import '../widgets/suggestion_card_item.dart';

/// Horizontal scrollable list of suggestion cards following Flutter conventions
class SuggestionCardsListWidget extends StatelessWidget {
  const SuggestionCardsListWidget({
    super.key,
    required this.cards,
    this.onCardSelected,
  });

  final List<SuggestionCardModel> cards;
  final ValueChanged<SuggestionCardModel>? onCardSelected;

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: ChatDimensions.cardHeight,
      margin: const EdgeInsets.only(top: ChatDimensions.mediumSpacing),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: ChatDimensions.smallSpacing,
          vertical: ChatDimensions.mediumSpacing,
        ),
        itemCount: cards.length,
        separatorBuilder: (context, index) => const SizedBox(width: ChatDimensions.mediumSpacing),
        itemBuilder: (context, index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 200 + (index * 100)), // Staggered animation
            curve: Curves.easeOutBack,
            child: SuggestionCardItem(
              card: cards[index],
              gradientColors: _getGradientColors(index),
              onTap: () => onCardSelected?.call(cards[index]),
            ),
          );
        },
      ),
    );
  }

  /// Get gradient colors for each card based on index
  List<Color> _getGradientColors(int index) {
    const gradients = [
      [Color(0xFF64B5F6), Color(0xFF1976D2)], // Blue
      [Color(0xFFBA68C8), Color(0xFF7B1FA2)], // Purple
      [Color(0xFFFFB74D), Color(0xFFE65100)], // Orange
      [Color(0xFF81C784), Color(0xFF388E3C)], // Green
      [Color(0xFFE57373), Color(0xFFD32F2F)], // Red
    ];
    return gradients[index % gradients.length];
  }
}
