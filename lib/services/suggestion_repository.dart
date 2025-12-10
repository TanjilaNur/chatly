import '../models/suggestion_card_model.dart';
import '../enums/price_range.dart';

/// Repository for managing suggestion card data
class SuggestionRepository {
  SuggestionRepository._(); // Private constructor

  /// Get cafe suggestions
  static List<SuggestionCardModel> getCafeSuggestions() {
    return [
      SuggestionCardModel.create(
        id: 'cafe_1',
        title: 'Blue Bottle Coffee',
        subtitle: '0.2 miles away',
        rating: 4.5,
        priceRange: PriceRange.moderate,
        popularity: 'Very Popular',
      ),
      SuggestionCardModel.create(
        id: 'cafe_2',
        title: 'Starbucks Reserve',
        subtitle: '0.3 miles away',
        rating: 4.2,
        priceRange: PriceRange.expensive,
        popularity: 'Popular',
      ),
      SuggestionCardModel.create(
        id: 'cafe_3',
        title: 'Local Grounds',
        subtitle: '0.5 miles away',
        rating: 4.7,
        priceRange: PriceRange.budget,
        popularity: 'Hidden Gem',
      ),
      SuggestionCardModel.create(
        id: 'cafe_4',
        title: 'Artisan Roasters',
        subtitle: '0.6 miles away',
        rating: 4.4,
        priceRange: PriceRange.moderate,
        popularity: 'Trending',
      ),
      SuggestionCardModel.create(
        id: 'cafe_5',
        title: 'Morning Brew',
        subtitle: '0.8 miles away',
        rating: 4.6,
        priceRange: PriceRange.budget,
        popularity: 'Local Favorite',
      ),
    ];
  }

  /// Get restaurant suggestions
  static List<SuggestionCardModel> getRestaurantSuggestions() {
    return [
      SuggestionCardModel.create(
        id: 'restaurant_1',
        title: 'The Italian Corner',
        subtitle: '0.4 miles away',
        rating: 4.6,
        priceRange: PriceRange.expensive,
        popularity: 'Highly Rated',
      ),
      SuggestionCardModel.create(
        id: 'restaurant_2',
        title: 'Sushi Zen',
        subtitle: '0.7 miles away',
        rating: 4.8,
        priceRange: PriceRange.luxury,
        popularity: 'Premium',
      ),
      SuggestionCardModel.create(
        id: 'restaurant_3',
        title: 'Burger Palace',
        subtitle: '0.3 miles away',
        rating: 4.3,
        priceRange: PriceRange.moderate,
        popularity: 'Family Friendly',
      ),
      SuggestionCardModel.create(
        id: 'restaurant_4',
        title: 'Garden Bistro',
        subtitle: '0.9 miles away',
        rating: 4.5,
        priceRange: PriceRange.expensive,
        popularity: 'Romantic',
      ),
    ];
  }

  /// Get suggestions by type
  static List<SuggestionCardModel> getSuggestionsByType(String type) {
    switch (type.toLowerCase()) {
      case 'cafe':
      case 'cafes':
      case 'coffee':
        return getCafeSuggestions();
      case 'restaurant':
      case 'restaurants':
      case 'food':
        return getRestaurantSuggestions();
      default:
        return [];
    }
  }
}
