import 'package:cloud_firestore/cloud_firestore.dart';

class CheckedOutItem {
  final String orderId;
  final String vendorId;
  final String customerId;
  final String prodId;
  final String prodName;
  final String prodImg;
  final double prodPrice;
  final int prodQuantity;
  final String prodSize;
  final DateTime date;
  final bool isDelivered;
  final bool isApproved;

  CheckedOutItem({
    required this.orderId,
    required this.vendorId,
    required this.customerId,
    required this.prodId,
    required this.prodName,
    required this.prodImg,
    required this.prodPrice,
    required this.prodQuantity,
    required this.prodSize,
    required this.date,
    required this.isDelivered,
    required this.isApproved,
  });

  CheckedOutItem.fromJson(QueryDocumentSnapshot item)
      : this(
          orderId: item['orderId'],
          vendorId: item['vendorId'],
          customerId: item['customerId'],
          prodId: item['prodId'],
          prodName: item['prodName'],
          prodImg: item['prodImg'],
          prodPrice: double.parse(item['prodPrice'].toString()),
          prodQuantity: int.parse(item['prodQuantity'].toString()),
          prodSize: item['prodSize'],
          date: item['date'].toDate(),
          isDelivered: item['isDelivered'],
          isApproved: item['isApproved'],
        );
}
