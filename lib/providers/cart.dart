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
            prodName: existingCartItem.prodName,
            prodImg: existingCartItem.prodImg,
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
            prodName: existingCartItem.prodName,
            prodImg: existingCartItem.prodImg,
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

  // checking if item is on cart
  bool isItemOnCart(String prodId) => _cartItems.containsKey(prodId);

  void addToCart(Cart cartItem) {
    if (isItemOnCart(cartItem.prodId)) {
      _cartItems.update(
        cartItem.cartId,
        (existingCartItem) => Cart(
          cartId: existingCartItem.cartId,
          prodId: existingCartItem.prodId,
          prodName: existingCartItem.prodName,
          prodImg: existingCartItem.prodImg,
          vendorId: existingCartItem.vendorId,
          quantity: existingCartItem.quantity + 1,
          prodSize: existingCartItem.prodSize,
          price: existingCartItem.price,
          date: existingCartItem.date,
        ),
      );
    } else {
      _cartItems.putIfAbsent(cartItem.prodId, () => cartItem);
    }
    notifyListeners();
  }

  // removing item from cart
  void removeFromCart(String prodId) {
    _cartItems.remove(prodId);
    notifyListeners();
  }

  // clear cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
