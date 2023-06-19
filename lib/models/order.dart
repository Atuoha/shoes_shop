import 'cart.dart';

class OrderItem {
  final String id;
  final double totalAmount;
  final List<Cart> products;
  final DateTime orderDate;

  OrderItem({
    required this.id,
    required this.products,
    required this.totalAmount,
    required this.orderDate,
  });
}
