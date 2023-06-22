import 'package:flutter/material.dart';
import 'package:shoes_shop/views/widgets/k_cached_image.dart';

import '../../models/product.dart';


class SingleVendorProductListTile extends StatelessWidget {
  const SingleVendorProductListTile({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: KCachedImage(
            image: product.imgUrls[0],
            isCircleAvatar: true,
            radius: 30,
          ),
          title: Text(product.productName),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$${product.price}'),
              Text('Quantity: ${product.quantity}'),
            ],
          ),
        ),
      ),
    );
  }
}
