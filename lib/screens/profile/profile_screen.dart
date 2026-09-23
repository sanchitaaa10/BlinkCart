import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_profile.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/toast_utils.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/order_provider.dart';
import '../../providers/wishlist_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserProfile.sample();
    final orderCount = context.watch<OrderProvider>().orders.length;
    final wishlistCount = context.watch<WishlistProvider>().itemCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('My Profile', style: AppTypography.headingLarge),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            user.name[0],
                            style: AppTypography.displayLarge.copyWith(
                              color: AppColors.primary,
                              fontSize: 26,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: AppTypography.headingLarge.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.phoneNumber,
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                            Text(
                              user.email,
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Stats Row
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('Orders', orderCount.toString()),
                        Container(width: 1, height: 24, color: Colors.white.withValues(alpha: 0.3)),
                        _buildStatItem('Wishlist', wishlistCount.toString()),
                        Container(width: 1, height: 24, color: Colors.white.withValues(alpha: 0.3)),
                        _buildStatItem('Points', user.blinkCartPoints.toString()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Quick Access Tiles
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    _buildProfileTile(
                      icon: Icons.receipt_long_outlined,
                      title: 'My Orders',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.orders),
                    ),
                    const Divider(height: 1),
                    _buildProfileTile(
                      icon: Icons.favorite_border_rounded,
                      title: 'Wishlist',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.wishlist),
                    ),
                    const Divider(height: 1),
                    _buildProfileTile(
                      icon: Icons.location_on_outlined,
                      title: 'Saved Addresses',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.addressList),
                    ),
                    const Divider(height: 1),
                    _buildProfileTile(
                      icon: Icons.discount_outlined,
                      title: 'Coupons & Offers',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.offers),
                    ),
                    const Divider(height: 1),
                    _buildProfileTile(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notifications',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Support & Legal
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    _buildProfileTile(
                      icon: Icons.quiz_outlined,
                      title: 'Delivery & Dark Store FAQs',
                      subtitle: '10-min delivery, freshness, cold chain & refunds',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.faq),
                    ),
                    const Divider(height: 1),
                    _buildProfileTile(
                      icon: Icons.headset_mic_outlined,
                      title: 'Help & Support (24/7)',
                      onTap: () => _showSupportDialog(context),
                    ),
                    const Divider(height: 1),
                    _buildProfileTile(
                      icon: Icons.info_outline_rounded,
                      title: 'About BlinkCart',
                      subtitle: 'v1.0.0 • 10-minute grocery platform',
                      onTap: () => _showAboutDialog(context),
                    ),
                    const Divider(height: 1),
                    _buildProfileTile(
                      icon: Icons.policy_outlined,
                      title: 'Terms & Conditions & Privacy',
                      onTap: () => ToastUtils.showInfo(context, 'Terms & Privacy Policy up to date'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Logout / Reset
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: _buildProfileTile(
                  icon: Icons.logout_rounded,
                  iconColor: AppColors.error,
                  title: 'Log Out',
                  titleColor: AppColors.error,
                  onTap: () {
                    ToastUtils.showInfo(context, 'Logged out from demo session');
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.headingLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.primary, size: 22),
      title: Text(
        title,
        style: AppTypography.labelLarge.copyWith(
          color: titleColor ?? AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle, style: AppTypography.bodySmall) : null,
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
      onTap: onTap,
    );
  }

  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.headset_mic_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text('24/7 Support'),
          ],
        ),
        content: const Text(
          'Need help with an ongoing order or product quality?\n\n'
          '• Toll-free: 1800-BLINK-CART\n'
          '• Email: support@blinkcart.in\n'
          '• Live chat is always available.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.bolt_rounded, color: AppColors.primary, size: 24),
            SizedBox(width: 8),
            Text('About BlinkCart'),
          ],
        ),
        content: const Text(
          'BlinkCart delivers fresh groceries, fruits, vegetables, snacks, and household essentials in 10-20 minutes.\n\n'
          'Developed with Flutter, Dart & Material 3.\n'
          '“Everything you need. Delivered in minutes.”',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
