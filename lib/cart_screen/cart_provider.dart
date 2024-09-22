import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];
  double _discount = 0.0;
  Map<String, PromoCode> _promoCodes = {};

  CartProvider() {
    // Initializing promo codes
    _promoCodes['OFFER10'] = PromoCode(
      discount: 10.0,
      expirationDate: DateTime(2024, 12, 31),
    );
    _promoCodes['FREESHIP'] = PromoCode(
      discount: 5.0,
      expirationDate: DateTime(2024, 12, 31),
    );
  }

  List<Map<String, dynamic>> get cartItems => _cartItems;
  double get discount => _discount;

  // Calculate total price before discount
  double get totalBeforeDiscount => _cartItems.fold<double>(
    0,
        (total, current) => total + (current['totalPrice'] as double),
  );

  // Calculate total price after discount
  double get totalAfterDiscount => totalBeforeDiscount - _discount;

  // Add or update product in the cart
  void addToCart(Map<String, dynamic> product) {
    final existingIndex = _cartItems.indexWhere((item) => item['id'] == product['id']);
    if (existingIndex >= 0) {
      // If product is already in the cart, increase the quantity and update total price
      _cartItems[existingIndex]['quantity'] += product['quantity'] ?? 1;
      _cartItems[existingIndex]['totalPrice'] = _cartItems[existingIndex]['price'] * _cartItems[existingIndex]['quantity'];
    } else {
      // Add new product to the cart with an initial quantity
      product['totalPrice'] = product['price'] * (product['quantity'] ?? 1);
      _cartItems.add(product);
    }
    notifyListeners();
  }

  // Remove product from the cart by ID
  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item['id'] == productId);
    notifyListeners();
  }

  // Clear all items from the cart and reset discount
  void clearCart() {
    _cartItems.clear();
    _discount = 0.0; // Reset discount when clearing the cart
    notifyListeners();
  }

  // Apply multiple promo codes to the cart
  void applyPromoCodes(List<String> codes) {
    double totalDiscount = 0.0;
    for (var code in codes) {
      var promoCode = _promoCodes[code];
      if (promoCode != null && _isValidPromoCode(promoCode)) {
        totalDiscount += promoCode.discount;
      }
    }
    _discount = totalDiscount;
    notifyListeners();
  }

  // Add a new promo code
  void addPromoCode(String code, PromoCode promoCode) {
    _promoCodes[code] = promoCode;
  }

  // Check if a promo code is still valid
  bool _isValidPromoCode(PromoCode promoCode) {
    DateTime now = DateTime.now();
    return now.isBefore(promoCode.expirationDate);
  }
}

class PromoCode {
  final double discount;
  final DateTime expirationDate;

  PromoCode({
    required this.discount,
    required this.expirationDate,
  });
}