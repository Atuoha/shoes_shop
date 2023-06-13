import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/product.dart';

class ShippingTab extends StatelessWidget {
  const ShippingTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductData>(context);

    return  Scaffold(
        floatingActionButton: !productProvider.isProductShippingInfoSubmittedStatus ? FloatingActionButton(
          onPressed: () => null,
          child: const Icon(
            Icons.check_circle,
          ),
        ): const SizedBox.shrink(),
        body:Center(child: Text('Shipping Tab')));
  }
}
