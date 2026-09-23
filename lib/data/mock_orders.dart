import '../models/order.dart';
import '../models/cart_item.dart';
import '../models/address.dart';
import 'mock_products.dart';

class MockOrders {
  static final Address _defaultAddress = const Address(
    id: 'addr-1',
    fullName: 'Sanchita',
    phoneNumber: '+91 98765 43210',
    houseFlatNumber: 'Flat 402, Lotus Heights',
    buildingName: 'Sector 20',
    streetArea: 'Kharghar',
    landmark: 'Near Central Park',
    city: 'Navi Mumbai',
    state: 'Maharashtra',
    pinCode: '410210',
    addressType: AddressType.home,
    isDefault: true,
  );

  static List<Order> getInitialOrders() {
    return [
      Order(
        id: 'QB10245',
        items: [
          CartItem(product: MockProducts.products[0], quantity: 2), // Bananas
          CartItem(product: MockProducts.products[1], quantity: 1), // Tomatoes
          CartItem(product: MockProducts.products[8], quantity: 2), // Milk
          CartItem(product: MockProducts.products[22], quantity: 3), // Maggi
        ],
        itemTotal: 307.0,
        discountAmount: 50.0,
        deliveryFee: 0.0,
        handlingFee: 5.0,
        tipAmount: 20.0,
        finalTotal: 282.0,
        couponCode: 'SAVE50',
        deliveryAddress: _defaultAddress,
        paymentMethod: 'UPI (Google Pay)',
        status: OrderStatus.delivered,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        estimatedDeliveryMinutes: 14,
        deliveryPartnerName: 'Rahul Sharma',
        deliveryPartnerRating: 4.8,
      ),
      Order(
        id: 'QB10182',
        items: [
          CartItem(product: MockProducts.products[5], quantity: 1), // Apples
          CartItem(product: MockProducts.products[6], quantity: 1), // Mangoes
          CartItem(product: MockProducts.products[9], quantity: 1), // Butter
          CartItem(product: MockProducts.products[10], quantity: 1), // Cheese
          CartItem(product: MockProducts.products[12], quantity: 1), // Bread
          CartItem(product: MockProducts.products[13], quantity: 1), // Eggs
          CartItem(product: MockProducts.products[15], quantity: 2), // Lays
        ],
        itemTotal: 708.0,
        discountAmount: 100.0,
        deliveryFee: 0.0,
        handlingFee: 5.0,
        tipAmount: 0.0,
        finalTotal: 613.0,
        couponCode: 'FIRST100',
        deliveryAddress: _defaultAddress,
        paymentMethod: 'Credit Card',
        status: OrderStatus.delivered,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        estimatedDeliveryMinutes: 18,
        deliveryPartnerName: 'Amit Verma',
        deliveryPartnerRating: 4.9,
      ),
      Order(
        id: 'QB10091',
        items: [
          CartItem(product: MockProducts.products[33], quantity: 1), // Dove Shampoo
          CartItem(product: MockProducts.products[35], quantity: 2), // Lux Soap
          CartItem(product: MockProducts.products[37], quantity: 1), // Colgate
        ],
        itemTotal: 396.0,
        discountAmount: 20.0,
        deliveryFee: 0.0,
        handlingFee: 5.0,
        tipAmount: 10.0,
        finalTotal: 391.0,
        couponCode: '',
        deliveryAddress: _defaultAddress,
        paymentMethod: 'Cash on Delivery',
        status: OrderStatus.delivered,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        estimatedDeliveryMinutes: 12,
        deliveryPartnerName: 'Sunil Patil',
        deliveryPartnerRating: 4.7,
      ),
    ];
  }
}
