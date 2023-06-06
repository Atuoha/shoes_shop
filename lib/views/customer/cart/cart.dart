import 'package:flutter/material.dart';

import '../../../constants/color.dart';
import '../../../resources/assets_manager.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AssetManager.empty),
        const SizedBox(height: 20),
        const Text('Opps! Cart is empty'),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
          ),
          onPressed: () => null,
          child: const Text('Continue shopping'),
        )
      ],
    );
  }
}
