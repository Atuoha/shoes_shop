import 'package:flutter/material.dart';
import 'package:shoes_shop/constants/enums/quantity_operation.dart';

import '../models/cart.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, Cart> _cartItems = {};

  Map<String, Cart> get getCartItems => {..._cartItems};

  // get cart item length
  get getCartQuantity => _cartItems.isEmpty ? 0 : getCartItems.length;

  // is cart empty
  bool isItemEmpty() => _cartItems.isEmpty ? true : false;

  // get cart total amount
  double getCartTotalAmount() {
    double totalAmount = 0.0;

    _cartItems.forEach((key, value) {
      totalAmount += value.price * value.quantity;
    });

    return totalAmount;
  }

  // get product quantity on cart
  int getProductQuantityOnCart(String prodId) {
    int quantity = 0;
    _cartItems.forEach((key, value) {
      if (key == prodId) {
        quantity += value.quantity;
      }
    });

    return quantity;
  }

  // increase quantity
  void increaseQuantity(String prodId) {
    _cartItems.forEach((key, value) {
      if (key == prodId) {
        value.increaseQuantity();
      }
    });
    notifyListeners();
  }

  // decrease quantity
  void decreaseQuantity(String prodId) {
    _cartItems.forEach((key, value) {
      if (key == prodId) {
        if (value.quantity > 1) {
          value.decreaseQuantity();
        }
      }
    });
    notifyListeners();
  }



  // increment or decrement product in cart | alternative method - (NOT CURRENTLY USED)
  void toggleQuantity(QuantityOperation operation, String cartId) {
    // another way you can implement this is by making use of the model and creating a method for increment and decrement

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
