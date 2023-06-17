class Cart {
  final String cartId;
  final String prodId;
  final int quantity;
  final String vendorId;
  final DateTime date;
  final String prodSize;

  Cart({
    required this.cartId,
    required this.prodId,
    required this.vendorId,
    required this.quantity,
    required this.prodSize,
    required this.date,
  });
}
