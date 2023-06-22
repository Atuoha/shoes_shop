import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_shop/constants/color.dart';
import 'package:shoes_shop/resources/styles_manager.dart';
import '../../../../constants/enums/status.dart';
import '../../../../models/product.dart';
import '../../../../providers/product.dart';
import '../../../widgets/msg_snackbar.dart';

class EditAttributesTab extends StatefulWidget {
  const EditAttributesTab({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  State<EditAttributesTab> createState() => _EditAttributesTabState();
}

class _EditAttributesTabState extends State<EditAttributesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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

  // remove size
  void removeSize(int index) {
    setState(() {
      sizes.removeAt(index);
    });
  }

  // assign data from product
  void assignData() {
    setState(() {
      brandName.text = widget.product.brandName;
      sizes = widget.product.sizesAvailable;
    });
  }

  @override
  void initState() {
    super.initState();
    sizeAvailable.addListener(() {
      setState(() {});
    });
    assignData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final productProvider = Provider.of<ProductData>(context);
    Size size = MediaQuery.sizeOf(context);

    // submit data to provider
    submitData() {
      if (sizes.isEmpty || brandName.text.isEmpty) {
        displaySnackBar(
          status: Status.error,
          message: 'You have not fully filled the details',
          context: context,
        );
        return;
      }

      productProvider.updateProductAttributesInfo(
        brandName: brandName.text.trim(),
        sizesAvailable: sizes,
      );

      productProvider.updateProductAttributeState();
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
                      hintText: 'Enter size available(s,m,l,xl,xxl)',
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
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: gridBg,
                        child: Text(
                          sizes[index],
                          style: getRegularStyle(color: Colors.black),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: GestureDetector(
                          onTap: () => removeSize(index),
                          child: const CircleAvatar(
                            radius: 10,
                            backgroundColor: accentColor,
                            child: Icon(Icons.delete_forever,
                                color: Colors.white, size: 12),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomSheet: productProvider.isProductAttributesSubmittedStatus
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Saved attributes details successfully',
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
