class Product {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String description;
  final double price;
  final double originalPrice;
  final int discountPercentage;
  final double rating;
  final int reviewCount;
  final String image;
  final String unit;
  final int stock;
  final bool isFeatured;
  final bool isPopular;
  final bool isNew;
  final List<String> highlights;
  final Map<String, String> specifications;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.discountPercentage,
    required this.rating,
    required this.reviewCount,
    required this.image,
    required this.unit,
    required this.stock,
    this.isFeatured = false,
    this.isPopular = false,
    this.isNew = false,
    this.highlights = const [],
    this.specifications = const {},
  });

  bool get inStock => stock > 0;
  bool get hasDiscount => discountPercentage > 0;
  double get savingsAmount => originalPrice - price;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num).toDouble(),
      discountPercentage: json['discountPercentage'] as int? ?? 0,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int? ?? 0,
      image: json['image'] as String? ?? '',
      unit: json['unit'] as String,
      stock: json['stock'] as int? ?? 10,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isPopular: json['isPopular'] as bool? ?? false,
      isNew: json['isNew'] as bool? ?? false,
      highlights: (json['highlights'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      specifications: (json['specifications'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v.toString()),
          ) ??
          {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'reviewCount': reviewCount,
      'image': image,
      'unit': unit,
      'stock': stock,
      'isFeatured': isFeatured,
      'isPopular': isPopular,
      'isNew': isNew,
      'highlights': highlights,
      'specifications': specifications,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? brand,
    String? category,
    String? description,
    double? price,
    double? originalPrice,
    int? discountPercentage,
    double? rating,
    int? reviewCount,
    String? image,
    String? unit,
    int? stock,
    bool? isFeatured,
    bool? isPopular,
    bool? isNew,
    List<String>? highlights,
    Map<String, String>? specifications,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      image: image ?? this.image,
      unit: unit ?? this.unit,
      stock: stock ?? this.stock,
      isFeatured: isFeatured ?? this.isFeatured,
      isPopular: isPopular ?? this.isPopular,
      isNew: isNew ?? this.isNew,
      highlights: highlights ?? this.highlights,
      specifications: specifications ?? this.specifications,
    );
  }
}
