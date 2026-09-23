import 'package:flutter/foundation.dart';
import '../models/coupon.dart';
import '../data/mock_coupons.dart';

class CouponProvider extends ChangeNotifier {
  List<Coupon> _availableCoupons = [];

  CouponProvider() {
    _availableCoupons = List.from(MockCoupons.coupons);
  }

  List<Coupon> get availableCoupons => _availableCoupons;

  Coupon? getCouponByCode(String code) {
    try {
      return _availableCoupons.firstWhere(
        (c) => c.code.toUpperCase() == code.trim().toUpperCase(),
      );
    } catch (_) {
      return null;
    }
  }
}
