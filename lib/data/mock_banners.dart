import 'package:flutter/material.dart';

class PromoBanner {
  final String id;
  final String title;
  final String subtitle;
  final String highlight;
  final String ctaText;
  final String? promoCode;
  final List<Color> gradientColors;
  final IconData? icon;
  final String targetCategory;
  final String? imageUrl;
  final String? badgeText;

  const PromoBanner({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.highlight,
    required this.ctaText,
    this.promoCode,
    required this.gradientColors,
    this.icon,
    required this.targetCategory,
    this.imageUrl,
    this.badgeText,
  });
}

class MockBanners {
  static const List<PromoBanner> banners = [
    PromoBanner(
      id: 'banner-1',
      title: 'SUPER SAVER DAYS',
      subtitle: 'Fresh fruits, veggies & dairy',
      highlight: 'UP TO 50% OFF',
      ctaText: 'Shop Deals →',
      badgeText: 'HOT DEAL',
      gradientColors: [Color(0xFF7C1C9C), Color(0xFFC2185B), Color(0xFFFF5252)],
      icon: Icons.local_fire_department_rounded,
      targetCategory: 'Fruits & Vegetables',
      imageUrl: 'https://images.unsplash.com/photo-1610348725531-843dff563e2c?auto=format&fit=crop&w=600&q=80',
    ),
    PromoBanner(
      id: 'banner-2',
      title: 'FARM FRESH FEST',
      subtitle: 'Crisp apples, bananas & Ratnagiri mangoes',
      highlight: '100% ORGANIC',
      ctaText: 'Explore →',
      badgeText: '100% ORGANIC',
      gradientColors: [Color(0xFF00796B), Color(0xFF00A859), Color(0xFF69F0AE)],
      icon: Icons.eco_rounded,
      targetCategory: 'Fruits & Vegetables',
      imageUrl: 'https://images.unsplash.com/photo-1553279768-865429fa0078?auto=format&fit=crop&w=600&q=80',
    ),
    PromoBanner(
      id: 'banner-3',
      title: 'MIDNIGHT MUNCHIES',
      subtitle: 'Chocolates, chips, sodas & ice cream',
      highlight: 'CRAVINGS SORTED',
      ctaText: 'Grab Now →',
      badgeText: '10 MINS',
      gradientColors: [Color(0xFFFF3D00), Color(0xFFFF9100), Color(0xFFFFD600)],
      icon: Icons.bolt_rounded,
      targetCategory: 'Snacks & Munchies',
      imageUrl: 'https://images.unsplash.com/photo-1566478989037-eec170784d0b?auto=format&fit=crop&w=600&q=80',
    ),
    PromoBanner(
      id: 'banner-4',
      title: 'BREAKFAST IN 10 MINS',
      subtitle: 'Farm eggs, sourdough, butter & juices',
      highlight: 'START FRESH',
      ctaText: 'Order Now →',
      badgeText: 'MORNING SPECIAL',
      gradientColors: [Color(0xFF1565C0), Color(0xFF0288D1), Color(0xFF00E5FF)],
      icon: Icons.wb_sunny_rounded,
      targetCategory: 'Dairy & Breakfast',
      imageUrl: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?auto=format&fit=crop&w=600&q=80',
    ),
    PromoBanner(
      id: 'banner-5',
      title: 'NEW USER WELCOME',
      subtitle: 'Extra savings on your first basket',
      highlight: 'FLAT ₹100 CASHBACK',
      ctaText: 'Use: FIRST100',
      badgeText: 'EXCLUSIVE',
      promoCode: 'FIRST100',
      gradientColors: [Color(0xFF880E4F), Color(0xFFD81B60), Color(0xFFFF4081)],
      icon: Icons.card_giftcard_rounded,
      targetCategory: 'Instant Food',
      imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=600&q=80',
    ),
  ];
}
