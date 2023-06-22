import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product.dart';
import '../models/request_result.dart';
import '../models/success.dart';

class ProductController {
  final firebase = FirebaseFirestore.instance;

  Future<RequestResult> createProduct({required Product product}) async {
    try {
      firebase.collection('products').doc(product.prodId).set({
        'prodId': product.prodId,
        'vendorId': product.vendorId,
        'productName': product.productName,
        'price': product.price,
        'quantity': product.quantity,
        'category': product.category,
        'description': product.description,
        'scheduleDate': product.scheduleDate,
        'isCharging': product.isCharging,
        'billingAmount': product.billingAmount,
        'brandName': product.brandName,
        'sizesAvailable': product.sizesAvailable,
        'imgUrls': product.imgUrls,
        'uploadDate': product.uploadDate,
        'isFav': product.isFav,
        'isApproved': product.isApproved,
      });

      return RequestResult.success(Success(msg: 'Upload successfully'));
    } on FirebaseException catch (e) {
      return RequestResult.error('Error with uploading');
    } catch (e) {
      return RequestResult.error('Error occurred!');
    }
  }


  // edit product
  Future<RequestResult> editProduct({required Product product}) async {
    try {
      firebase.collection('products').doc(product.prodId).update({
        'prodId': product.prodId,
        'vendorId': product.vendorId,
        'productName': product.productName,
        'price': product.price,
        'quantity': product.quantity,
        'category': product.category,
        'description': product.description,
        'scheduleDate': product.scheduleDate,
        'isCharging': product.isCharging,
        'billingAmount': product.billingAmount,
        'brandName': product.brandName,
        'sizesAvailable': product.sizesAvailable,
        'imgUrls': product.imgUrls,
        'uploadDate': product.uploadDate,
        'isFav': product.isFav,
        'isApproved': product.isApproved,
      });

      return RequestResult.success(Success(msg: 'Upload successfully'));
    } on FirebaseException catch (e) {
      return RequestResult.error('Error with uploading');
    } catch (e) {
      return RequestResult.error('Error occurred!');
    }
  }
}
