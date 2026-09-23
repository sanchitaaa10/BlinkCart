import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';
import 'widgets/home_header.dart';
import 'widgets/daily_stories_bar.dart';
import 'widgets/banner_carousel.dart';
import 'widgets/category_horizontal_list.dart';
import 'widgets/flash_deals_section.dart';
import 'widgets/section_header.dart';
import 'widgets/curated_bundles_section.dart';
import 'widgets/recipe_kits_section.dart';
import 'widgets/brand_spotlight_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    final fruitsVeg = productProvider.getProductsByCategory('Fruits & Vegetables');
    final dairy = productProvider.getProductsByCategory('Dairy & Breakfast');
    final snacks = productProvider.getProductsByCategory('Snacks & Munchies');
    final beverages = productProvider.getProductsByCategory('Cold Drinks & Juices');
    final instantFood = productProvider.getProductsByCategory('Instant Food');
    final attaRice = productProvider.getProductsByCategory('Atta, Rice & Dal');
    final personalCare = productProvider.getProductsByCategory('Personal Care');
    final cleaning = productProvider.getProductsByCategory('Cleaning & Household');
    final babyCare = productProvider.getProductsByCategory('Baby Care');
    final petCare = productProvider.getProductsByCategory('Pet Care');
    final beauty = productProvider.getProductsByCategory('Beauty & Cosmetics');
    final homeEssentials = productProvider.getProductsByCategory('Home Essentials');
    final electronics = productProvider.getProductsByCategory('Electronics & Accessories');
    final bestsellers = productProvider.popularProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 600));
          },
          child: CustomScrollView(
            slivers: [
              // Sticky Header with Location, Animated Search hint & Avatar
              const SliverToBoxAdapter(
                child: HomeHeader(),
              ),

              // Daily Quick Stories / Specials Bar (Real Photography)
              const SliverToBoxAdapter(
                child: DailyStoriesBar(),
              ),

              // Banner Carousel
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 8),
                  child: BannerCarousel(),
                ),
              ),

              // Category Section Header
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: AppStrings.shopByCategory,
                  subtitle: 'Explore 14+ departments in 10 mins',
                  actionText: 'View All',
                  icon: Icons.grid_view_rounded,
                  onActionTap: () {
                    Navigator.pushNamed(context, AppRoutes.categories);
                  },
                ),
              ),

              // Horizontal Category List
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 4, bottom: 8),
                  child: CategoryHorizontalList(),
                ),
              ),

              // Flash Deals with Live Countdown
              const SliverToBoxAdapter(
                child: FlashDealsSection(),
              ),

              // Curated Bundles Section (Save Big with 1-Tap Add)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 12),
                  child: CuratedBundlesSection(),
                ),
              ),

              // Section: Fresh Fruits & Vegetables
              if (fruitsVeg.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: AppStrings.freshFruitsVeg,
                    subtitle: AppStrings.freshPicks,
                    icon: Icons.eco_rounded,
                    onActionTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.categoryProducts,
                        arguments: 'Fruits & Vegetables',
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildHorizontalProductList(fruitsVeg),
                ),
              ],

              // 15-Minute Recipe Kits Section
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 8),
                  child: RecipeKitsSection(),
                ),
              ),

              // Section: Bestsellers Near You
              if (bestsellers.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: AppStrings.bestsellers,
                    subtitle: AppStrings.popularNearYou,
                    icon: Icons.local_fire_department_rounded,
                    onActionTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.categoryProducts,
                        arguments: 'Instant Food',
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildHorizontalProductList(bestsellers),
                ),
              ],

              // Top Brand Stores Spotlight
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 8),
                  child: BrandSpotlightSection(),
                ),
              ),

              // Section: Atta, Rice, Oils & Dal
              if (attaRice.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Atta, Rice & Kitchen Staples',
                    subtitle: 'Farm-fresh grains, dals & premium oils',
                    icon: Icons.grain_rounded,
                    onActionTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.categoryProducts,
                        arguments: 'Atta, Rice & Dal',
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildHorizontalProductList(attaRice),
                ),
              ],

              // Section: Dairy, Bread & Eggs
              if (dairy.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: AppStrings.dairyBreakfast,
                    subtitle: 'Start your morning with pure freshness',
                    icon: Icons.local_drink_rounded,
                    onActionTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.categoryProducts,
                        arguments: 'Dairy & Breakfast',
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildHorizontalProductList(dairy),
                ),
              ],

              // Section: Snacks & Beverages
              if (snacks.isNotEmpty || beverages.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: AppStrings.snacksBeverages,
                    subtitle: AppStrings.snacksEssential,
                    icon: Icons.fastfood_rounded,
                    onActionTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.categoryProducts,
                        arguments: 'Snacks & Munchies',
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildHorizontalProductList([...snacks, ...beverages]),
                ),
              ],

              // Section: Instant Food & Quick Meals
              if (instantFood.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Instant Food & Ready-to-Eat',
                    subtitle: 'Quick bites ready in 2–5 minutes',
                    icon: Icons.ramen_dining_rounded,
                    onActionTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.categoryProducts,
                        arguments: 'Instant Food',
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildHorizontalProductList(instantFood),
                ),
              ],

              // Section: Baby Care & Diapers
              if (babyCare.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Baby Care & Essentials',
                    subtitle: 'Gentle, tested products for your little one',
                    icon: Icons.child_care_rounded,
                    onActionTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.categoryProducts,
                        arguments: 'Baby Care',
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildHorizontalProductList(babyCare),
                ),
              ],

              // Section: Pet Care & Nutrition
              if (petCare.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Pet Care & Food',
                    subtitle: 'Nutritious meals & treats for furry friends',
                    icon: Icons.pets_rounded,
                    onActionTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.categoryProducts,
                        arguments: 'Pet Care',
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildHorizontalProductList(petCare),
                ),
              ],

              // Section: Beauty & Cosmetics
              if (beauty.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Beauty & Skincare Glow',
                    subtitle: 'Serums, sunscreens & premium cosmetics',
                    icon: Icons.face_retouching_natural_rounded,
                    onActionTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.categoryProducts,
                        arguments: 'Beauty & Cosmetics',
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildHorizontalProductList(beauty),
                ),
              ],

              // Section: Personal Care
              if (personalCare.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: AppStrings.personalCare,
                    subtitle: 'Shampoos, body care & wellness',
                    icon: Icons.spa_rounded,
                    onActionTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.categoryProducts,
                        arguments: 'Personal Care',
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildHorizontalProductList(personalCare),
                ),
              ],

              // Section: Cleaning & Household
              if (cleaning.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: AppStrings.householdCleaning,
                    subtitle: 'Detergents, dishwash & cleaners',
                    icon: Icons.cleaning_services_rounded,
                    onActionTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.categoryProducts,
                        arguments: 'Cleaning & Household',
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildHorizontalProductList(cleaning),
                ),
              ],

              // Section: Home Essentials & Dining
              if (homeEssentials.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Home & Kitchen Essentials',
                    subtitle: 'Cookware, cutlery & storage utility',
                    icon: Icons.home_repair_service_rounded,
                    onActionTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.categoryProducts,
                        arguments: 'Home Essentials',
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildHorizontalProductList(homeEssentials),
                ),
              ],

              // Section: Electronics & Gadgets
              if (electronics.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Electronics & Gadgets',
                    subtitle: 'Fast charging, cables & audio gear',
                    icon: Icons.devices_other_rounded,
                    onActionTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.categoryProducts,
                        arguments: 'Electronics & Accessories',
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildHorizontalProductList(electronics),
                ),
              ],

              // Bottom padding for bottom navigation and floating cart bar
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalProductList(List<dynamic> products) {
    return SizedBox(
      height: 275,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return ProductCard(
            product: products[index],
            width: 158,
          );
        },
      ),
    );
  }
}
