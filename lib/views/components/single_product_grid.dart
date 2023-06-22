import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/cart.dart';
import '../../models/product.dart';
import '../../providers/cart.dart';

import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';
import '../widgets/k_cached_image.dart';

class SingleProductGridItem extends StatelessWidget {
  const SingleProductGridItem({
    super.key,
    required this.product,
    required this.size,
  });

  final Product product;
  final Size size;

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    Uuid uuid = const Uuid();

    // toggle cart action
    void toggleCartAction() {
      if (cartProvider.isItemOnCart(product.prodId)) {
        cartProvider.removeFromCart(product.prodId);
      } else {
        Cart cartItem = Cart(
          cartId: uuid.v4(),
          prodId: product.prodId,
          prodName: product.productName,
          prodImg: product.imgUrls[0],
          vendorId: product.vendorId,
          quantity: 1,
          prodSize: product.sizesAvailable[0],
          date: DateTime.now(),
          price: product.price,
        );

        cartProvider.addToCart(cartItem);
      }
    }

    return Stack(
      children: [
        KCachedImage(
          image: product.imgUrls[1],
          height: 205,
          width: double.infinity,
        ),
        Positioned(
          bottom: 3,
          left: 3,
          right: 3,
          child: Container(
            height: size.height / 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.topCenter,
                stops: const [0, 1],
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(.03),
                ],
              ),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: Text(
                        product.productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getMediumStyle(
                          color: Colors.black,
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price}',
                          style: getBoldStyle(
                            color: Colors.black,
                            fontSize: FontSize.s14,
                          ),
                        ),
                        InkWell(
                          onTap: () => toggleCartAction(),
                          child: Icon(
                            cartProvider.isItemOnCart(product.prodId)
                                ? Icons.shopping_cart
                                : Icons.shopping_cart_outlined,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
