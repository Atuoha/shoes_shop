// import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/color.dart';
import '../../providers/cart.dart';

class CartIcon extends StatelessWidget {
  const CartIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);

    return  Badge(
      backgroundColor: Colors.white,
      label: Text(
        '${cartProvider.getCartQuantity}',
        style: const TextStyle(
          color: primaryColor,
        ),
      ),
      child: const Icon(
        Icons.shopping_cart,
        color: accentColor,
      ),
    );
  }
}