import 'package:flutter/material.dart';
import 'package:shoes_shop/constants/enums/quantity_operation.dart';

import '../models/cart.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, Cart> _cartItems = {};

  Map<String, Cart> get getCartItems => {..._cartItems};

  // get cart item length
  get findCartQuantity => _cartItems.isEmpty ? 0 : getCartItems.length;

  // get cart total amount
  double cartTotalAmount() {
    double totalAmount = 0.0;

    _cartItems.forEach((key, value) {
      totalAmount += value.price * value.quantity;
    });

    return totalAmount;
  }

  // get product quantity on cart
  int productQuantityOnCart(String prodId) {
    int quantity = 0;
    _cartItems.forEach((key, value) {
      if (key == prodId) {
        quantity += value.quantity;
      }
    });

    return quantity;
  }

  // increment or decrement product in cart
  void toggleQuantity(QuantityOperation operation, String cartId) {
    switch (operation) {
      case QuantityOperation.increment:
        _cartItems.update(
          cartId,
          (existingCartItem) => Cart(
            cartId: existingCartItem.cartId,
            prodId: existingCartItem.prodId,
            vendorId: existingCartItem.vendorId,
            quantity: existingCartItem.quantity + 1,
            prodSize: existingCartItem.prodSize,
            price: existingCartItem.price,
            date: existingCartItem.date,
          ),
        );
        break;

      case QuantityOperation.decrement:
        _cartItems.update(
          cartId,
          (existingCartItem) => Cart(
            cartId: existingCartItem.cartId,
            prodId: existingCartItem.prodId,
            vendorId: existingCartItem.vendorId,
            quantity: existingCartItem.quantity - 1,
            prodSize: existingCartItem.prodSize,
            price: existingCartItem.price,
            date: existingCartItem.date,
          ),
        );
        break;
    }
    notifyListeners();
  }

  void addToCart(Cart cartItem) {
    _cartItems.putIfAbsent(cartItem.prodId, () => cartItem);

    if (_cartItems.containsKey(cartItem.prodId)) {
      _cartItems.update(
        cartItem.cartId,
        (existingCartItem) => Cart(
          cartId: cartItem.cartId,
          prodId: cartItem.prodId,
          vendorId: cartItem.vendorId,
          quantity: existingCartItem.quantity + 1,
          prodSize: cartItem.prodSize,
          price: cartItem.price,
          date: cartItem.date,
        ),
      );
    } else {
      _cartItems.putIfAbsent(cartItem.cartId, () => cartItem);
    }
  }

  // removing item from cart
  void removeFromCart(String cartId) {
    _cartItems.remove(cartId);
    notifyListeners();
  }

  // clear cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // checking if item is on cart
  bool isItemOnCart(String cartId) => _cartItems.containsKey(cartId);
}
