import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../data/mock_recipes.dart';
import '../../../models/recipe_item.dart';
import '../../../providers/cart_provider.dart';

class RecipeKitsSection extends StatelessWidget {
  const RecipeKitsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final recipes = MockRecipes.getRecipes();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 245,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            scrollDirection: Axis.horizontal,
            itemCount: recipes.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return _buildRecipeCard(context, recipe);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeCard(BuildContext context, RecipeItem recipe) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        _showRecipeDetailModal(context, recipe);
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
              child: Stack(
                children: [
                  Image.network(
                    recipe.imageUrl,
                    height: 115,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 115,
                      color: AppColors.primarySubtle,
                      child: const Icon(Icons.restaurant_menu_rounded,
                          color: AppColors.primary),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.timer_outlined,
                              size: 11, color: Colors.white),
                          const SizedBox(width: 3),
                          Text(
                            recipe.cookTime,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.successDark,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${recipe.calories} kcal',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelLarge.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    recipe.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${recipe.requiredIngredients.length} ingredients',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 11.5,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Cook Now',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded,
                              size: 16, color: AppColors.primary),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRecipeDetailModal(BuildContext context, RecipeItem recipe) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _RecipeDetailSheet(recipe: recipe),
    );
  }
}

class _RecipeDetailSheet extends StatefulWidget {
  final RecipeItem recipe;

  const _RecipeDetailSheet({required this.recipe});

  @override
  State<_RecipeDetailSheet> createState() => _RecipeDetailSheetState();
}

class _RecipeDetailSheetState extends State<_RecipeDetailSheet> {
  late Set<String> _selectedProductIds;

  @override
  void initState() {
    super.initState();
    _selectedProductIds =
        widget.recipe.requiredIngredients.map((p) => p.id).toSet();
  }

  double get _selectedTotal {
    return widget.recipe.requiredIngredients
        .where((p) => _selectedProductIds.contains(p.id))
        .fold(0.0, (sum, p) => sum + p.price);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.read<CartProvider>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header Image with close button
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                child: Image.network(
                  widget.recipe.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: AppColors.primarySubtle,
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: CircleAvatar(
                  backgroundColor: Colors.black.withValues(alpha: 0.5),
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 16,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.timer_outlined,
                              size: 13, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            widget.recipe.cookTime,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${widget.recipe.calories} Calories',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.recipe.title,
                    style: AppTypography.headingLarge.copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.recipe.description,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const Divider(height: 28),

                  // Ingredients Section with checkboxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Required Ingredients (${widget.recipe.requiredIngredients.length})',
                        style: AppTypography.headingSmall,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            if (_selectedProductIds.length ==
                                widget.recipe.requiredIngredients.length) {
                              _selectedProductIds.clear();
                            } else {
                              _selectedProductIds = widget
                                  .recipe.requiredIngredients
                                  .map((p) => p.id)
                                  .toSet();
                            }
                          });
                        },
                        child: Text(
                          _selectedProductIds.length ==
                                  widget.recipe.requiredIngredients.length
                              ? 'Deselect All'
                              : 'Select All',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ...widget.recipe.requiredIngredients.map((p) {
                    final isChecked = _selectedProductIds.contains(p.id);
                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (isChecked) {
                            _selectedProductIds.remove(p.id);
                          } else {
                            _selectedProductIds.add(p.id);
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Checkbox(
                              value: isChecked,
                              activeColor: AppColors.primary,
                              onChanged: (val) {
                                setState(() {
                                  if (val == true) {
                                    _selectedProductIds.add(p.id);
                                  } else {
                                    _selectedProductIds.remove(p.id);
                                  }
                                });
                              },
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.name,
                                    style: AppTypography.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    p.unit,
                                    style: AppTypography.bodySmall.copyWith(
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              Formatters.formatCurrency(p.price),
                              style: AppTypography.labelLarge.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const Divider(height: 28),

                  // Steps Section
                  Text('Quick Recipe Instructions',
                      style: AppTypography.headingSmall),
                  const SizedBox(height: 10),
                  ...widget.recipe.steps.asMap().entries.map((entry) {
                    final stepIndex = entry.key + 1;
                    final stepText = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primarySubtle,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$stepIndex',
                                style: const TextStyle(
                                  color: AppColors.primaryDark,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              stepText,
                              style: AppTypography.bodyMedium.copyWith(
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Bottom Bar CTA
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.borderLight)),
            ),
            child: SafeArea(
              child: CustomButton(
                text: _selectedProductIds.isEmpty
                    ? 'Select at least 1 item'
                    : 'Add ${_selectedProductIds.length} Ingredients (${Formatters.formatCurrency(_selectedTotal)})',
                icon: Icons.add_shopping_cart_rounded,
                backgroundColor: AppColors.primary,
                onPressed: _selectedProductIds.isEmpty
                    ? null
                    : () {
                        for (final p in widget.recipe.requiredIngredients) {
                          if (_selectedProductIds.contains(p.id)) {
                            cartProvider.addItem(p);
                          }
                        }
                        Navigator.pop(context);
                        ToastUtils.showSuccess(
                          context,
                          'Added ${_selectedProductIds.length} ingredients to your basket!',
                        );
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
