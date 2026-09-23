import 'cart_item.dart';
import 'address.dart';

enum OrderStatus {
  placed,
  confirmed,
  picking,
  outForDelivery,
  delivered,
  cancelled,
}

class Order {
  final String id;
  final List<CartItem> items;
  final double itemTotal;
  final double discountAmount;
  final double deliveryFee;
  final double handlingFee;
  final double tipAmount;
  final double finalTotal;
  final String couponCode;
  final Address deliveryAddress;
  final String paymentMethod;
  final OrderStatus status;
  final DateTime createdAt;
  final int estimatedDeliveryMinutes;
  final String deliveryPartnerName;
  final double deliveryPartnerRating;
  final String deliveryPartnerPhone;

  const Order({
    required this.id,
    required this.items,
    required this.itemTotal,
    this.discountAmount = 0,
    this.deliveryFee = 0,
    this.handlingFee = 5,
    this.tipAmount = 0,
    required this.finalTotal,
    this.couponCode = '',
    required this.deliveryAddress,
    required this.paymentMethod,
    this.status = OrderStatus.placed,
    required this.createdAt,
    this.estimatedDeliveryMinutes = 15,
    this.deliveryPartnerName = 'Rahul Sharma',
    this.deliveryPartnerRating = 4.8,
    this.deliveryPartnerPhone = '+91 98201 12345',
  });

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  String get statusDisplay {
    switch (status) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.picking:
        return 'Picking items';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      itemTotal: (json['itemTotal'] as num).toDouble(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0,
      handlingFee: (json['handlingFee'] as num?)?.toDouble() ?? 5,
      tipAmount: (json['tipAmount'] as num?)?.toDouble() ?? 0,
      finalTotal: (json['finalTotal'] as num).toDouble(),
      couponCode: json['couponCode'] as String? ?? '',
      deliveryAddress: Address.fromJson(json['deliveryAddress'] as Map<String, dynamic>),
      paymentMethod: json['paymentMethod'] as String,
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.placed,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      estimatedDeliveryMinutes: json['estimatedDeliveryMinutes'] as int? ?? 15,
      deliveryPartnerName: json['deliveryPartnerName'] as String? ?? 'Rahul Sharma',
      deliveryPartnerRating: (json['deliveryPartnerRating'] as num?)?.toDouble() ?? 4.8,
      deliveryPartnerPhone: json['deliveryPartnerPhone'] as String? ?? '+91 98201 12345',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((e) => e.toJson()).toList(),
      'itemTotal': itemTotal,
      'discountAmount': discountAmount,
      'deliveryFee': deliveryFee,
      'handlingFee': handlingFee,
      'tipAmount': tipAmount,
      'finalTotal': finalTotal,
      'couponCode': couponCode,
      'deliveryAddress': deliveryAddress.toJson(),
      'paymentMethod': paymentMethod,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'estimatedDeliveryMinutes': estimatedDeliveryMinutes,
      'deliveryPartnerName': deliveryPartnerName,
      'deliveryPartnerRating': deliveryPartnerRating,
      'deliveryPartnerPhone': deliveryPartnerPhone,
    };
  }

  Order copyWith({
    String? id,
    List<CartItem>? items,
    double? itemTotal,
    double? discountAmount,
    double? deliveryFee,
    double? handlingFee,
    double? tipAmount,
    double? finalTotal,
    String? couponCode,
    Address? deliveryAddress,
    String? paymentMethod,
    OrderStatus? status,
    DateTime? createdAt,
    int? estimatedDeliveryMinutes,
    String? deliveryPartnerName,
    double? deliveryPartnerRating,
    String? deliveryPartnerPhone,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      itemTotal: itemTotal ?? this.itemTotal,
      discountAmount: discountAmount ?? this.discountAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      handlingFee: handlingFee ?? this.handlingFee,
      tipAmount: tipAmount ?? this.tipAmount,
      finalTotal: finalTotal ?? this.finalTotal,
      couponCode: couponCode ?? this.couponCode,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      estimatedDeliveryMinutes: estimatedDeliveryMinutes ?? this.estimatedDeliveryMinutes,
      deliveryPartnerName: deliveryPartnerName ?? this.deliveryPartnerName,
      deliveryPartnerRating: deliveryPartnerRating ?? this.deliveryPartnerRating,
      deliveryPartnerPhone: deliveryPartnerPhone ?? this.deliveryPartnerPhone,
    );
  }
}
