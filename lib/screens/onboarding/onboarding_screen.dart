import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import '../../core/routes/app_routes.dart';
import '../../core/widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = const [
    _OnboardingData(
      title: 'Groceries in minutes',
      description: 'Get your everyday essentials delivered quickly, right when you need them.',
      imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=600&q=80',
      accentColor: AppColors.primary,
      badgeText: '10–20 MIN DELIVERY',
      subIcons: [
        Icons.bolt_rounded,
        Icons.local_shipping_rounded,
        Icons.timer_rounded,
        Icons.shopping_basket_rounded,
      ],
    ),
    _OnboardingData(
      title: 'Fresh. Fast. Reliable.',
      description: 'Fresh produce, snacks, beverages and household essentials delivered to your doorstep.',
      imageUrl: 'https://images.unsplash.com/photo-1610348725531-843dff563e2c?auto=format&fit=crop&w=600&q=80',
      accentColor: AppColors.success,
      badgeText: '100% FARM FRESH',
      subIcons: [
        Icons.eco_rounded,
        Icons.spa_rounded,
        Icons.verified_rounded,
        Icons.agriculture_rounded,
      ],
    ),
    _OnboardingData(
      title: 'Your daily essentials, sorted',
      description: 'Discover great deals and order everything you need from one convenient app.',
      imageUrl: 'https://images.unsplash.com/photo-1588964895597-cfccd6e2dbf9?auto=format&fit=crop&w=600&q=80',
      accentColor: AppColors.accent,
      badgeText: 'UNBEATABLE PRICES',
      subIcons: [
        Icons.discount_rounded,
        Icons.savings_rounded,
        Icons.card_giftcard_rounded,
        Icons.stars_rounded,
      ],
    ),
  ];

  Future<void> _completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('qb_onboarding_done', true);
    } catch (_) {}

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.location);
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_currentPage < _pages.length - 1)
            TextButton(
              onPressed: _completeOnboarding,
              child: Text(
                'Skip',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final data = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Visual Center Illustration Card with Real Photography
                        Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                data.accentColor.withValues(alpha: 0.15),
                                data.accentColor.withValues(alpha: 0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: data.accentColor.withValues(alpha: 0.25),
                                      blurRadius: 24,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    data.imageUrl,
                                    width: 180,
                                    height: 180,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: data.accentColor,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: data.accentColor.withValues(alpha: 0.1),
                                      child: Icon(Icons.shopping_basket_rounded, size: 64, color: data.accentColor),
                                    ),
                                  ),
                                ),
                              ),
                              // Floating satellite badges with Material 3 icons
                              Positioned(
                                top: 16,
                                left: 24,
                                child: _buildMiniBubble(data.subIcons[0], data.accentColor),
                              ),
                              Positioned(
                                top: 24,
                                right: 16,
                                child: _buildMiniBubble(data.subIcons[1], data.accentColor),
                              ),
                              Positioned(
                                bottom: 24,
                                left: 16,
                                child: _buildMiniBubble(data.subIcons[2], data.accentColor),
                              ),
                              Positioned(
                                bottom: 16,
                                right: 24,
                                child: _buildMiniBubble(data.subIcons[3], data.accentColor),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 36),

                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: data.accentColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            data.badgeText,
                            style: AppTypography.labelSmall.copyWith(
                              color: data.accentColor,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Title
                        Text(
                          data.title,
                          textAlign: TextAlign.center,
                          style: AppTypography.displayLarge.copyWith(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Description
                        Text(
                          data.description,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation & Dots
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Dots indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? AppColors.primary : AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // CTA Button
                  CustomButton(
                    text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                    onPressed: _nextPage,
                    backgroundColor: AppColors.primary,
                    height: AppDimensions.buttonHeightLg,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniBubble(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 18,
        color: color,
      ),
    );
  }
}

class _OnboardingData {
  final String title;
  final String description;
  final String imageUrl;
  final Color accentColor;
  final String badgeText;
  final List<IconData> subIcons;

  const _OnboardingData({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.accentColor,
    required this.badgeText,
    required this.subIcons,
  });
}
