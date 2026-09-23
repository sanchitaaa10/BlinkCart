import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/product_provider.dart';
import '../../widgets/floating_cart_bar.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  static final List<List<Color>> _cardGradients = [
    [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)], // Green
    [const Color(0xFFE1F5FE), const Color(0xFFB3E5FC)], // Blue
    [const Color(0xFFFFF3E0), const Color(0xFFFFE0B2)], // Orange
    [const Color(0xFFF3E5F5), const Color(0xFFE1BEE7)], // Purple
    [const Color(0xFFFFEBEE), const Color(0xFFFFCDD2)], // Red
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('All Categories', style: AppTypography.headingLarge),
            Text(
              '${categories.length} departments delivered in 10 mins',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: AppColors.primary),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.search);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GridView.builder(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 90),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final cat = categories[index];
              final gradient = _cardGradients[index % _cardGradients.length];

              return InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.pushNamed(
                    context,
                    AppRoutes.categoryProducts,
                    arguments: cat.name,
                  );
                },
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.borderLight, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: gradient.first.withValues(alpha: 0.4),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: cat.imageUrl.isNotEmpty
                              ? Image.network(
                                  cat.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: gradient.first,
                                    child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 24),
                                  ),
                                )
                              : Container(
                                  color: gradient.first,
                                  child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 24),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        cat.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelLarge.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const FloatingCartBar(bottomMargin: 16),
        ],
      ),
    );
  }
}
