import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:blinkcart/models/product.dart';
import 'package:blinkcart/providers/cart_provider.dart';
import 'package:blinkcart/providers/wishlist_provider.dart';
import 'package:blinkcart/widgets/quantity_selector.dart';
import 'package:blinkcart/widgets/product_card.dart';
import 'package:blinkcart/core/widgets/empty_state_view.dart';
import 'package:blinkcart/core/widgets/rating_badge.dart';
import 'package:blinkcart/core/widgets/delivery_badge.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('RatingBadge renders rating score and count', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RatingBadge(rating: 4.8, reviewCount: 120),
        ),
      ),
    );

    expect(find.text('4.8'), findsOneWidget);
    expect(find.text('(120)'), findsOneWidget);
  });

  testWidgets('DeliveryBadge renders delivery time', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DeliveryBadge(text: '12 MINS', isCompact: true),
        ),
      ),
    );

    expect(find.text('12 MINS'), findsOneWidget);
  });

  testWidgets('EmptyStateView renders title, description, and button', (WidgetTester tester) async {
    bool buttonClicked = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmptyStateView(
            icon: Icons.shopping_bag_outlined,
            title: 'Your cart is empty',
            description: 'Add fresh items to your cart.',
            buttonText: 'Shop Now',
            onButtonPressed: () {
              buttonClicked = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Your cart is empty'), findsOneWidget);
    expect(find.text('Add fresh items to your cart.'), findsOneWidget);
    expect(find.text('Shop Now'), findsOneWidget);

    await tester.tap(find.text('Shop Now'));
    await tester.pump();
    expect(buttonClicked, isTrue);
  });

  testWidgets('QuantitySelector displays ADD when quantity is 0 and +/- when > 0', (WidgetTester tester) async {
    int quantity = 0;

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          return MaterialApp(
            home: Scaffold(
              body: QuantitySelector(
                quantity: quantity,
                onAdd: () {
                  setState(() => quantity = 1);
                },
                onIncrease: () {
                  setState(() => quantity++);
                },
                onDecrease: () {
                  setState(() => quantity--);
                },
              ),
            ),
          );
        },
      ),
    );

    // Initial state: ADD button
    expect(find.text('ADD'), findsOneWidget);

    // Tap ADD
    await tester.tap(find.text('ADD'));
    await tester.pumpAndSettle();

    // Now quantity is 1: delete icon and add icon are visible with count '1'
    expect(find.text('1'), findsOneWidget);
    expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);

    // Tap +
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();
    expect(find.text('2'), findsOneWidget);
    expect(find.byIcon(Icons.remove_rounded), findsOneWidget);

    // Tap -
    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('ProductCard displays name, unit, price and discount', (WidgetTester tester) async {
    const product = Product(
      id: 'p_test',
      name: 'Fresh Alphonso Mangoes',
      brand: 'Farm Fresh',
      category: 'Fruits & Vegetables',
      description: 'Handpicked premium Alphonso mangoes from Ratnagiri.',
      price: 349.0,
      originalPrice: 499.0,
      discountPercentage: 30,
      rating: 4.9,
      reviewCount: 420,
      image: 'mangoes',
      unit: '1 kg (Approx 4 pcs)',
      stock: 15,
      isFeatured: true,
      highlights: ['Sweet & Aromatic'],
      specifications: {'Origin': 'Ratnagiri'},
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: ProductCard(product: product),
          ),
        ),
      ),
    );

    expect(find.text('Fresh Alphonso Mangoes'), findsOneWidget);
    expect(find.text('1 kg (Approx 4 pcs)'), findsOneWidget);
    expect(find.text('₹349'), findsOneWidget);
    expect(find.text('₹499'), findsOneWidget);
    expect(find.text('30% OFF'), findsOneWidget);
  });
}
