import 'package:equatable/equatable.dart';
import '../enums/price_range.dart';

/// Data model for suggestion cards with validation and equatable
class SuggestionCardModel extends Equatable {
  final String id;
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final double? rating;
  final PriceRange? priceRange;
  final String? popularity;
  final Map<String, dynamic>? metadata;

  const SuggestionCardModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.rating,
    this.priceRange,
    this.popularity,
    this.metadata,
  });

  /// Factory constructor with validation
  factory SuggestionCardModel.create({
    required String id,
    required String title,
    String? subtitle,
    String? imageUrl,
    double? rating,
    PriceRange? priceRange,
    String? popularity,
    Map<String, dynamic>? metadata,
  }) {
    // Validation
    if (id.trim().isEmpty) {
      throw ArgumentError('ID cannot be empty');
    }
    if (title.trim().isEmpty) {
      throw ArgumentError('Title cannot be empty');
    }
    if (rating != null && (rating < 0 || rating > 5)) {
      throw ArgumentError('Rating must be between 0 and 5');
    }

    return SuggestionCardModel(
      id: id.trim(),
      title: title.trim(),
      subtitle: subtitle?.trim(),
      imageUrl: imageUrl?.trim(),
      rating: rating,
      priceRange: priceRange,
      popularity: popularity?.trim(),
      metadata: metadata,
    );
  }

  factory SuggestionCardModel.fromJson(Map<String, dynamic> json) {
    return SuggestionCardModel.create(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      imageUrl: json['imageUrl'] as String?,
      rating: json['rating'] as double?,
      priceRange: PriceRange.fromString(json['priceRange'] as String?),
      popularity: json['popularity'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'rating': rating,
      'priceRange': priceRange?.symbol,
      'popularity': popularity,
      'metadata': metadata,
    };
  }

  /// Check if the card has a valid rating
  bool get hasRating => rating != null && rating! > 0;

  /// Check if the card has a valid image
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  /// Get formatted rating string
  String get formattedRating => rating?.toStringAsFixed(1) ?? '0.0';

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        imageUrl,
        rating,
        priceRange,
        popularity,
        metadata,
      ];
}
