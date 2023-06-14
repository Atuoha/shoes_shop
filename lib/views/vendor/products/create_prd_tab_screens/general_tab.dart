import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_shop/views/widgets/loading_widget.dart';
import '../../../../constants/color.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../providers/product.dart';
import '../../../../resources/styles_manager.dart';
import '../../../widgets/message_alert.dart';

// ignore: must_be_immutable
class GeneralTab extends StatefulWidget {
  GeneralTab({
    Key? key,
    this.showAlert = false,
  }) : super(key: key);
  bool showAlert;

  @override
  State<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab> {
  final formKey = GlobalKey<FormState>();
  final productName = TextEditingController();
  final productPrice = TextEditingController();
  final productDescription = TextEditingController();
  final productQuantity = TextEditingController();

  DateTime selectedDate = DateTime.now();
  bool isDateSelected = false;

  var currentCategory = '';
  List<String> categories = [];

  bool isFetchingCategories = true;
  bool isLoading = false;

  bool dateSelected = false;

  // pick date
  Future pickDate() async {
    var pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        isDateSelected = true;
        selectedDate = pickedDate;
      });
    }
  }

  void fetchCategories() async {
    await FirebaseFirestore.instance
        .collection('categories')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        categories.add(doc['category']);
      }

      setState(() {
        isFetchingCategories = false;
      });
    });
  }

  // showInstruction
  showInstruction() {
    messageDialog(
      title: 'Instructions',
      content:
          'After filling every detail you want on each product detail tab, click the check button so that it can be saved for you.',
      context: context,
    );
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.showAlert) {
        Future.delayed(const Duration(seconds: 2), showInstruction());
        setState(() {
          widget.showAlert = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductData>(context);

    // submit data
    Future<void> submitData() async {
      var valid = formKey.currentState!.validate();

      if (!valid) {
        return;
      }

      // setState(() {
      //   isLoading = true;
      // });
      productProvider.updateProductGeneralData(
        productName: productName.text.trim(),
        price: double.parse(productPrice.text.trim()),
        quantity: int.parse(productQuantity.text.trim()),
        category: currentCategory,
        description: productDescription.text.trim(),
        scheduleDate: selectedDate,
      );

      productProvider.updateProductGeneralInfoState();
    }

    return Scaffold(
      floatingActionButton: !productProvider.isProductGeneralInfoSubmittedStatus
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
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: !isLoading
                ? Column(
                    children: [
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: productName,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Product name can not be empty';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter product name',
                          labelText: 'Product Name',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        controller: productPrice,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Product price can not be empty';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter product price',
                          labelText: 'Product Price',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        controller: productQuantity,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Product quantity can not be empty';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter product quantity',
                          labelText: 'Product Quantity',
                        ),
                      ),
                      const SizedBox(height: 20),
                      !isFetchingCategories
                          ? DropdownButtonFormField(
                              hint: const Text('Select Category'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please select category';
                                }
                                return null;
                              },
                              items: categories
                                  .map(
                                    (item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(item),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  currentCategory = value!;
                                });
                              })
                          : const LoadingWidget(size: 50),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        maxLines: 7,
                        maxLength: 500,
                        controller: productDescription,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Product description can not be empty';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter product description',
                          labelText: 'Product Description',
                        ),
                      ),
                      const SizedBox(height: 5),

                      // schedule....
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => pickDate(),
                            child: Text(
                              'Schedule date',
                              style: getRegularStyle(color: accentColor),
                            ),
                          ),
                          isDateSelected
                              ? Text(
                                  'Selected Date:  ${intl.DateFormat.yMMMEd().format(selectedDate)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ],
                  )
                : const Center(
                    child: LoadingWidget(size: 50),
                  ),
          ),
        ),
      ),
      bottomSheet: productProvider.isProductGeneralInfoSubmittedStatus
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Saved general details successfully',
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
