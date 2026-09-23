import 'package:flutter/foundation.dart' hide Category;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../data/mock_products.dart';
import '../data/mock_categories.dart';

enum ProductSortOption {
  popular,
  priceLowHigh,
  priceHighLow,
  rating,
  discount,
}

class ProductFilterOptions {
  final double minPrice;
  final double maxPrice;
  final Set<String> selectedBrands;
  final double minRating;
  final int minDiscount;
  final bool inStockOnly;

  const ProductFilterOptions({
    this.minPrice = 0,
    this.maxPrice = 1000,
    this.selectedBrands = const {},
    this.minRating = 0,
    this.minDiscount = 0,
    this.inStockOnly = false,
  });

  ProductFilterOptions copyWith({
    double? minPrice,
    double? maxPrice,
    Set<String>? selectedBrands,
    double? minRating,
    int? minDiscount,
    bool? inStockOnly,
  }) {
    return ProductFilterOptions(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      selectedBrands: selectedBrands ?? this.selectedBrands,
      minRating: minRating ?? this.minRating,
      minDiscount: minDiscount ?? this.minDiscount,
      inStockOnly: inStockOnly ?? this.inStockOnly,
    );
  }
}

class ProductProvider extends ChangeNotifier {
  List<Product> _allProducts = [];
  List<Category> _categories = [];
  List<String> _recentSearches = [];
  ProductSortOption _currentSort = ProductSortOption.popular;
  ProductFilterOptions _currentFilters = const ProductFilterOptions();

  static const String _recentSearchesKey = 'quickbasket_recent_searches';

  ProductProvider() {
    _initData();
  }

  void _initData() {
    _allProducts = List.from(MockProducts.products);
    _categories = List.from(MockCategories.categories);
    _loadRecentSearches();
  }

  List<Product> get allProducts => _allProducts;
  List<Category> get categories => _categories;
  List<String> get recentSearches => _recentSearches;
  ProductSortOption get currentSort => _currentSort;
  ProductFilterOptions get currentFilters => _currentFilters;

  List<Product> get featuredProducts =>
      _allProducts.where((p) => p.isFeatured).toList();

  List<Product> get popularProducts =>
      _allProducts.where((p) => p.isPopular).toList();

  List<Product> get flashDeals =>
      _allProducts.where((p) => p.discountPercentage >= 15).toList();

  List<Product> get under99Products =>
      _allProducts.where((p) => p.price <= 99).toList();

  List<Product> getProductsByCategory(String categoryName) {
    return _allProducts
        .where((p) => p.category.toLowerCase().contains(categoryName.toLowerCase()) ||
            categoryName.toLowerCase().contains(p.category.toLowerCase()))
        .toList();
  }

  Product? getProductById(String id) {
    try {
      return _allProducts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  List<String> getAvailableBrandsForCategory(String categoryName) {
    final prods = getProductsByCategory(categoryName);
    return prods.map((p) => p.brand).toSet().toList();
  }

  // Filtered & Sorted search results
  List<Product> searchProducts(String query) {
    if (query.trim().isEmpty) return [];
    final cleanQuery = query.toLowerCase().trim();
    return _allProducts.where((p) {
      final matchName = p.name.toLowerCase().contains(cleanQuery);
      final matchBrand = p.brand.toLowerCase().contains(cleanQuery);
      final matchCategory = p.category.toLowerCase().contains(cleanQuery);
      final matchDesc = p.description.toLowerCase().contains(cleanQuery);
      return matchName || matchBrand || matchCategory || matchDesc;
    }).toList();
  }

  List<Product> getFilteredCategoryProducts(String categoryName) {
    var list = getProductsByCategory(categoryName);

    // Apply Filter Options
    list = list.where((p) {
      if (p.price < _currentFilters.minPrice || p.price > _currentFilters.maxPrice) {
        return false;
      }
      if (_currentFilters.selectedBrands.isNotEmpty &&
          !_currentFilters.selectedBrands.contains(p.brand)) {
        return false;
      }
      if (p.rating < _currentFilters.minRating) {
        return false;
      }
      if (p.discountPercentage < _currentFilters.minDiscount) {
        return false;
      }
      if (_currentFilters.inStockOnly && !p.inStock) {
        return false;
      }
      return true;
    }).toList();

    // Apply Sorting
    switch (_currentSort) {
      case ProductSortOption.popular:
        list.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
      case ProductSortOption.priceLowHigh:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSortOption.priceHighLow:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSortOption.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ProductSortOption.discount:
        list.sort((a, b) => b.discountPercentage.compareTo(a.discountPercentage));
        break;
    }

    return list;
  }

  // Recommended Products logic
  List<Product> getRecommendedProducts(Product product) {
    final name = product.name.toLowerCase();
    final cat = product.category.toLowerCase();

    if (name.contains('milk') || cat.contains('dairy')) {
      return _allProducts.where((p) {
        final n = p.name.toLowerCase();
        return (n.contains('bread') ||
                n.contains('butter') ||
                n.contains('egg') ||
                n.contains('flake') ||
                n.contains('cheese')) &&
            p.id != product.id;
      }).take(4).toList();
    }

    if (name.contains('chip') || name.contains('lay') || cat.contains('snack')) {
      return _allProducts.where((p) {
        final n = p.name.toLowerCase();
        return (n.contains('coca') ||
                n.contains('pepsi') ||
                n.contains('sprite') ||
                n.contains('chocolate') ||
                n.contains('nacho') ||
                n.contains('popcorn')) &&
            p.id != product.id;
      }).take(4).toList();
    }

    if (cat.contains('fruit') || cat.contains('veg')) {
      return _allProducts
          .where((p) => p.category.toLowerCase().contains('fruit') && p.id != product.id)
          .take(4)
          .toList();
    }

    return _allProducts
        .where((p) => p.category == product.category && p.id != product.id)
        .take(4)
        .toList();
  }

  void setSortOption(ProductSortOption option) {
    _currentSort = option;
    notifyListeners();
  }

  void setFilters(ProductFilterOptions filters) {
    _currentFilters = filters;
    notifyListeners();
  }

  void resetFilters() {
    _currentFilters = const ProductFilterOptions();
    _currentSort = ProductSortOption.popular;
    notifyListeners();
  }

  void addRecentSearch(String term) {
    final clean = term.trim();
    if (clean.isEmpty) return;
    _recentSearches.remove(clean);
    _recentSearches.insert(0, clean);
    if (_recentSearches.length > 10) {
      _recentSearches = _recentSearches.sublist(0, 10);
    }
    _saveRecentSearches();
    notifyListeners();
  }

  void removeRecentSearch(String term) {
    _recentSearches.remove(term);
    _saveRecentSearches();
    notifyListeners();
  }

  void clearRecentSearches() {
    _recentSearches.clear();
    _saveRecentSearches();
    notifyListeners();
  }

  Future<void> _saveRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_recentSearchesKey, _recentSearches);
    } catch (e) {
      debugPrint('Error saving recent searches: $e');
    }
  }

  Future<void> _loadRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_recentSearchesKey);
      if (list != null && list.isNotEmpty) {
        _recentSearches = list;
      } else {
        _recentSearches = ['Milk', 'Maggi', 'Apples', 'Bread', 'Chocolate'];
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading recent searches: $e');
    }
  }
}
