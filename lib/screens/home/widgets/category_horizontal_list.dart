import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/routes/app_routes.dart';
import '../../../providers/product_provider.dart';

class CategoryHorizontalList extends StatelessWidget {
  const CategoryHorizontalList({super.key});

  static final List<List<Color>> _categoryGradients = [
    [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)], // Green
    [const Color(0xFFE1F5FE), const Color(0xFFB3E5FC)], // Blue
    [const Color(0xFFFFF3E0), const Color(0xFFFFE0B2)], // Orange
    [const Color(0xFFF3E5F5), const Color(0xFFE1BEE7)], // Purple
    [const Color(0xFFFFEBEE), const Color(0xFFFFCDD2)], // Red/Pink
    [const Color(0xFFFFFDE7), const Color(0xFFFFF9C4)], // Yellow
    [const Color(0xFFE0F2F1), const Color(0xFFB2DFDB)], // Teal
    [const Color(0xFFEDE7F6), const Color(0xFFD1C4E9)], // Deep Purple
    [const Color(0xFFE0F7FA), const Color(0xFFB2EBF2)], // Cyan
    [const Color(0xFFFCE4EC), const Color(0xFFF8BBD0)], // Pink
    [const Color(0xFFFFF8E1), const Color(0xFFFFECB3)], // Amber
    [const Color(0xFFE8EAF6), const Color(0xFFC5CAE9)], // Indigo
  ];

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<ProductProvider>().categories;

    return SizedBox(
      height: 104,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final gradientColors = _categoryGradients[index % _categoryGradients.length];

          return InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              Navigator.pushNamed(
                context,
                AppRoutes.categoryProducts,
                arguments: cat.name,
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: cat.imageUrl.isNotEmpty
                        ? Image.network(
                            cat.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: gradientColors.first,
                              child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 24),
                            ),
                          )
                        : Container(
                            color: gradientColors.first,
                            child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 24),
                          ),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 72,
                  child: Text(
                    cat.name,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelSmall.copyWith(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                      color: AppColors.textPrimary,
                    ),
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
