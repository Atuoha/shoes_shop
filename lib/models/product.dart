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
  final List<String> imgUrls;
  final DateTime uploadDate;
  bool isFav;
  bool isApproved;

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
    required this.imgUrls,
    required this.uploadDate,
    this.isFav = false,
    this.isApproved = false,
  });

  factory Product.initial() => Product(
        prodId: '',
        vendorId: '',
        productName: '',
        price: 0.0,
        quantity: 0,
        category: '',
        description: '',
        scheduleDate: DateTime.now(),
        isCharging: false,
        billingAmount: 0.0,
        brandName: '',
        sizesAvailable: [],
        imgUrls: [],
        uploadDate: DateTime.now(),
      );
}
