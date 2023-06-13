import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_shop/constants/color.dart';
import 'package:shoes_shop/resources/styles_manager.dart';
import '../../../../constants/enums/status.dart';
import '../../../../providers/product.dart';
import '../../../widgets/msg_snackbar.dart';

class AttributesTab extends StatefulWidget {
  const AttributesTab({Key? key}) : super(key: key);

  @override
  State<AttributesTab> createState() => _AttributesTabState();
}

class _AttributesTabState extends State<AttributesTab> {
  final TextEditingController brandName = TextEditingController();
  final TextEditingController sizeAvailable = TextEditingController();

  List<String> sizes = [];

  // addSize
  void addSize(String size) {
    setState(() {
      sizes.add(size.toUpperCase());
    });
    sizeAvailable.clear();
  }

  @override
  void initState() {
    super.initState();
    sizeAvailable.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductData>(context);
    Size size = MediaQuery.of(context).size;

    // submit data to provider
    submitData() {
      if (sizes.isEmpty || brandName.text.isEmpty) {
        displaySnackBar(
          status: Status.error,
          message: 'You have not fully filled the details',
          context: context,
        );
      }

      productProvider.updateProductAttributesInfo(
        brandName: brandName.text.trim(),
        sizesAvailable: sizes,
      );

      productProvider.updateProductAttributeState();
    }

    return Scaffold(
      floatingActionButton: !productProvider.isProductAttributesSubmittedStatus
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
            TextFormField(
              textInputAction: TextInputAction.next,
              controller: brandName,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Brand name can not be empty';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Enter brand name',
                labelText: 'Brand Name',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width / 2,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    controller: sizeAvailable,
                    decoration: const InputDecoration(
                      hintText: 'Enter size available',
                      labelText: 'Size Available',
                    ),
                  ),
                ),
                sizeAvailable.text.isNotEmpty
                    ? ElevatedButton(
                        onPressed: () => addSize(sizeAvailable.text.trim()),
                        child: const Text('Add Size'),
                      )
                    : const SizedBox.shrink()
              ],
            ),
            const SizedBox(height: 30),
            sizes.isNotEmpty
                ? Text(
                    'Sizes Available',
                    style: getMediumStyle(
                      color: Colors.black,
                    ),
                  )
                : const SizedBox.shrink(),
            SizedBox(
              height: size.height / 10,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: sizes.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    backgroundColor: gridBg,
                    child: Text(
                      sizes[index],
                      style: getRegularStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
