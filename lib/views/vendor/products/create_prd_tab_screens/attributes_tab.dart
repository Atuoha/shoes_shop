import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/product.dart';

class AttributesTab extends StatelessWidget {
  const AttributesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductData>(context);

    return Scaffold(
      floatingActionButton: !productProvider.isProductAttributesSubmittedStatus
          ? FloatingActionButton(
              onPressed: () => null,
              child: const Icon(
                Icons.check_circle,
              ),
            )
          : const SizedBox.shrink(),
      body: const Center(
        child: Text('Attributes Tab'),
      ),
    );
  }
}
