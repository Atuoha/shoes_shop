import 'package:flutter/material.dart';
import 'package:shoes_shop/controllers/route_manager.dart';

import '../../../constants/color.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  // navigate to create product
  void navigateToCreate() {
    Navigator.of(context).pushNamed(RouteManager.vendorCreatePost);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('All Products'),
        actions: [
          IconButton(
            onPressed: () => navigateToCreate(),
            icon: const Icon(
              Icons.add,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
