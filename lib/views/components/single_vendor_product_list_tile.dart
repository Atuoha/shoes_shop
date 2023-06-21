import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../resources/assets_manager.dart';

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
          leading: CachedNetworkImage(
            imageUrl: product.imgUrls[0],
            imageBuilder: (context, imageProvider) => Hero(
              tag: product.prodId,
              child: CircleAvatar(
                radius: 30,
                backgroundImage: imageProvider,
              ),
            ),
            placeholder: (context, url) => const CircleAvatar(
              backgroundImage: AssetImage(
                AssetManager.placeholderImg,
              ),
            ),
            errorWidget: (context, url, error) =>
            const CircleAvatar(
              backgroundImage: AssetImage(
                AssetManager.placeholderImg,
              ),
            ),
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
