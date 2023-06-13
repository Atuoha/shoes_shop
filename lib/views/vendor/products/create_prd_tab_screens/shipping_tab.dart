import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants/color.dart';
import '../../../../providers/product.dart';

class ShippingTab extends StatefulWidget {
  const ShippingTab({Key? key}) : super(key: key);

  @override
  State<ShippingTab> createState() => _ShippingTabState();
}

class _ShippingTabState extends State<ShippingTab> {
  bool chargingForShipping = false;
  final TextEditingController billingAmount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductData>(context);

    // submit data
    void submitData() {
      if (chargingForShipping) {
        productProvider.updateProductShippingInfo(
          isCharging: chargingForShipping,
          billingAmount: double.parse(
            billingAmount.text.trim(),
          ),
        );
      } else {
        productProvider.updateProductShippingInfo(
          isCharging: chargingForShipping,
          billingAmount: 0.0,
        );
      }

      productProvider.updateProductShippingInfo();
    }

    return Scaffold(
      floatingActionButton:
          !productProvider.isProductShippingInfoSubmittedStatus
              ? FloatingActionButton(
                  onPressed: () => submitData(),
                  child: const Icon(
                    Icons.check_circle,
                  ),
                )
              : const SizedBox.shrink(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 20,
        ),
        child: Column(
          children: [
            CheckboxListTile(
              checkColor: Colors.white,
              activeColor: accentColor,
              side: const BorderSide(
                color: accentColor,
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              title: const Text('Do you want to bill for shipping?'),
              value: chargingForShipping,
              onChanged: (value) => setState(
                () {
                  chargingForShipping = value!;
                },
              ),
            ),
            chargingForShipping
                ? TextFormField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    controller: billingAmount,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Billing amount can not be empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter billing amount',
                      labelText: 'Billing amount',
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
