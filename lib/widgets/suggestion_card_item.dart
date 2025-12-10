import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/suggestion_card_model.dart';
import '../constants/chat_dimensions.dart';
import '../enums/price_range.dart';

/// Individual suggestion card item widget
class SuggestionCardItem extends StatelessWidget {
  const SuggestionCardItem({
    super.key,
    required this.card,
    required this.gradientColors,
    this.onTap,
  });

  final SuggestionCardModel card;
  final List<Color> gradientColors;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ChatDimensions.cardWidth,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact(); // Add haptic feedback
          onTap?.call();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ChatDimensions.cardBorderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ChatDimensions.cardBorderRadius),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Color(0xFFF8F9FA)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageSection(),
                  _buildContentSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: ChatDimensions.cardImageHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Stack(
        children: [
          // Image or placeholder
          if (card.hasImage)
            Image.network(
              card.imageUrl!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildPlaceholderIcon(),
            )
          else
            _buildPlaceholderIcon(),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                ],
              ),
            ),
          ),

          // Rating badge
          if (card.hasRating) _buildRatingBadge(),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(ChatDimensions.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTitleSection(),
            _buildInfoSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          card.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (card.subtitle != null) ...[
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: ChatDimensions.smallIconSize,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  card.subtitle!,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildInfoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Price range badge
        if (card.priceRange != null) _buildPriceBadge(),

        // Popularity badge
        if (card.popularity != null) _buildPopularityBadge(),
      ],
    );
  }

  Widget _buildPlaceholderIcon() {
    return Center(
      child: Icon(
        Icons.local_cafe,
        size: ChatDimensions.largeIconSize,
        color: Colors.white.withValues(alpha: 0.8),
      ),
    );
  }

  Widget _buildRatingBadge() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star,
              size: ChatDimensions.smallIconSize,
              color: Colors.amber[400],
            ),
            const SizedBox(width: 2),
            Text(
              card.formattedRating,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: card.priceRange!.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: card.priceRange!.color.withValues(alpha: 0.3)),
      ),
      child: Text(
        card.priceRange!.symbol,
        style: TextStyle(
          fontSize: 10,
          color: card.priceRange!.color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPopularityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _getPopularityColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        card.popularity!,
        style: TextStyle(
          fontSize: 8,
          color: _getPopularityColor(),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getPopularityColor() {
    switch (card.popularity?.toLowerCase()) {
      case 'very popular':
        return Colors.red[600]!;
      case 'popular':
        return Colors.orange[600]!;
      case 'trending':
        return Colors.purple[600]!;
      case 'hidden gem':
        return Colors.blue[600]!;
      case 'local favorite':
        return Colors.green[600]!;
      default:
        return Colors.grey[600]!;
    }
  }
}
