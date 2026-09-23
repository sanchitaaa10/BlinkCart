import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../models/address.dart';
import '../data/mock_orders.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];
  Order? _activeTrackingOrder;
  Timer? _simulationTimer;

  OrderProvider() {
    _initOrders();
  }

  void _initOrders() {
    _orders.addAll(MockOrders.getInitialOrders());
  }

  List<Order> get orders => [..._orders];
  Order? get activeTrackingOrder => _activeTrackingOrder;

  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  Order createOrder({
    required List<CartItem> items,
    required double itemTotal,
    required double discountAmount,
    required double deliveryFee,
    required double handlingFee,
    required double tipAmount,
    required double finalTotal,
    required String couponCode,
    required Address deliveryAddress,
    required String paymentMethod,
  }) {
    final newId = 'QB${10250 + _orders.length}';
    final order = Order(
      id: newId,
      items: List.from(items),
      itemTotal: itemTotal,
      discountAmount: discountAmount,
      deliveryFee: deliveryFee,
      handlingFee: handlingFee,
      tipAmount: tipAmount,
      finalTotal: finalTotal,
      couponCode: couponCode,
      deliveryAddress: deliveryAddress,
      paymentMethod: paymentMethod,
      status: OrderStatus.placed,
      createdAt: DateTime.now(),
      estimatedDeliveryMinutes: 12,
      deliveryPartnerName: 'Rahul Sharma',
      deliveryPartnerRating: 4.8,
      deliveryPartnerPhone: '+91 98201 12345',
    );

    _orders.insert(0, order);
    _activeTrackingOrder = order;
    _startOrderSimulation(order.id);
    notifyListeners();
    return order;
  }

  void setActiveTrackingOrder(Order order) {
    _activeTrackingOrder = order;
    notifyListeners();
  }

  void _startOrderSimulation(String orderId) {
    _simulationTimer?.cancel();
    
    // Simulate progression every 6 seconds for delightful live tracking demo
    _simulationTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index == -1) {
        timer.cancel();
        return;
      }

      final current = _orders[index];
      OrderStatus nextStatus;

      switch (current.status) {
        case OrderStatus.placed:
          nextStatus = OrderStatus.confirmed;
          break;
        case OrderStatus.confirmed:
          nextStatus = OrderStatus.picking;
          break;
        case OrderStatus.picking:
          nextStatus = OrderStatus.outForDelivery;
          break;
        case OrderStatus.outForDelivery:
          nextStatus = OrderStatus.delivered;
          timer.cancel();
          break;
        case OrderStatus.delivered:
        case OrderStatus.cancelled:
          timer.cancel();
          return;
      }

      final updated = current.copyWith(
        status: nextStatus,
        estimatedDeliveryMinutes: nextStatus == OrderStatus.delivered
            ? 0
            : (current.estimatedDeliveryMinutes > 3 ? current.estimatedDeliveryMinutes - 3 : 2),
      );

      _orders[index] = updated;
      if (_activeTrackingOrder?.id == orderId) {
        _activeTrackingOrder = updated;
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }
}
