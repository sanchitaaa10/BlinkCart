import 'package:flutter/material.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String location = '/location';
  static const String mainShell = '/main-shell';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String categoryProducts = '/category-products';
  static const String search = '/search';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String addressList = '/address-list';
  static const String addEditAddress = '/add-edit-address';
  static const String checkout = '/checkout';
  static const String payment = '/payment';
  static const String orderSuccess = '/order-success';
  static const String orderTracking = '/order-tracking';
  static const String orders = '/orders';
  static const String orderDetail = '/order-detail';
  static const String wishlist = '/wishlist';
  static const String offers = '/offers';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String faq = '/faq';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    // Handled in app.dart with concrete widgets
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('Route not configured')),
      ),
    );
  }
}
