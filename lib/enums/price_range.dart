import 'package:flutter/material.dart';

/// Enum for price ranges with proper typing
enum PriceRange {
  budget('\$'),
  moderate('\$\$'),
  expensive('\$\$\$'),
  luxury('\$\$\$\$');

  const PriceRange(this.symbol);
  final String symbol;

  /// Get price range from string
  static PriceRange? fromString(String? priceString) {
    if (priceString == null) return null;
    try {
      return PriceRange.values.firstWhere(
        (range) => range.symbol == priceString,
      );
    } catch (e) {
      return PriceRange.budget;
    }
  }
}

/// Extension for price range utilities
extension PriceRangeExtension on PriceRange {
  /// Get color associated with price range
  Color get color {
    switch (this) {
      case PriceRange.budget:
        return const Color(0xFF4CAF50); // Green
      case PriceRange.moderate:
        return const Color(0xFF2196F3); // Blue
      case PriceRange.expensive:
        return const Color(0xFFFF9800); // Orange
      case PriceRange.luxury:
        return const Color(0xFF9C27B0); // Purple
    }
  }

  /// Get description of price range
  String get description {
    switch (this) {
      case PriceRange.budget:
        return 'Budget-friendly';
      case PriceRange.moderate:
        return 'Moderately priced';
      case PriceRange.expensive:
        return 'Premium pricing';
      case PriceRange.luxury:
        return 'Luxury experience';
    }
  }
}
