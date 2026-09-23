import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../providers/product_provider.dart';

class FilterSortBottomSheet extends StatefulWidget {
  final String categoryName;

  const FilterSortBottomSheet({
    super.key,
    required this.categoryName,
  });

  @override
  State<FilterSortBottomSheet> createState() => _FilterSortBottomSheetState();
}

class _FilterSortBottomSheetState extends State<FilterSortBottomSheet> {
  late ProductSortOption _selectedSort;
  late double _maxPrice;
  late Set<String> _selectedBrands;
  late double _minRating;
  late int _minDiscount;
  late bool _inStockOnly;

  @override
  void initState() {
    super.initState();
    final provider = context.read<ProductProvider>();
    _selectedSort = provider.currentSort;
    _maxPrice = provider.currentFilters.maxPrice;
    _selectedBrands = Set.from(provider.currentFilters.selectedBrands);
    _minRating = provider.currentFilters.minRating;
    _minDiscount = provider.currentFilters.minDiscount;
    _inStockOnly = provider.currentFilters.inStockOnly;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Title Row with Reset
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter & Sort',
                    style: AppTypography.headingLarge,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedSort = ProductSortOption.popular;
                        _maxPrice = 1000;
                        _selectedBrands.clear();
                        _minRating = 0;
                        _minDiscount = 0;
                        _inStockOnly = false;
                      });
                    },
                    child: Text(
                      'Reset All',
                      style: AppTypography.labelLarge.copyWith(color: AppColors.error),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),

              // Sort Section
              Text('Sort By', style: AppTypography.headingSmall),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildSortChip('Popular', ProductSortOption.popular, icon: Icons.trending_up_rounded),
                  _buildSortChip('Price: Low to High', ProductSortOption.priceLowHigh, icon: Icons.arrow_upward_rounded),
                  _buildSortChip('Price: High to Low', ProductSortOption.priceHighLow, icon: Icons.arrow_downward_rounded),
                  _buildSortChip('Highest Rated', ProductSortOption.rating, icon: Icons.star_rounded),
                  _buildSortChip('Max Discount', ProductSortOption.discount, icon: Icons.discount_rounded),
                ],
              ),
              const SizedBox(height: 20),

              // Price Range Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Max Price', style: AppTypography.headingSmall),
                  Text('Up to ₹${_maxPrice.toInt()}',
                      style: AppTypography.labelLarge.copyWith(color: AppColors.primary)),
                ],
              ),
              Slider(
                value: _maxPrice,
                min: 20,
                max: 1000,
                divisions: 20,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.border,
                onChanged: (val) {
                  setState(() {
                    _maxPrice = val;
                  });
                },
              ),
              const SizedBox(height: 14),

              // Rating Filter
              Text('Minimum Rating', style: AppTypography.headingSmall),
              const SizedBox(height: 8),
              Row(
                children: [0.0, 4.0, 4.5, 4.8].map((r) {
                  final isSelected = _minRating == r;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      avatar: r > 0
                          ? Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: isSelected ? Colors.white : AppColors.ratingStar,
                            )
                          : null,
                      label: Text(r == 0.0 ? 'All' : '$r+'),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.background,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) {
                        setState(() {
                          _minRating = r;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // In-Stock Toggle
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('In Stock Only', style: AppTypography.headingSmall),
                value: _inStockOnly,
                activeTrackColor: AppColors.primary,
                onChanged: (val) {
                  setState(() {
                    _inStockOnly = val;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Apply Filters Button
              CustomButton(
                text: 'Apply Filters',
                onPressed: () {
                  provider.setSortOption(_selectedSort);
                  provider.setFilters(ProductFilterOptions(
                    maxPrice: _maxPrice,
                    selectedBrands: _selectedBrands,
                    minRating: _minRating,
                    minDiscount: _minDiscount,
                    inStockOnly: _inStockOnly,
                  ));
                  Navigator.pop(context);
                },
                backgroundColor: AppColors.primary,
                height: AppDimensions.buttonHeightLg,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortChip(String label, ProductSortOption option, {IconData? icon}) {
    final isSelected = _selectedSort == option;
    return ChoiceChip(
      avatar: icon != null
          ? Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : AppColors.primary,
            )
          : null,
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.background,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      onSelected: (_) {
        setState(() {
          _selectedSort = option;
        });
      },
    );
  }
}
