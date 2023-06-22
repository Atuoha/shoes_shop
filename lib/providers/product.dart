import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductData extends ChangeNotifier {
  bool _isProductAttributesSubmitted = false;
  bool _isProductShippingInfoSubmitted = false;
  bool _isProductGeneralInfoSubmitted = false;

  // updateProductAttributesState
  void updateProductAttributeState() {
    _isProductAttributesSubmitted = !_isProductAttributesSubmitted;
    notifyListeners();
  }

  // updateProductShippingInfoState
  void updateProductShippingInfoState() {
    _isProductShippingInfoSubmitted = !_isProductShippingInfoSubmitted;
    notifyListeners();
  }

  // updateProductGeneralInfoState
  void updateProductGeneralInfoState() {
    _isProductGeneralInfoSubmitted = !_isProductGeneralInfoSubmitted;
    notifyListeners();
  }

  bool isDoneSubmittingDetails() {
    bool status = false;
    if (_isProductAttributesSubmitted &&
        _isProductGeneralInfoSubmitted &&
        _isProductShippingInfoSubmitted &&
        productData['imgUrls'] != null) {
      status = true;
    }
    return status;
  }

  // get product attributes submit status
  get isProductAttributesSubmittedStatus => _isProductAttributesSubmitted;

  // get product general info submit status
  get isProductGeneralInfoSubmittedStatus => _isProductGeneralInfoSubmitted;

  // get product shipping info status
  get isProductShippingInfoSubmittedStatus => _isProductShippingInfoSubmitted;

  Map<String, dynamic> productData = {};

  void resetProductData() {
    productData = {};
    notifyListeners();
  }

  // update product general data
  updateProductGeneralData({
    String? productName,
    double? price,
    int? quantity,
    String? category,
    String? description,
    DateTime? scheduleDate,
    List<XFile?>? productImages,
  }) {
    productData['productName'] = productName;
    productData['price'] = price;
    productData['quantity'] = quantity;
    productData['category'] = category;
    productData['description'] = description;
    productData['scheduleDate'] = scheduleDate;

    notifyListeners();
  }

  // update product shipping info
  updateProductShippingInfo({bool? isCharging, double? billingAmount}) {
    productData['isCharging'] = isCharging;
    productData['billingAmount'] = billingAmount;
    notifyListeners();
  }

  // update product attributes info
  updateProductAttributesInfo(
      {String? brandName, List<String>? sizesAvailable}) {
    productData['brandName'] = brandName;
    productData['sizesAvailable'] = sizesAvailable;

    notifyListeners();
  }

  // update product images
  updateProductImg({List<String>? imgUrls}) {
    productData['imgUrls'] = imgUrls;
    notifyListeners();
  }

  // clear product images
  clearProductImg() {
    productData['imgUrls'] = null;
    notifyListeners();
  }

  // checking if product images is null
  bool isProductImagesNull() => productData['imgUrls'] == null ? true : false;
}
