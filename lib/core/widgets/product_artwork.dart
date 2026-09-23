import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ProductArtwork extends StatelessWidget {
  final String category;
  final String productName;
  final String? imageUrl;
  final double height;
  final double width;
  final double borderRadius;
  final bool showBadge;
  final BoxFit fit;

  const ProductArtwork({
    super.key,
    required this.category,
    required this.productName,
    this.imageUrl,
    this.height = 110,
    this.width = double.infinity,
    this.borderRadius = 10,
    this.showBadge = false,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final style = _getCategoryStyle(category, productName);
    final photoUrl = imageUrl ?? _resolveHighResPhoto(productName, category);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: style.bgColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Ambient soft background glow
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, -0.2),
                  radius: 0.9,
                  colors: [
                    style.glowColor.withValues(alpha: 0.35),
                    style.bgColor,
                  ],
                ),
              ),
            ),

            // Real High-Res Photography Image
            if (photoUrl != null && photoUrl.isNotEmpty)
              Image.network(
                photoUrl,
                fit: fit,
                height: height,
                width: width,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildFallbackIcon(style);
                },
                errorBuilder: (context, error, stackTrace) {
                  return _buildFallbackIcon(style);
                },
              )
            else
              _buildFallbackIcon(style),

            // Subtle gradient overlay at bottom for contrast
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: height * 0.2,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.06),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Top-Right category badge icon
            if (showBadge)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    style.icon,
                    size: 11,
                    color: style.accentColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackIcon(_ProductStyle style) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: height * 0.65,
            height: height * 0.65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: style.glowColor.withValues(alpha: 0.25),
            ),
          ),
          Container(
            padding: EdgeInsets.all(height * 0.14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: style.accentColor.withValues(alpha: 0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              style.icon,
              size: height * 0.34,
              color: style.accentColor,
            ),
          ),
        ],
      ),
    );
  }

  static String? _resolveHighResPhoto(String name, String category) {
    final n = name.toLowerCase();

    // 1. Fruits & Vegetables
    if (n.contains('strawberry') || n.contains('strawberries')) {
      return 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('avocado')) {
      return 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('broccoli')) {
      return 'https://images.unsplash.com/photo-1584270354949-c26b0d5b4a0c?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('mushroom')) {
      return 'https://images.unsplash.com/photo-1504544750208-dc0358e63f7f?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('spinach') || n.contains('palak')) {
      return 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('mango')) {
      return 'https://images.unsplash.com/photo-1553279768-865429fa0078?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('banana')) {
      return 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('apple')) {
      return 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('tomato')) {
      return 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('potato')) {
      return 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('onion')) {
      return 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?auto=format&fit=crop&w=600&q=80';
    }

    // 2. Dairy & Breakfast
    if (n.contains('paneer')) {
      return 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('greek yogurt') || n.contains('epigamia') || n.contains('yogurt') || n.contains('curd')) {
      return 'https://images.unsplash.com/photo-1488477181946-6428a0291777?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('oat milk') || n.contains('oatly')) {
      return 'https://images.unsplash.com/photo-1556881286-fc6915169721?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('muesli') || n.contains('granola') || n.contains('cereal')) {
      return 'https://images.unsplash.com/photo-1521483451569-e33803c0330c?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('milk')) {
      return 'https://images.unsplash.com/photo-1550583724-b2692b85b150?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('butter')) {
      return 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('cheese')) {
      return 'https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('egg')) {
      return 'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?auto=format&fit=crop&w=600&q=80';
    }

    // 3. Bakery
    if (n.contains('baguette')) {
      return 'https://images.unsplash.com/photo-1589367920969-ab8e050bbb04?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('croissant')) {
      return 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('pita')) {
      return 'https://images.unsplash.com/photo-1628840042765-356cda07504e?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('muffin')) {
      return 'https://images.unsplash.com/photo-1607958996333-41aef7caefaa?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('bread')) {
      return 'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=600&q=80';
    }

    // 4. Snacks & Munchies
    if (n.contains('doritos')) {
      return 'https://images.unsplash.com/photo-1513456852971-30c0b8199d4d?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('pringles') || n.contains('crisps')) {
      return 'https://images.unsplash.com/photo-1527842891421-42eec6e703ea?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('bhujia') || n.contains('namkeen')) {
      return 'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('cadbury') || n.contains('silk') || n.contains('chocolate')) {
      return 'https://images.unsplash.com/photo-1511381939415-e44015466834?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('oreo') || n.contains('cookie') || n.contains('biscuit')) {
      return 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('kitkat')) {
      return 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('almond') || n.contains('nut')) {
      return 'https://images.unsplash.com/photo-1508061253366-f7da158b6d46?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('popcorn')) {
      return 'https://images.unsplash.com/photo-1578849278619-e73505e9610f?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('nutella')) {
      return 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('lay') || n.contains('chip')) {
      return 'https://images.unsplash.com/photo-1566478989037-eec170784d0b?auto=format&fit=crop&w=600&q=80';
    }

    // 5. Cold Drinks & Juices
    if (n.contains('coca') || n.contains('coke') || n.contains('cola')) {
      return 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('red bull') || n.contains('monster') || n.contains('energy')) {
      return 'https://images.unsplash.com/photo-1551024709-8f23befc6f87?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('coconut water')) {
      return 'https://images.unsplash.com/photo-1544681280-d25a782adc9b?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('orange juice') || n.contains('juice') || n.contains('aamras') || n.contains('paper boat')) {
      return 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('tonic') || n.contains('sprite') || n.contains('soda')) {
      return 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?auto=format&fit=crop&w=600&q=80';
    }

    // 6. Instant Food
    if (n.contains('maggi') || n.contains('noodle') || n.contains('cup noodle') || n.contains('hakka')) {
      return 'https://images.unsplash.com/photo-1612927601601-6638404737ce?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('soup')) {
      return 'https://images.unsplash.com/photo-1547592166-23ac45744acd?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('dal makhani')) {
      return 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('idli')) {
      return 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('pasta') || n.contains('penne')) {
      return 'https://images.unsplash.com/photo-1621996346565-e3d5d6281734?auto=format&fit=crop&w=600&q=80';
    }

    // 7. Atta, Rice & Dal
    if (n.contains('atta') || n.contains('flour') || n.contains('aashirvaad')) {
      return 'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('rice') || n.contains('basmati')) {
      return 'https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('toor') || n.contains('moong') || n.contains('dal') || n.contains('lentil')) {
      return 'https://images.unsplash.com/photo-1515543237350-b3eea1ec8082?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('sunflower oil') || n.contains('olive oil') || n.contains('oil')) {
      return 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('salt') || n.contains('masala') || n.contains('spice')) {
      return 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?auto=format&fit=crop&w=600&q=80';
    }

    // 8. Personal Care
    if (n.contains('handwash') || n.contains('dettol') || n.contains('soap') || n.contains('pears')) {
      return 'https://images.unsplash.com/photo-1607006314177-3e1140026e5e?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('shampoo') || n.contains('dove')) {
      return 'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('toothpaste') || n.contains('colgate')) {
      return 'https://images.unsplash.com/photo-1559591937-e1069796e951?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('deodorant') || n.contains('nivea')) {
      return 'https://images.unsplash.com/photo-1594035910387-fea47794261f?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('razor') || n.contains('gillette')) {
      return 'https://images.unsplash.com/photo-1508746829417-e6f548d8d6ed?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('face wash') || n.contains('biotique')) {
      return 'https://images.unsplash.com/photo-1556228720-195a672e8a03?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('body lotion') || n.contains('vaseline')) {
      return 'https://images.unsplash.com/photo-1526947425960-945c6e72858f?auto=format&fit=crop&w=600&q=80';
    }

    // 9. Cleaning & Household
    if (n.contains('surf') || n.contains('detergent')) {
      return 'https://images.unsplash.com/photo-1584820927498-cfe5211fd8bf?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('vim') || n.contains('dishwash')) {
      return 'https://images.unsplash.com/photo-1585421514738-01798e348b17?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('harpic') || n.contains('toilet cleaner')) {
      return 'https://images.unsplash.com/photo-1563453392212-326f5e854473?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('colin') || n.contains('glass cleaner')) {
      return 'https://images.unsplash.com/photo-1584813470613-5b1c1cad3d69?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('goodknight') || n.contains('mosquito') || n.contains('aer')) {
      return 'https://images.unsplash.com/photo-1608571423902-eed4a5ad8108?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('sponge') || n.contains('scrub') || n.contains('wipe')) {
      return 'https://images.unsplash.com/photo-1584634731339-252c581abfc5?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('toilet tissue') || n.contains('paper roll')) {
      return 'https://images.unsplash.com/photo-1584556812952-905ffd0c611a?auto=format&fit=crop&w=600&q=80';
    }

    // 10. Baby Care
    if (n.contains('diaper') || n.contains('pampers')) {
      return 'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('wipe') && category.toLowerCase().contains('baby')) {
      return 'https://images.unsplash.com/photo-1544717305-2782549b5136?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('baby') || n.contains('sebamed') || n.contains('cerelac')) {
      return 'https://images.unsplash.com/photo-1522771930-78848d9293e8?auto=format&fit=crop&w=600&q=80';
    }

    // 11. Pet Care
    if (n.contains('dog') || n.contains('pedigree') || n.contains('treat')) {
      return 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('cat') || n.contains('whiskas') || n.contains('litter')) {
      return 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=600&q=80';
    }

    // 12. Beauty & Cosmetics
    if (n.contains('serum') || n.contains('vitamin c')) {
      return 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('neutrogena') || n.contains('gel') || n.contains('toner') || n.contains('cleanser') || n.contains('cetaphil')) {
      return 'https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('lipstick') || n.contains('maybelline')) {
      return 'https://images.unsplash.com/photo-1586495777744-4413f21062fa?auto=format&fit=crop&w=600&q=80';
    }

    // 13. Home Essentials
    if (n.contains('batter') || n.contains('duracell')) {
      return 'https://images.unsplash.com/photo-1619725002198-6a689b72f41d?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('foil') || n.contains('freshwrap')) {
      return 'https://images.unsplash.com/photo-1530587191325-3db32d826c18?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('cotton bud') || n.contains('odonil')) {
      return 'https://images.unsplash.com/photo-1583947215259-38e31be8751f?auto=format&fit=crop&w=600&q=80';
    }

    // 14. Electronics
    if (n.contains('charger') || n.contains('power delivery')) {
      return 'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('earphone') || n.contains('boat') || n.contains('headphone')) {
      return 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('power bank') || n.contains('ambrane')) {
      return 'https://images.unsplash.com/photo-1609091839311-d5365f9ff1c5?auto=format&fit=crop&w=600&q=80';
    }
    if (n.contains('cable') || n.contains('lightning') || n.contains('type-c')) {
      return 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&w=600&q=80';
    }

    // Universal Fallback
    return 'https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=600&q=80';
  }

  static _ProductStyle _getCategoryStyle(String category, String name) {
    final catLower = category.toLowerCase();
    final nameLower = name.toLowerCase();

    if (nameLower.contains('banana') || nameLower.contains('mango') || nameLower.contains('lemon')) {
      return _ProductStyle(const Color(0xFFFFFBEB), const Color(0xFFF59E0B), const Color(0xFFFDE68A), Icons.eco_rounded);
    }
    if (nameLower.contains('tomato') || nameLower.contains('apple') || nameLower.contains('strawberry')) {
      return _ProductStyle(const Color(0xFFFEF2F2), const Color(0xFFEF4444), const Color(0xFFFECACA), Icons.eco_rounded);
    }
    if (nameLower.contains('potato') || nameLower.contains('onion') || nameLower.contains('mushroom')) {
      return _ProductStyle(const Color(0xFFF5F5F4), const Color(0xFF78716C), const Color(0xFFE7E5E4), Icons.eco_rounded);
    }
    if (nameLower.contains('avocado') || nameLower.contains('spinach') || nameLower.contains('broccoli')) {
      return _ProductStyle(const Color(0xFFF0FDF4), const Color(0xFF16A34A), const Color(0xFFBBF7D0), Icons.eco_rounded);
    }
    if (nameLower.contains('milk') || nameLower.contains('paneer') || nameLower.contains('yogurt')) {
      return _ProductStyle(const Color(0xFFF0F9FF), const Color(0xFF0284C7), const Color(0xFFBAE6FD), Icons.local_drink_rounded);
    }
    if (nameLower.contains('butter') || nameLower.contains('cheese')) {
      return _ProductStyle(const Color(0xFFFEFCE8), const Color(0xFFEAB308), const Color(0xFFFEF08A), Icons.kitchen_rounded);
    }
    if (nameLower.contains('bread') || nameLower.contains('baguette') || nameLower.contains('croissant') || nameLower.contains('muffin')) {
      return _ProductStyle(const Color(0xFFFAF5FF), const Color(0xFF9333EA), const Color(0xFFE9D5FF), Icons.bakery_dining_rounded);
    }
    if (nameLower.contains('egg')) {
      return _ProductStyle(const Color(0xFFFFF7ED), const Color(0xFFEA580C), const Color(0xFFFFEDD5), Icons.egg_rounded);
    }
    if (nameLower.contains('chocolate') || nameLower.contains('cadbury') || nameLower.contains('silk')) {
      return _ProductStyle(const Color(0xFFFDF4FF), const Color(0xFFC026D3), const Color(0xFFF5D0FE), Icons.icecream_rounded);
    }
    if (nameLower.contains('maggi') || nameLower.contains('noodle') || nameLower.contains('pasta')) {
      return _ProductStyle(const Color(0xFFFEF2F2), const Color(0xFFDC2626), const Color(0xFFFECACA), Icons.ramen_dining_rounded);
    }
    if (nameLower.contains('cola') || nameLower.contains('juice') || nameLower.contains('energy') || nameLower.contains('drink')) {
      return _ProductStyle(const Color(0xFFEFF6FF), const Color(0xFF2563EB), const Color(0xFFBFDBFE), Icons.local_drink_rounded);
    }
    if (nameLower.contains('chip') || nameLower.contains('doritos') || nameLower.contains('pringles') || nameLower.contains('popcorn')) {
      return _ProductStyle(const Color(0xFFFFFBEB), const Color(0xFFD97706), const Color(0xFFFDE68A), Icons.fastfood_rounded);
    }
    if (nameLower.contains('shampoo') || nameLower.contains('soap') || nameLower.contains('cream') || nameLower.contains('serum')) {
      return _ProductStyle(const Color(0xFFFAF5FF), const Color(0xFF7C3AED), const Color(0xFFDDD6FE), Icons.spa_rounded);
    }
    if (nameLower.contains('surf') || nameLower.contains('detergent') || nameLower.contains('vim') || nameLower.contains('cleaner')) {
      return _ProductStyle(const Color(0xFFECFEFF), const Color(0xFF0891B2), const Color(0xFFA5F3FC), Icons.cleaning_services_rounded);
    }
    if (nameLower.contains('baby') || nameLower.contains('diaper') || nameLower.contains('pampers')) {
      return _ProductStyle(const Color(0xFFFFF1F2), const Color(0xFFF43F5E), const Color(0xFFFECDD3), Icons.child_care_rounded);
    }
    if (nameLower.contains('dog') || nameLower.contains('cat') || nameLower.contains('pet')) {
      return _ProductStyle(const Color(0xFFFFF7ED), const Color(0xFFEA580C), const Color(0xFFFFEDD5), Icons.pets_rounded);
    }
    if (nameLower.contains('battery') || nameLower.contains('charger') || nameLower.contains('cable') || nameLower.contains('power')) {
      return _ProductStyle(const Color(0xFFF1F5F9), const Color(0xFF334155), const Color(0xFFCBD5E1), Icons.devices_rounded);
    }

    // Category fallbacks
    if (catLower.contains('fruit') || catLower.contains('veg')) {
      return _ProductStyle(const Color(0xFFF0FDF4), const Color(0xFF16A34A), const Color(0xFFBBF7D0), Icons.eco_rounded);
    }
    if (catLower.contains('dairy')) {
      return _ProductStyle(const Color(0xFFF0F9FF), const Color(0xFF0284C7), const Color(0xFFBAE6FD), Icons.local_drink_rounded);
    }
    if (catLower.contains('snack')) {
      return _ProductStyle(const Color(0xFFFFFBEB), const Color(0xFFD97706), const Color(0xFFFDE68A), Icons.fastfood_rounded);
    }
    if (catLower.contains('beverage') || catLower.contains('drink')) {
      return _ProductStyle(const Color(0xFFEFF6FF), const Color(0xFF2563EB), const Color(0xFFBFDBFE), Icons.local_drink_rounded);
    }
    if (catLower.contains('instant')) {
      return _ProductStyle(const Color(0xFFFEF2F2), const Color(0xFFDC2626), const Color(0xFFFECACA), Icons.ramen_dining_rounded);
    }
    if (catLower.contains('staple') || catLower.contains('atta')) {
      return _ProductStyle(const Color(0xFFFFFBEB), const Color(0xFFB45309), const Color(0xFFFDE68A), Icons.grain_rounded);
    }
    if (catLower.contains('personal') || catLower.contains('beauty')) {
      return _ProductStyle(const Color(0xFFFAF5FF), const Color(0xFF7C3AED), const Color(0xFFDDD6FE), Icons.spa_rounded);
    }
    if (catLower.contains('cleaning')) {
      return _ProductStyle(const Color(0xFFECFEFF), const Color(0xFF0891B2), const Color(0xFFA5F3FC), Icons.cleaning_services_rounded);
    }
    if (catLower.contains('baby')) {
      return _ProductStyle(const Color(0xFFFFF1F2), const Color(0xFFF43F5E), const Color(0xFFFECDD3), Icons.child_care_rounded);
    }
    if (catLower.contains('pet')) {
      return _ProductStyle(const Color(0xFFFFF7ED), const Color(0xFFEA580C), const Color(0xFFFFEDD5), Icons.pets_rounded);
    }
    if (catLower.contains('electronic')) {
      return _ProductStyle(const Color(0xFFF8FAFC), const Color(0xFF475569), const Color(0xFFE2E8F0), Icons.devices_rounded);
    }

    return _ProductStyle(const Color(0xFFFAF5FF), AppColors.primary, const Color(0xFFE9D5FF), Icons.shopping_bag_rounded);
  }
}

class _ProductStyle {
  final Color bgColor;
  final Color accentColor;
  final Color glowColor;
  final IconData icon;

  const _ProductStyle(this.bgColor, this.accentColor, this.glowColor, this.icon);
}
