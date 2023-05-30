// import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import '../../constants/color.dart';

class CartIcon extends StatelessWidget {
  const CartIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Badge(
      backgroundColor: Colors.white,
      label: Text(
        '1',
        style: TextStyle(
          color: primaryColor,
        ),
      ),
      child: Icon(
        Icons.shopping_cart,
        color: accentColor,
      ),
    );
  }
}