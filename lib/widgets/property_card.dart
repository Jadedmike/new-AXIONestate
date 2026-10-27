import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/property.dart';
import 'glass_container.dart';

class PropertyCard extends StatefulWidget {
  final Property property;
  final VoidCallback? onTap;

  const PropertyCard({
    super.key,
    required this.property,
    this.onTap,
  });

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  bool _isFavorite = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final prop = widget.property;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
        child: GlassContainer(
          borderRadius: BorderRadius.circular(22),
          // Specification 2: Glassmorphism translucent ivory fill
          color: AppColors.warmIvory.withValues(alpha: 0.70),
          blurSigma: 16.0,
          border: Border.all(
            color: _isHovered
                ? AppColors.iceBlue.withValues(alpha: 0.70)
                : AppColors.iceBlue.withValues(alpha: 0.35),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.mochaBrown.withValues(alpha: _isHovered ? 0.14 : 0.07),
              blurRadius: _isHovered ? 36 : 24,
              offset: Offset(0, _isHovered ? 12 : 6),
            ),
          ],
          child: InkWell(
            onTap: widget.onTap ?? () {
              Navigator.of(context).pushNamed(
                '/properties/detail',
                arguments: prop,
              );
            },
            borderRadius: BorderRadius.circular(22),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Hug content tightly
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Specification 2: Image in 16:9 Aspect Ratio without stretching
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                        child: Image.network(
                          prop.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: AppColors.warmSand,
                            child: const Center(
                              child: Icon(Icons.apartment, size: 44, color: AppColors.iceBlue),
                            ),
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: AppColors.warmSand,
                              child: const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          },
                        ),
                      ),

                      // Top Gradient for badge readability
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.center,
                            colors: [
                              Colors.black.withValues(alpha: 0.35),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),

                      // Badges (Top Right in RTL)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.mochaBrown.withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.iceBlue.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Text(
                                prop.dealType == 'sale' ? 'للبيع' : 'للإيجار',
                                style: const TextStyle(
                                  color: AppColors.warmIvory,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (prop.isOffer)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.iceBlue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.local_fire_department, size: 12, color: AppColors.mochaBrown),
                                    SizedBox(width: 3),
                                    Text(
                                      'عرض خاص',
                                      style: TextStyle(
                                        color: AppColors.mochaBrown,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (prop.badgeHighlight != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.warmIvory.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  prop.badgeHighlight!,
                                  style: const TextStyle(
                                    color: AppColors.mochaBrown,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Favorite Button (Top Left in RTL)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _isFavorite = !_isFavorite);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(milliseconds: 1000),
                                content: Text(
                                  _isFavorite ? 'تمت إضافة العقار للمفضلة' : 'تمت الإزالة من المفضلة',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.warmIvory.withValues(alpha: 0.85),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.iceBlue.withValues(alpha: 0.4),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Icon(
                              _isFavorite ? Icons.favorite : Icons.favorite_border,
                              size: 16,
                              color: _isFavorite ? AppColors.error : AppColors.mochaBrown,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Card Body Content (Tight padding, no excessive gaps)
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location & Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Icon(Icons.pin_drop, size: 14, color: AppColors.mochaBrown),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    prop.location,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: AppColors.mochaBrown.withValues(alpha: 0.75),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            prop.price,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mochaBrown,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Title
                      Text(
                        prop.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.mochaBrown,
                          height: 1.25,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Features bar (Area, Bedrooms, Bathrooms)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.warmSand.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.iceBlue.withValues(alpha: 0.30),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildFeature(Icons.square_foot, prop.area),
                            _buildFeature(Icons.bed, '${prop.bedrooms} غرف'),
                            _buildFeature(Icons.bathtub, '${prop.bathrooms} حمام'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.mochaBrown),
        const SizedBox(width: 3),
        Text(
          text,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: AppColors.mochaBrown,
          ),
        ),
      ],
    );
  }
}
