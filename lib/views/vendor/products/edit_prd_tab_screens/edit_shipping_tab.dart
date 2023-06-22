import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants/color.dart';
import '../../../../models/product.dart';
import '../../../../providers/product.dart';
import '../../../../resources/styles_manager.dart';

class EditShippingTab extends StatefulWidget {
  const EditShippingTab({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  State<EditShippingTab> createState() => _EditShippingTabState();
}

class _EditShippingTabState extends State<EditShippingTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool chargingForShipping = false;
  final TextEditingController billingAmount = TextEditingController();

  // assign data from product
  void assignData() {
    setState(() {
      billingAmount.text = widget.product.billingAmount.toString();
      chargingForShipping = widget.product.isCharging;
    });
  }

  @override
  void initState() {
    super.initState();

    assignData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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

      productProvider.updateProductShippingInfoState();
      // billingAmount.clear();
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => submitData(),
        child: const Icon(
          Icons.save,
        ),
      ),
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
      bottomSheet: productProvider.isProductShippingInfoSubmittedStatus
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Saved shipping details successfully',
                    style: getRegularStyle(color: accentColor),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.check_circle_outline,
                    color: accentColor,
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
