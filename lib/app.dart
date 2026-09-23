import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/product.dart';
import 'models/address.dart';
import 'models/order.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/address_provider.dart';
import 'providers/order_provider.dart';
import 'providers/location_provider.dart';
import 'providers/coupon_provider.dart';
import 'providers/notification_provider.dart';

import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/location/location_selection_screen.dart';
import 'screens/main_shell/main_navigation_shell.dart';
import 'screens/category/categories_screen.dart';
import 'screens/category/category_products_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/product/product_detail_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/address/address_list_screen.dart';
import 'screens/address/add_edit_address_screen.dart';
import 'screens/checkout/checkout_screen.dart';
import 'screens/checkout/payment_screen.dart';
import 'screens/order/order_success_screen.dart';
import 'screens/order/order_tracking_screen.dart';
import 'screens/order/orders_screen.dart';
import 'screens/order/order_detail_screen.dart';
import 'screens/wishlist/wishlist_screen.dart';
import 'screens/offers/offers_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/notifications/notifications_screen.dart';
import 'screens/profile/faq_screen.dart';

class BlinkCartApp extends StatelessWidget {
  const BlinkCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => CouponProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'BlinkCart',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case AppRoutes.splash:
              return MaterialPageRoute(builder: (_) => const SplashScreen());
            case AppRoutes.onboarding:
              return MaterialPageRoute(builder: (_) => const OnboardingScreen());
            case AppRoutes.location:
              return MaterialPageRoute(builder: (_) => const LocationSelectionScreen());
            case AppRoutes.mainShell:
            case AppRoutes.home:
              final initialIndex = settings.arguments as int? ?? 0;
              return MaterialPageRoute(
                builder: (_) => MainNavigationShell(initialIndex: initialIndex),
              );
            case AppRoutes.categories:
              return MaterialPageRoute(builder: (_) => const CategoriesScreen());
            case AppRoutes.categoryProducts:
              final categoryName = settings.arguments as String? ?? 'Fruits & Vegetables';
              return MaterialPageRoute(
                builder: (_) => CategoryProductsScreen(categoryName: categoryName),
              );
            case AppRoutes.search:
              return MaterialPageRoute(builder: (_) => const SearchScreen());
            case AppRoutes.productDetail:
              final product = settings.arguments as Product;
              return MaterialPageRoute(
                builder: (_) => ProductDetailScreen(product: product),
              );
            case AppRoutes.cart:
              return MaterialPageRoute(builder: (_) => const CartScreen());
            case AppRoutes.addressList:
              return MaterialPageRoute(builder: (_) => const AddressListScreen());
            case AppRoutes.addEditAddress:
              final initialAddress = settings.arguments as Address?;
              return MaterialPageRoute(
                builder: (_) => AddEditAddressScreen(initialAddress: initialAddress),
              );
            case AppRoutes.checkout:
              return MaterialPageRoute(builder: (_) => const CheckoutScreen());
            case AppRoutes.payment:
              final initialMethod = settings.arguments as String? ?? 'UPI (Google Pay)';
              return MaterialPageRoute(
                builder: (_) => PaymentScreen(initialPaymentMethod: initialMethod),
              );
            case AppRoutes.orderSuccess:
              final order = settings.arguments as Order;
              return MaterialPageRoute(
                builder: (_) => OrderSuccessScreen(order: order),
              );
            case AppRoutes.orderTracking:
              final order = settings.arguments as Order;
              return MaterialPageRoute(
                builder: (_) => OrderTrackingScreen(order: order),
              );
            case AppRoutes.orders:
              return MaterialPageRoute(builder: (_) => const OrdersScreen());
            case AppRoutes.orderDetail:
              final order = settings.arguments as Order;
              return MaterialPageRoute(
                builder: (_) => OrderDetailScreen(order: order),
              );
            case AppRoutes.wishlist:
              return MaterialPageRoute(builder: (_) => const WishlistScreen());
            case AppRoutes.offers:
              return MaterialPageRoute(builder: (_) => const OffersScreen());
            case AppRoutes.profile:
              return MaterialPageRoute(builder: (_) => const ProfileScreen());
            case AppRoutes.notifications:
              return MaterialPageRoute(builder: (_) => const NotificationsScreen());
            case AppRoutes.faq:
              return MaterialPageRoute(builder: (_) => const FaqScreen());
            default:
              return MaterialPageRoute(
                builder: (_) => const MainNavigationShell(),
              );
          }
        },
      ),
    );
  }
}
