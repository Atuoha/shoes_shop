class Product {
  final String prodId;
  final String vendorId;
  final String productName;
  final double price;
  final int quantity;
  final String category;
  final String description;
  final DateTime scheduleDate;
  final bool isCharging;
  final double billingAmount;
  final String brandName;
  final List<String> sizesAvailable;
  final List<String> downLoadImgUrls;
  final DateTime uploadDate;

  Product({
    required this.prodId,
    required this.vendorId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.category,
    required this.description,
    required this.scheduleDate,
    required this.isCharging,
    required this.billingAmount,
    required this.brandName,
    required this.sizesAvailable,
    required this.downLoadImgUrls,
    required this.uploadDate,
  });
}
