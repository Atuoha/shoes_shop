import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoes_shop/models/checked_out_item.dart';
import 'package:shoes_shop/resources/styles_manager.dart';

import '../../constants/color.dart';
import '../../constants/firebase_refs/collections.dart';
import '../../models/buyer.dart';
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../widgets/item_row.dart';
import 'package:intl/intl.dart' as intl;

import '../widgets/k_cached_image.dart';

class SingleVendorCheckOutListTile extends StatefulWidget {
  const SingleVendorCheckOutListTile({
    super.key,
    required this.checkoutItem,
  });

  final CheckedOutItem checkoutItem;

  @override
  State<SingleVendorCheckOutListTile> createState() =>
      _SingleVendorCheckOutListTileState();
}

class _SingleVendorCheckOutListTileState
    extends State<SingleVendorCheckOutListTile> {
  Buyer buyer = Buyer.initial();

  // fetch customer details
  Future<void> fetchCustomerDetails() async {
    await FirebaseCollections.customersCollection
        .doc(widget.checkoutItem.customerId)
        .get()
        .then((DocumentSnapshot data) {
      setState(() {
        buyer = Buyer.fromJson(data);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCustomerDetails();
  }

  @override
  Widget build(BuildContext context) {
    // bottom sheet modal
    Future<void> showCheckOutInBottom() async {
      return await showModalBottomSheet(
        context: context,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                KCachedImage(
                  image: widget.checkoutItem.prodImg,
                  height:100,
                  width:120,
                ),

                const SizedBox(height: 10),
                Text(
                  widget.checkoutItem.prodName,
                  style: getMediumStyle(
                    color: Colors.black,
                    fontSize: FontSize.s20,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ItemRow(
                      value: widget.checkoutItem.prodPrice.toString(),
                      title: 'Product Price: ',
                    ),
                    ItemRow(
                      value: widget.checkoutItem.isDelivered ? 'Yes' : 'No',
                      title: 'Delivered Product: ',
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ItemRow(
                      value: widget.checkoutItem.prodSize,
                      title: 'Selected Size: ',
                    ),
                    ItemRow(
                      value: widget.checkoutItem.prodQuantity.toString(),
                      title: 'Product Quantity: ',
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ItemRow(
                  value:
                      intl.DateFormat.yMMMEd().format(widget.checkoutItem.date),
                  title: 'Order Date: ',
                ),
                const SizedBox(height: 15),
                Text(
                  'Purchased by:',
                  style: getRegularStyle(
                    color: greyFontColor,
                    fontSize: FontSize.s16,
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    border: TableBorder.all(
                        width: 1,
                        color: greyFontColor,
                        borderRadius: BorderRadius.circular(5)),
                    columns: [
                      DataColumn(
                        label: Text(
                          'Customer Name',
                          style: getMediumStyle(color: Colors.black),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Customer Email',
                          style: getMediumStyle(color: Colors.black),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Customer Address',
                          style: getMediumStyle(color: Colors.black),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Customer Phone',
                          style: getMediumStyle(color: Colors.black),
                        ),
                      ),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(Text(buyer.fullname)),
                          DataCell(Text(buyer.email)),
                          DataCell(Text(buyer.address)),
                          DataCell(Text(buyer.phone)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return InkWell(
      onTap: () => showCheckOutInBottom(),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CachedNetworkImage(
              imageUrl: widget.checkoutItem.prodImg,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                radius: 30,
                backgroundImage: imageProvider,
              ),
              placeholder: (context, url) => const CircleAvatar(
                backgroundImage: AssetImage(
                  AssetManager.placeholderImg,
                ),
              ),
              errorWidget: (context, url, error) => const CircleAvatar(
                backgroundImage: AssetImage(
                  AssetManager.placeholderImg,
                ),
              ),
            ),
            title: Text(widget.checkoutItem.prodName),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$${widget.checkoutItem.prodPrice}'),
                Text('Quantity: ${widget.checkoutItem.prodQuantity}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
