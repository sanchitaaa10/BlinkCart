import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/routes/app_routes.dart';

class StoryItem {
  final String title;
  final String tag;
  final String imageUrl;
  final String category;
  final List<Color> ringGradient;

  const StoryItem({
    required this.title,
    required this.tag,
    required this.imageUrl,
    required this.category,
    required this.ringGradient,
  });
}

class DailyStoriesBar extends StatelessWidget {
  const DailyStoriesBar({super.key});

  static const List<StoryItem> _stories = [
    StoryItem(
      title: 'Deals',
      tag: '50% OFF',
      imageUrl: 'https://images.unsplash.com/photo-1610348725531-843dff563e2c?auto=format&fit=crop&w=200&q=80',
      category: 'Fruits & Vegetables',
      ringGradient: [Color(0xFFFF1744), Color(0xFFFF9100)],
    ),
    StoryItem(
      title: 'Mango Fest',
      tag: 'Ratnagiri',
      imageUrl: 'https://images.unsplash.com/photo-1553279768-865429fa0078?auto=format&fit=crop&w=200&q=80',
      category: 'Fruits & Vegetables',
      ringGradient: [Color(0xFFFFB300), Color(0xFFFF6F00)],
    ),
    StoryItem(
      title: 'Dairy Pure',
      tag: 'Fresh',
      imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?auto=format&fit=crop&w=200&q=80',
      category: 'Dairy & Breakfast',
      ringGradient: [Color(0xFF00C6FF), Color(0xFF0072FF)],
    ),
    StoryItem(
      title: 'Chocolates',
      tag: 'Treats',
      imageUrl: 'https://images.unsplash.com/photo-1511381939415-e44015466834?auto=format&fit=crop&w=200&q=80',
      category: 'Snacks & Munchies',
      ringGradient: [Color(0xFF8E24AA), Color(0xFFE91E63)],
    ),
    StoryItem(
      title: 'Cold Drinks',
      tag: 'Chilled',
      imageUrl: 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?auto=format&fit=crop&w=200&q=80',
      category: 'Cold Drinks & Juices',
      ringGradient: [Color(0xFF00B0FF), Color(0xFF00E5FF)],
    ),
    StoryItem(
      title: 'Munchies',
      tag: 'Crunch',
      imageUrl: 'https://images.unsplash.com/photo-1566478989037-eec170784d0b?auto=format&fit=crop&w=200&q=80',
      category: 'Snacks & Munchies',
      ringGradient: [Color(0xFFFF6D00), Color(0xFFFFAB00)],
    ),
    StoryItem(
      title: 'Farm Fresh',
      tag: 'Organic',
      imageUrl: 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?auto=format&fit=crop&w=200&q=80',
      category: 'Fruits & Vegetables',
      ringGradient: [Color(0xFF00C853), Color(0xFF69F0AE)],
    ),
    StoryItem(
      title: 'Instant Food',
      tag: '2-Min',
      imageUrl: 'https://images.unsplash.com/photo-1612927601601-6638404737ce?auto=format&fit=crop&w=200&q=80',
      category: 'Instant Food',
      ringGradient: [Color(0xFFFF5252), Color(0xFFFF7A00)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: const EdgeInsets.symmetric(vertical: 6),
      color: Colors.white,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _stories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final story = _stories[index];
          return InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              Navigator.pushNamed(
                context,
                AppRoutes.categoryProducts,
                arguments: story.category,
              );
            },
            borderRadius: BorderRadius.circular(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Story Circle with Real Photo & Gradient Ring
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: story.ringGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: story.ringGradient.first.withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: Container(
                        width: 52,
                        height: 52,
                        color: Colors.white,
                        child: Image.network(
                          story.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: AppColors.primarySubtle,
                            child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 22),
                          ),
                        ),
                      ),
                    ),
                    // Small floating badge
                    Positioned(
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: story.ringGradient.first,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white, width: 1.2),
                        ),
                        child: Text(
                          story.tag,
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white,
                            fontSize: 7.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // Title
                Text(
                  story.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
