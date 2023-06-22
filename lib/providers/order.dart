import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../models/checked_out_item.dart';
import '../models/order.dart';

class OrderProvider extends ChangeNotifier {
  final List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(double totalAmount, List<Cart> products) {
    var newOrder = OrderItem(
      id: DateTime.now().toString(),
      products: products,
      totalAmount: totalAmount,
      orderDate: DateTime.now(),
    );
    _orders.insert(0, newOrder);
    notifyListeners();
  }

  double get getTotal {
    var total = 0.0;
    for (var order in _orders) {
      total += order.totalAmount;
    }
    return total;
  }

  void removeOrder(id) {
    _orders.removeWhere((order) => order.id == id);
    notifyListeners();
  }

  void clearOrder() {
    _orders.clear();
    notifyListeners();
  }
}
