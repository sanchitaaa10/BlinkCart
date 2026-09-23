class Category {
  final String id;
  final String name;
  final String icon;
  final String emoji;
  final String imageUrl;
  final int productCount;
  final String bannerText;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    this.emoji = '',
    this.imageUrl = '',
    this.productCount = 0,
    this.bannerText = '',
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      productCount: json['productCount'] as int? ?? 0,
      bannerText: json['bannerText'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'emoji': emoji,
      'imageUrl': imageUrl,
      'productCount': productCount,
      'bannerText': bannerText,
    };
  }
}
