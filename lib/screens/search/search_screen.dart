import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/widgets/empty_state_view.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/floating_cart_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _currentQuery = '';

  static const List<String> _popularSearches = [
    'Milk',
    'Eggs',
    'Bread',
    'Chips',
    'Cold Drinks',
    'Fruits',
    'Maggi',
    'Shampoo',
    'Butter',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _currentQuery = query;
    });
    if (query.trim().isNotEmpty) {
      context.read<ProductProvider>().addRecentSearch(query.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final searchResults = _currentQuery.isEmpty
        ? []
        : productProvider.searchProducts(_currentQuery);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Container(
          height: 44,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: (val) {
              setState(() {
                _currentQuery = val;
              });
            },
            onSubmitted: _onSearch,
            style: AppTypography.bodyLarge,
            decoration: InputDecoration(
              hintText: 'Search for groceries, snacks, drinks...',
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
              suffixIcon: _currentQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _currentQuery = '';
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          _currentQuery.isEmpty
              ? _buildSuggestionsView(productProvider)
              : _buildResultsView(searchResults),
          const FloatingCartBar(bottomMargin: 16),
        ],
      ),
    );
  }

  Widget _buildSuggestionsView(ProductProvider provider) {
    final recents = provider.recentSearches;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches
          if (recents.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.history_rounded, size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      'Recent Searches',
                      style: AppTypography.headingSmall.copyWith(fontSize: 15),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    provider.clearRecentSearches();
                  },
                  child: Text(
                    'Clear',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recents.map((term) {
                return InputChip(
                  label: Text(term),
                  backgroundColor: Colors.white,
                  labelStyle: AppTypography.labelMedium.copyWith(color: AppColors.textPrimary),
                  deleteIcon: const Icon(Icons.close_rounded, size: 14),
                  onDeleted: () {
                    provider.removeRecentSearch(term);
                  },
                  onPressed: () {
                    _searchController.text = term;
                    _onSearch(term);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Popular Searches
          Row(
            children: [
              const Icon(Icons.trending_up_rounded, size: 18, color: AppColors.accent),
              const SizedBox(width: 6),
              Text(
                'Popular Searches',
                style: AppTypography.headingSmall.copyWith(fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _popularSearches.map((term) {
              return ActionChip(
                label: Text(term),
                backgroundColor: Colors.white,
                avatar: const Icon(Icons.search_rounded, size: 14, color: AppColors.primary),
                labelStyle: AppTypography.labelMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                onPressed: () {
                  _searchController.text = term;
                  _onSearch(term);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // Trending Categories
          Text(
            'Browse Categories',
            style: AppTypography.headingSmall.copyWith(fontSize: 15),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.categories.take(6).length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final cat = provider.categories[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.background,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: cat.imageUrl.isNotEmpty
                        ? Image.network(
                            cat.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.category_rounded, size: 20, color: AppColors.primary),
                          )
                        : const Icon(Icons.category_rounded, size: 20, color: AppColors.primary),
                  ),
                ),
                title: Text(cat.name, style: AppTypography.labelLarge),
                trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
                onTap: () {
                  _searchController.text = cat.name;
                  _onSearch(cat.name);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView(List<dynamic> results) {
    if (results.isEmpty) {
      return EmptyStateView(
        icon: Icons.search_off_rounded,
        title: 'No products found',
        description: 'We couldn\'t find anything matching "$_currentQuery". Try checking for typos or broader keywords.',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            'Search Results for "$_currentQuery" (${results.length})',
            style: AppTypography.headingSmall.copyWith(fontSize: 15),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 90),
            itemCount: results.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (context, index) {
              return ProductCard(
                product: results[index],
                width: double.infinity,
              );
            },
          ),
        ),
      ],
    );
  }
}
